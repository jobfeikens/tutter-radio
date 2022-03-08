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

#[derive(Clone, Debug)]
pub enum PlayerEvent {
    HeartBeat,
    PlayPause(bool), // true is paused
    Listeners(usize),
    PlaylistUpdate(String, bool), // name, selected
    Metadata(Metadata),
    Ready,
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

    pub async fn run(&self, source: Box<dyn MusicSource>) -> Result<()> {
        try_join!(self.play_songs(source), self.send_heartbeats())?;
        unreachable!()
    }

    async fn play_songs(&self, source: Box<dyn MusicSource>) -> Result<()> {
        let mut interval = interval(Duration::from_millis(20));

        loop {
            self.use_state_if(
                |state| state.listeners() > 0 && !state.paused,
                |mut state| {
                    send_event(&mut state.senders, PlayerEvent::HeartBeat);
                    state.metadata.is_some()
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
                send_event(&mut state.senders, PlayerEvent::HeartBeat);
            })
            .await;
            interval.next().await.unwrap();
        }
    }

    pub async fn play_pause(&self, paused: &bool) {
        self.use_state(|mut state| {
            if *paused != state.paused {
                state.paused = *paused;
                send_event(&mut state.senders, PlayerEvent::PlayPause(*paused));
                if *paused {
                    log::info!("Paused");
                } else {
                    log::info!("Resumed");
                }
            }
        })
        .await
    }

    pub async fn select_playlist(&self, name: &str, selected: &bool) {
        self.use_state(|mut state| {
            let mut playlist = state
                .playlists
                .iter_mut()
                .find(|(playlist, _)| playlist.name == name);

            if let Some((_, s)) = playlist {
                if s != selected {
                    *s = *selected;

                    send_event(
                        &mut state.senders,
                        PlayerEvent::PlaylistUpdate(name.to_string(), *selected),
                    );
                    if *selected {
                        log::info!("Playlist {} selected", name)
                    } else {
                        log::info!("Playlist {} deselected", name)
                    }
                }
            }
        })
        .await;
    }

    pub async fn observe(&self) -> Receiver<PlayerEvent> {
        self.use_state(|mut state| {
            let (sender, receiver) = bounded(100);

            let listeners = state.listeners() + 1;

            // Send initial values to new receiver
            sender
                .try_send(PlayerEvent::PlayPause(state.paused))
                .unwrap();
            sender.try_send(PlayerEvent::Listeners(listeners)).unwrap();

            for (playlist, selected) in &state.playlists {
                sender
                    .try_send(PlayerEvent::PlaylistUpdate(
                        playlist.name.clone(),
                        *selected,
                    ))
                    .unwrap();
            }

            if let Some(metadata) = &state.metadata {
                sender
                    .try_send(PlayerEvent::Metadata(metadata.clone()))
                    .unwrap();
            }

            sender.try_send(PlayerEvent::Ready).unwrap();

            // Send number of listeners to everyone else
            state.senders.push(sender);
            send_event(&mut state.senders, PlayerEvent::Listeners(listeners));

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
