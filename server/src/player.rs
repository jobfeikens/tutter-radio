use crate::common::{MusicSource};
use crate::mixer::Mixer;
use crate::util::opus_packet::{read_packet, OggData, OpusFrame, VorbisCommentData};
use crate::Playlist;
use anyhow::Result;
use async_std::channel::{bounded, Receiver, Sender};
use async_std::stream::interval;
use async_std::sync::{Condvar, Mutex, MutexGuard};
use futures::{try_join, StreamExt, TryStreamExt};
use ogg::reading::async_api::PacketReader;
use std::cmp::max;
use std::collections::VecDeque;
use std::sync::Arc;
use std::time::Duration;
use tokio::io::AsyncRead;
use tokio::time::{sleep_until, Instant};
use PlayerEvent::*;

// Buffer holds n or less seconds worth of opus frames
const BUFFER_SIZE: Duration = Duration::from_secs(10);

#[derive(Clone, Debug)]
pub enum PlayerEvent {
    HeartBeat,
    PlayPause(bool),
    Listeners(usize),

    ClearPlaylists(),
    AddPlaylist(String, usize),  // name length
    SelectPlaylist(usize, bool), // index, selected (selected by default)

    Metadata(Option<(String, VorbisCommentData)>),

    Ready,

    OpusData(String, OpusFrame),
    ShowPotterName(bool),
}

pub struct State {
    is_paused: bool,
    senders: Vec<(Sender<PlayerEvent>, bool)>,  // bool = is_spectator
    metadata: Option<(String, VorbisCommentData)>,
    playlists: Vec<(Playlist, bool)>,
    show_potter_name: bool,

    mixer: Mixer,
    buffer: FrameBuffer,
}

impl Default for State {
    fn default() -> Self {
        State {
            is_paused: true,
            senders: Default::default(),
            playlists: Default::default(),
            show_potter_name: false,
            mixer: Mixer::new(),
            metadata: None,
            buffer: FrameBuffer::new(BUFFER_SIZE),
        }
    }
}

#[derive(Clone)]
pub struct Player {
    state: Arc<(Mutex<State>, Condvar)>,
}

struct LoadedSong {
    song_id: String,
    reader: PacketReader<Box<dyn AsyncRead+Unpin>>,
}

impl Player {
    pub fn new() -> Self {
        Player {
            state: Arc::new((Mutex::new(Default::default()), Condvar::new())),
        }
    }

    pub async fn run(&self, source: &mut dyn MusicSource) -> Result<()> {
        self.init(source).await?;
        try_join!(self.play_songs(source), self.send_heartbeats())?;
        unreachable!()
    }

    async fn init(&self, source: &mut dyn MusicSource) -> Result<()> {
        let playlists = source.playlists().await?;

        // Load playlists
        self.use_state(|mut state| {
            state.playlists.clear();
            send_event(&mut state.senders, ClearPlaylists(), true);

            for playlist in playlists {
                state.mixer.add(&playlist);
                state.playlists.push((playlist.clone(), true));

                send_event(
                    &mut state.senders,
                    AddPlaylist(playlist.name.to_string(), playlist.len),
                    true
                );
            }
        })
        .await;
        Ok(())
    }

    async fn play_songs(&self, source: &mut dyn MusicSource) -> Result<()> {
        let mut loaded_song: Option<LoadedSong> = None;

        let mut frame_time = Instant::now();

        loop {
            if loaded_song.is_none() {
                let mut next = self.use_state(|mut state| {
                    let next = state.mixer.next();

                    if next.is_none() {
                        state.metadata = None;
                        send_event(&mut state.senders, Metadata(None), true);
                        state.buffer.clear();
                    }
                    next
                }).await;

                if next.is_none() {
                    next = self.use_state_when(
                        |state| state.mixer.has_next(),
                        |mut state| state.mixer.next()
                    )
                    .await;
                }

                let (playlist, index) = next.unwrap();

                let song = source.load_song(&playlist, &index).await?;

                loaded_song = Some(LoadedSong {
                    song_id: song.id,
                    reader: PacketReader::new(song.read),
                });
            }
            let some_loaded_song = loaded_song.as_mut().unwrap();

            match some_loaded_song.reader.try_next().await? {
                None => {
                    loaded_song = None;
                }
                Some(packet) => {
                    match read_packet(packet.data) {
                        OggData::OggHeader() => {
                            // Header not used
                            continue;
                        }
                        OggData::VorbisComment(comment) => {
                            self.send_metadata(&some_loaded_song.song_id,comment).await;
                        }
                        OggData::Opus(frame) => {
                            frame_time = self.send_frame(&some_loaded_song.song_id, frame, frame_time).await;
                        }
                    }
                }
            }
        }
    }

    async fn send_metadata(&self, song_id: &str, metadata: VorbisCommentData) {
        self.use_state(|mut state| {
            send_event(&mut state.senders, Metadata(Some((song_id.to_string(), metadata.clone()))), true);

            state.metadata = Some((song_id.to_string(), metadata));
        })
        .await;
    }

    async fn send_frame(&self, song_id: &str, frame: OpusFrame, frame_time: Instant) -> Instant {
        sleep_until(frame_time).await;

        self.use_state_when(
            |state| !state.is_paused && state.senders.len() > 0,
            |mut state| {
                send_event(&mut state.senders, OpusData(song_id.to_string(), frame.clone()), false);

                if !state.buffer.push(song_id,frame.clone()) {
                    // Immediately send the next frame if the buffer isn't full
                    Instant::now()
                } else {
                    // Send the next frame after this frame
                    max(frame_time + frame.duration, Instant::now())
                }
            },
        )
        .await
    }

    async fn send_heartbeats(&self) -> Result<()> {
        let mut interval = interval(Duration::from_secs(1));
        loop {
            self.use_state(|mut state| {
                send_event(&mut state.senders, HeartBeat, true);
            })
            .await;
            interval.next().await.unwrap();
        }
    }

    pub async fn play_pause(&self, paused: bool) {
        self.use_state(|mut state| {
            if state.is_paused != paused {
                state.is_paused = paused;
                send_event(&mut state.senders, PlayPause(paused), true);
                if paused {
                    log::info!("Paused");
                } else {
                    log::info!("Resumed");
                }
            }
        })
        .await
    }

    pub async fn select_playlist(&self, index: usize, update: bool) {
        self.use_state(|mut state| {
            if let Some((playlist, selected)) = state.playlists.get_mut(index) {
                if selected != &update {
                    *selected = update;

                    let playlist = playlist.clone();

                    if update {
                        state.mixer.enable(&playlist);
                        log::info!("Playlist {} selected", index);
                    } else {
                        state.mixer.disable(&playlist);
                        log::info!("Playlist {} unselected", index);
                    }
                    send_event(&mut state.senders, SelectPlaylist(index, update), true);
                }
            }
        })
        .await;
    }

    pub async fn show_potter_name(&self, show: bool) {
        self.use_state(|mut state| {
            state.show_potter_name = show;
            send_event(&mut state.senders, ShowPotterName(show), true);
        }).await;
    }

    pub async fn observe(&self, is_spectator: bool) -> Receiver<PlayerEvent> {
        self.use_state(|mut state| {
            let (sender, receiver) = bounded(1024);
            let mut events = vec![];

            let mut listeners = state.senders
                .iter()
                .filter(|(_, is_spectator)| !*is_spectator)
                .count();

            if !is_spectator {
                listeners += 1;
            }

            if listeners == 1 && state.is_paused {
                state.is_paused = false;
            }

            // Add initial player state to the channel
            events.push(PlayPause(state.is_paused));
            events.push(Listeners(listeners));
            for (index, (playlist, selected)) in state.playlists.iter().enumerate() {
                events.push(AddPlaylist(playlist.name.to_string(), playlist.len));
                if !selected {
                    events.push(SelectPlaylist(index, false));
                }
            }

            events.push(Metadata(state.metadata.clone()));
            events.push(ShowPotterName(state.show_potter_name));

            if !is_spectator {
                for frame in state.buffer.frames.iter() {
                    let (song_id, frame) = frame.clone();
                    events.push(OpusData(song_id, frame))
                }
            }

            events.push(Ready);

            // This cannot fail if the channel has enough capacity
            for event in events {
                sender.try_send(event).unwrap();
            }

            // Send number of listeners to everyone else
            state.senders.push((sender, is_spectator));
            send_event(&mut state.senders, Listeners(listeners), true);

            receiver
        })
        .await
    }

    async fn use_state<F, R>(&self, function: F) -> R
    where
        F: FnOnce(MutexGuard<State>) -> R,
    {
        self.use_state_when(|_| true, function).await
    }

    async fn use_state_when<P, F, R>(&self, predicate: P, function: F) -> R
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

struct FrameBuffer {
    capacity: Duration,
    contents: Duration,
    frames: VecDeque<(String, OpusFrame)>,
    capacity_reached: bool,
}

impl FrameBuffer {
    fn new(capacity: Duration) -> Self {
        FrameBuffer {
            capacity,
            contents: Duration::from_nanos(0),
            frames: VecDeque::new(),
            capacity_reached: false,
        }
    }

    fn push(&mut self, song_id: &str, frame: OpusFrame) -> bool {
        while self.contents >= self.capacity {
            self.contents -= self.frames.pop_front().unwrap().1.duration;
        }

        self.contents += frame.duration;
        self.frames.push_back((song_id.to_string(), frame));

        if self.contents >= self.capacity {
            self.capacity_reached = true;
        }
        self.capacity_reached
    }

    fn clear(&mut self) {
        self.contents = Duration::from_nanos(0);
        self.frames.clear();
        self.capacity_reached = false;
    }
}

fn send_event(senders: &mut Vec<(Sender<PlayerEvent>, bool)>, event: PlayerEvent, send_to_spectators: bool) {
    let len_before = senders.len();

    senders.retain(|(sender, is_spectator)| {
        if *is_spectator && !send_to_spectators {
            true
        } else {
            // Remove sender if the event can't be sent
            sender.try_send(event.clone()).is_ok()
        }
    });

    let len_after = senders.len();

    if len_after < len_before {
        let listeners = senders
            .iter()
            .filter(|(_, is_spectator)| !*is_spectator)
            .count();

        send_event(senders, PlayerEvent::Listeners(listeners), true);
    }
}
