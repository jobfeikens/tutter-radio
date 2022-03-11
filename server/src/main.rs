use futures::{pin_mut, select, FutureExt, Sink, SinkExt, Stream, StreamExt};
mod common;
mod local;
mod player;
mod util;
mod convert;
mod generated;

use crate::common::{Playlist};
use crate::local::source::LocalSource;
use crate::player::{Player, PlayerEvent};
use crate::util::byte_buffer::ByteBuffer;
use byteorder::LittleEndian;
use futures::try_join;

use log::LevelFilter;
use simple_logger::SimpleLogger;
use std::any::Any;
use std::sync::atomic::{AtomicUsize, Ordering};
use std::sync::{Arc, Mutex};
use std::{env, error::Error, fmt};
use futures::stream::{SplitSink, SplitStream};
use generated::message as pb;
use protobuf::Message as PbMessage;
use tokio::io::{AsyncReadExt, AsyncWriteExt};
use tokio::net::{TcpListener, TcpStream};
use tokio::time::Duration;

use tokio_tungstenite::{
    tungstenite,
    tungstenite::{
        Message::Binary
    },
    WebSocketStream
};

use crate::convert::convert_event;
use anyhow::Result;

#[tokio::main]
async fn main() -> Result<()> {
    SimpleLogger::new().with_level(LevelFilter::Info).init()?;

    let addr = env::args()
        .nth(1)
        .unwrap_or_else(|| "0.0.0.0:8080".to_string());

    let player = Arc::new(Player::new());

    let mut server = Server {
        listener: TcpListener::bind(&addr).await?,
        player: player.clone(),
    };

    let source = LocalSource::new("/home/job/Music/tuttermusic");

    try_join!(
        server.run(),
        player.run(Box::new(source)),
    )?;
    unreachable!()
}

struct Server {
    listener: TcpListener,
    player: Arc<Player>
}

impl Server {
    async fn run(&mut self) -> Result<()> {
        loop {
            let (stream, address) = self.listener.accept().await?;
            log::info!("New connection: {}", address);

            self.accept_connection(stream).await?;
        }
    }

    async fn accept_connection(&mut self, stream: TcpStream) -> Result<()> {
        match tokio_tungstenite::accept_async(stream).await {
            Ok(stream) => {
                // Clone connection resources
                let player = Arc::clone(&self.player);

                // Run connection in separate task
                tokio::spawn(async move {
                    run_connection(stream, player).await;
                });
            }
            Err(err) => {
                log::warn!("Error processing connection: {}", err)
            }
        };
        Ok(())
    }
}

async fn run_connection(
    stream: WebSocketStream<TcpStream>,
    player: Arc<Player>
) {
    let (sink, stream) = stream.split();

    let result = try_join!(
        send_connection(sink, player.clone()),
        receive_connection(stream, player.clone()),
    );
}

async fn send_connection(
    mut stream: SplitSink<WebSocketStream<TcpStream>, tungstenite::Message>,
    player: Arc<Player>
) -> Result<()> {
    let receiver = player.observe().await;

    loop {
        let event = convert_event(receiver.recv().await?);
        let bytes = event.write_to_bytes()?;
        stream.send(Binary(bytes)).await?;
    }
}

async fn receive_connection(
    mut stream: SplitStream<WebSocketStream<TcpStream>>,
    player: Arc<Player>
) -> Result<()> {
    while let Some(data) = stream.next().await {
        let bytes = data?;

        let message = pb::ServerBound::parse_from_bytes(&bytes.into_data())?;


        if message.has_play_pause() {
            player.play_pause(message.get_play_pause().is_paused).await;
        }

        else if message.has_select_playlist() {
            let select = message.get_select_playlist();

            player.select_playlist(select.index as usize, select.selected).await;
        }
    }
    log::info!("End of stream");
    // End of stream
    Ok(())
}
