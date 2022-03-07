use async_std::channel::{bounded, Receiver, Sender};
use async_std::stream::interval;
use async_std::sync::{Condvar, Mutex, MutexGuard};
use async_std::task;
use async_trait::async_trait;
use futures::{try_join, StreamExt};
use std::error::Error;
use std::sync::Arc;
use std::thread::sleep;
use std::time::Duration;
use anyhow::Result;

struct Metadata {}

#[derive(Clone, Debug)]
pub enum PlayerEvent {
    HeartBeat,
    Paused,
    Resumed,
    Listeners(usize),
}

pub struct State {
    paused: bool,
    senders: Vec<Sender<PlayerEvent>>,
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

    pub async fn run(&self) -> Result<()> {
        try_join!(
            self.send_1(),
            //self.send_heartbeats()
        )?;
        unreachable!()
    }

    async fn send_1(&self) -> Result<()> {
        let mut interval = interval(Duration::from_millis(1000));

        loop {
            self.use_state_if(
                // Only play music if there are listeners
                |state| state.listeners() > 0,
                |mut state| {
                    send_event(&mut state.senders, PlayerEvent::HeartBeat);
                },
            )
            .await;

            interval.next().await;
        }
    }

    async fn send_heartbeats(&self) -> Result<()> {
        let mut interval = interval(Duration::from_millis(20));
        loop {
            self.use_state(|mut state| {
                //send_to_all(&mut state.senders, PlayerEvent::HeartBeat);
            })
            .await;

            interval.next().await.unwrap();
        }
    }

    pub async fn pause(&self) {
        self.use_state(|mut state| {
            if !state.paused {
                state.paused = true;
                send_event(&mut state.senders, PlayerEvent::Paused);
                log::info!("Player paused");
            }
        })
        .await;
    }

    pub async fn resume(&self) {
        self.use_state(|mut state| {
            if state.paused {
                state.paused = false;
                send_event(&mut state.senders, PlayerEvent::Resumed);
                log::info!("Player resumed");
            }
        })
        .await;
    }

    pub async fn observe(&self) -> Receiver<PlayerEvent> {
        self.use_state(|mut state| {
            let (sender, receiver) = bounded(100);

            // Send initial values to new receiver
            if state.paused {
                sender.try_send(PlayerEvent::Paused).unwrap();
            } else {
                sender.try_send(PlayerEvent::Resumed).unwrap();
            }
            state.senders.push(sender);

            // Send number of listeners to everyone
            let listeners = state.listeners();
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
    while len > senders.len() {
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
