use crate::common::MusicSource;
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
use tokio::time::{sleep_until, Instant};
use PlayerEvent::*;

// Buffer holds n or less seconds worth of opus frames
const BUFFER_SIZE: Duration = Duration::from_secs(1);

#[derive(Clone, Debug)]
pub enum PlayerEvent {
    HeartBeat,
    PlayPause(bool),
    Listeners(usize),

    ClearPlaylists(),
    AddPlaylist(String, usize),  // name length
    SelectPlaylist(usize, bool), // index, selected (selected by default)

    Metadata(Option<VorbisCommentData>),

    Ready,

    OpusData(OpusFrame),
}

pub struct State {
    is_paused: bool,
    senders: Vec<Sender<PlayerEvent>>,
    metadata: Option<VorbisCommentData>,

    playlists: Vec<(Playlist, bool)>,
    mixer: Mixer,

    buffer: FrameBuffer,
}

impl Default for State {
    fn default() -> Self {
        State {
            is_paused: true,
            senders: Default::default(),
            playlists: Default::default(),
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
            send_event(&mut state.senders, ClearPlaylists());

            for playlist in playlists {
                state.mixer.add(&playlist);
                state.playlists.push((playlist.clone(), true));

                send_event(
                    &mut state.senders,
                    AddPlaylist(playlist.name.to_string(), playlist.len),
                );
            }
        })
        .await;
        Ok(())
    }

    async fn play_songs(&self, mut source: &mut dyn MusicSource) -> Result<()> {
        let mut reader = None;

        let mut frame_time = Instant::now();

        loop {
            if reader.is_none() {
                let mut next = self.use_state(|mut state| {
                    let next = state.mixer.next();

                    if next.is_none() {
                        state.metadata = None;
                        send_event(&mut state.senders, Metadata(None));
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

                let read = source.load_song(&playlist, &index).await?;

                reader = Some(PacketReader::new(read));
            }
            match reader.as_mut().unwrap().try_next().await? {
                None => {
                    reader = None;
                }
                Some(packet) => {
                    match read_packet(packet.data) {
                        OggData::OggHeader() => {
                            // Header not used
                            continue;
                        }
                        OggData::VorbisComment(comment) => {
                            self.send_metadata(comment).await;
                        }
                        OggData::Opus(frame) => {
                            frame_time = self.send_frame(frame, frame_time).await;
                        }
                    }
                }
            }
        }
    }

    async fn send_metadata(&self, metadata: VorbisCommentData) {
        self.use_state(|mut state| {
            send_event(&mut state.senders, Metadata(Some(metadata.clone())));

            state.metadata = Some(metadata);
        })
        .await;
    }

    async fn send_frame(&self, frame: OpusFrame, frame_time: Instant) -> Instant {
        sleep_until(frame_time).await;

        self.use_state_when(
            |state| !state.is_paused && state.senders.len() > 0,
            |mut state| {
                send_event(&mut state.senders, OpusData(frame.clone()));

                if !state.buffer.push(frame.clone()) {
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
                send_event(&mut state.senders, HeartBeat);
            })
            .await;
            interval.next().await.unwrap();
        }
    }

    pub async fn play_pause(&self, paused: bool) {
        self.use_state(|mut state| {
            if state.is_paused != paused {
                state.is_paused = paused;
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

    pub async fn select_playlist(&self, index: usize, update: bool) {
        self.use_state(|mut state| {
            if let Some((playlist, selected)) = state.playlists.get_mut(index) {
                if selected != &update {
                    *selected = update;

                    let playlist = playlist.clone();

                    if update {
                        state.mixer.add(&playlist);
                        log::info!("Playlist {} selected", index);
                    } else {
                        state.mixer.remove(&playlist);
                        log::info!("Playlist {} unselected", index);
                    }
                    send_event(&mut state.senders, SelectPlaylist(index, update));
                }
            }
        })
        .await;
    }

    pub async fn observe(&self) -> Receiver<PlayerEvent> {
        self.use_state(|mut state| {
            let (sender, receiver) = bounded(1024);
            let mut events = vec![];
            let listeners = state.senders.len() + 1;

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

            for frame in state.buffer.frames.iter() {
                events.push(OpusData(frame.clone()))
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
    frames: VecDeque<OpusFrame>,
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

    fn push(&mut self, frame: OpusFrame) -> bool {
        while self.contents >= self.capacity {
            self.contents -= self.frames.pop_front().unwrap().duration;
        }

        self.contents += frame.duration;
        self.frames.push_back(frame);

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

fn send_event(senders: &mut Vec<Sender<PlayerEvent>>, event: PlayerEvent) {
    let len_before = senders.len();

    senders.retain(|sender|
        // Remove sender if the event can't be sent
        sender.try_send(event.clone()).is_ok());

    let len_after = senders.len();

    if len_after < len_before {
        send_event(senders, PlayerEvent::Listeners(len_after));
    }
}
