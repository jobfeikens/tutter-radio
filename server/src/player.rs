use crate::common::{Metadata, MusicSource};
use crate::Playlist;
use anyhow::Result;
use async_std::channel::{bounded, Receiver, Sender};
use async_std::stream::interval;
use async_std::sync::{Condvar, Mutex, MutexGuard};
use async_std::task;
use async_trait::async_trait;
use futures::{try_join, StreamExt};
use std::error::Error;
use std::future::Future;
use std::sync::Arc;
use std::thread::sleep;
use std::time::Duration;
use ogg::Packet;
use ogg::reading::async_api::PacketReader;
use PlayerEvent::*;

#[derive(Clone, Debug)]
pub enum PlayerEvent {
    HeartBeat,
    PlayPause(bool),
    Listeners(usize),

    ClearPlaylists(),
    AddPlaylist(String, usize), // name length
    SelectPlaylist(usize, bool), // index, selected (selected by default)

    Ready,

    OpusFrame(Vec<u8>),
}

pub struct State {
    paused: bool,
    senders: Vec<Sender<PlayerEvent>>,
    metadata: Option<Metadata>,
    playlists: Vec<(Playlist, bool)>,
}

impl State {
    fn listeners(&self) -> usize {
        return self.senders.len();
    }
}

impl Default for State {
    fn default() -> Self {
        State {
            paused: true,
            senders: Default::default(),
            playlists: Default::default(),
            metadata: None,
        }
    }
}

pub struct Player {
    state: Arc<(Mutex<State>, Condvar)>,
}

impl Player {
    pub fn new() -> Self {
        Player {
            state: Arc::new((Mutex::new(Default::default()), Condvar::new())),
        }
    }

    pub async fn run(&self, mut source: Box<dyn MusicSource>) -> Result<()> {
        try_join!(self.play_songs(source), self.send_heartbeats())?;
        unreachable!()
    }

    async fn play_songs(&self, mut source: Box<dyn MusicSource>) -> Result<()> {
        let mut interval = interval(Duration::from_millis(20));

        let playlists = source.load_playlists().await.unwrap();

        // Load playlists into player state
        self.use_state(|mut state| {
            state.playlists.clear();
            send_event(&mut state.senders, ClearPlaylists());

            for playlist in playlists {
                state.playlists.push((playlist.clone(), true));
                send_event(&mut state.senders, AddPlaylist(playlist.name.to_string(), playlist.len));
            }
        })
        .await;

        let read = source.load_song("", &3).await.unwrap();
        let mut reader = PacketReader::new(read);

        loop {
            let packet: Packet = reader.next().await.unwrap().unwrap();

            self.use_state_if(
                |state| state.listeners() > 0 && !state.paused,
                |mut state| {
                    send_event(&mut state.senders, OpusFrame(packet.data));
                },
            )
            .await;
            interval.next().await;
        }
    }

    async fn send_heartbeats(&self) -> Result<()> {
        let mut interval = interval(Duration::from_secs(1));
        loop {
            self.use_state(|mut state| {
                send_event(&mut state.senders, HeartBeat);
            })
            .await;
            interval.next().await.unwrap();
        }
    }

    pub async fn play_pause(&self, paused: bool) {
        self.use_state(|mut state| {
            if state.paused != paused {
                state.paused = paused;
                send_event(&mut state.senders, PlayPause(paused));
                if paused {
                    log::info!("Paused");
                } else {
                    log::info!("Resumed");
                }
            }
        })
        .await
    }

    pub async fn select_playlist(&self, index: usize, selected: bool) {
        self.use_state(|mut state| {
            if let Some((playlist, current)) = state.playlists.get_mut(index) {
                if *current != selected {
                    *current = selected;
                    send_event(&mut state.senders, SelectPlaylist(index, selected));
                    if selected {
                        log::info!("Playlist {} selected", index);
                    } else {
                        log::info!("Playlist {} unselected", index);
                    }
                }
            }
        })
        .await;
    }

    pub async fn observe(&self) -> Receiver<PlayerEvent> {
        self.use_state(|mut state| {
            let (sender, receiver) = bounded(100);
            let mut events = vec![];
            let listeners = state.listeners() + 1;

            // Add initial player state to the channel
            events.push(PlayPause(state.paused));
            events.push(Listeners(listeners));
            for (index, (playlist, selected)) in state.playlists.iter().enumerate() {
                events.push(AddPlaylist(playlist.name.to_string(), playlist.len));
                if !selected {
                    events.push(SelectPlaylist(index, false))
                }
            }
            events.push(Ready);

            // This cannot fail if the channel has enough capacity
            for event in events {
                sender.try_send(event).unwrap();
            }

            // Send number of listeners to everyone else
            state.senders.push(sender);
            send_event(&mut state.senders, Listeners(listeners));

            receiver
        })
        .await
    }

    async fn use_state<F, R>(&self, function: F) -> R
    where
        F: FnOnce(MutexGuard<State>) -> R,
    {
        let (lock, condition) = &*self.state;
        let value = function(lock.lock().await);
        condition.notify_all();
        value
    }

    async fn use_state_if<P, F, R>(&self, predicate: P, function: F) -> R
    where
        P: Fn(&MutexGuard<State>) -> bool,
        F: FnOnce(MutexGuard<State>) -> R,
    {
        let (lock, condition) = &*self.state;
        let value = {
            let mut state = lock.lock().await;
            while !predicate(&state) {
                state = condition.wait(state).await;
            }
            function(state)
        };
        condition.notify_all();
        value
    }
}


fn send_event(senders: &mut Vec<Sender<PlayerEvent>>, event: PlayerEvent) {
    let mut len = senders.len();

    send_retain(senders, event);

    // If any number of senders disconnected
    while senders.len() < len {
        len = senders.len();
        send_retain(senders, PlayerEvent::Listeners(len))
    }
}

fn send_retain(senders: &mut Vec<Sender<PlayerEvent>>, event: PlayerEvent) {
    senders.retain(|sender| sender.try_send(event.clone()).is_ok());
}

// fn main() {
// protoc_rust::Codegen::new()
//     .out_dir("./src/generated")
//     .input("./proto/message.proto")
//     .run()
//     .expect("aaa");
// }
