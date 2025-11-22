use futures::{SinkExt, StreamExt};
use std::env;
use std::sync::{Arc, Mutex};
mod common;
mod convert;
mod local;
mod mixer;
mod player;
mod report;
mod util;

use crate::common::Playlist;
use crate::local::source::LocalSource;
use crate::player::{Player, PlayerEvent};
use futures::try_join;

use clap::Parser;
use futures::stream::{SplitSink, SplitStream};
use log::LevelFilter;
use protobuf::Message as PbMessage;
use simple_logger::SimpleLogger;
use tokio::net::{TcpListener, TcpStream};

include!(concat!(env!("OUT_DIR"), "/generated/mod.rs"));

use tokio_tungstenite::tungstenite::handshake::server::{
    ErrorResponse, Request, Response,
};
use tokio_tungstenite::{
    tungstenite, tungstenite::Message::Binary, WebSocketStream,
};

use crate::convert::convert_event;
use crate::report::report_song;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let args = Args::parse();

    let addr = args.address.unwrap_or_else(|| "0.0.0.0:8443".to_string());

    let playlist_path = args.playlist_path.unwrap_or_else(|| {
        env::current_dir().unwrap().to_str().unwrap().to_string()
    });

    SimpleLogger::new().with_level(LevelFilter::Info).init()?;

    let player = Player::new();

    let mut server = Server {
        listener: TcpListener::bind(&addr).await?,
        player: player.clone(),
    };

    let mut source = LocalSource::new(&playlist_path);
    source.initialize().await?;

    log::info!("Started successfully!");

    try_join!(server.run(), player.run(&mut source),)?;
    unreachable!()
}

#[derive(Parser)]
struct Args {
    #[clap(short, long)]
    address: Option<String>,

    #[clap(short, long)]
    playlist_path: Option<String>,
}

struct Server {
    listener: TcpListener,
    player: Player,
}

impl Server {
    async fn run(&mut self) -> anyhow::Result<()> {
        let mut connection_counter = 0;

        loop {
            let (socket, remote_addr) = self.listener.accept().await?;
            let connection_id = connection_counter;
            connection_counter += 1;

            log::info!("New connection {}: {}", connection_id, remote_addr);
            let player = self.player.clone();

            tokio::spawn(async move {
                accept_connection(connection_id, socket, player)
                    .await
                    .expect("tungstenite accept error");
            });
        }
    }
}

#[derive(Clone)]
struct RequestInterceptor {
    is_spectator: Arc<Mutex<bool>>,
}

impl tungstenite::handshake::server::Callback for RequestInterceptor {
    fn on_request(
        self,
        request: &Request,
        response: Response,
    ) -> Result<Response, ErrorResponse> {
        if request.uri().to_string().contains("spectator=true") {
            *self.is_spectator.lock().unwrap() = true;
        }
        Ok(response)
    }
}

impl RequestInterceptor {
    fn new() -> Self {
        RequestInterceptor {
            is_spectator: Arc::new(Mutex::new(false)),
        }
    }
    fn is_spectator(&self) -> bool {
        *self.is_spectator.lock().unwrap()
    }
}

async fn accept_connection(
    connection_id: usize,
    stream: TcpStream,
    player: Player,
) -> anyhow::Result<()> {
    let header_interceptor = RequestInterceptor::new();

    match tokio_tungstenite::accept_hdr_async(
        stream,
        header_interceptor.clone(),
    )
    .await
    {
        Ok(stream) => {

            // Run connection in separate task
            tokio::spawn(async move {
                run_connection(
                    connection_id,
                    stream,
                    player,
                    header_interceptor.is_spectator(),
                )
                .await;
            });
        }
        Err(err) => {
            log::warn!("Error processing connection {}: {}", connection_id, err)
        }
    };
    Ok(())
}

async fn run_connection(
    connection_id: usize,
    stream: WebSocketStream<TcpStream>,
    player: Player,
    is_spectator: bool,
) {
    let (sink, stream) = stream.split();

    let _ = try_join!(
        send_connection(sink, player.clone(), is_spectator),
        receive_connection(stream, player.clone()),
    );
    log::info!("Connection {} disconnected", connection_id);
}

async fn send_connection(
    mut stream: SplitSink<WebSocketStream<TcpStream>, tungstenite::Message>,
    player: Player,
    is_spectator: bool,
) -> anyhow::Result<()> {
    let receiver = player.observe(is_spectator).await;

    loop {
        let event = convert_event(receiver.recv().await?);
        let bytes = event.write_to_bytes()?;
        stream.send(Binary(bytes.into())).await?;
    }
}

async fn receive_connection(
    mut stream: SplitStream<WebSocketStream<TcpStream>>,
    player: Player,
) -> anyhow::Result<()> {
    while let Some(data) = stream.next().await {
        let bytes = data?;

        let message =
            message::ServerBound::parse_from_bytes(&bytes.into_data())?;

        if message.has_play_pause() {
            player.play_pause(message.play_pause().is_paused).await;
        } else if message.has_select_playlist() {
            let select = message.select_playlist();

            player
                .select_playlist(&select.playlist, select.selected)
                .await;

        } else if message.has_show_potter_name() {
            player
                .show_potter_name(message.show_potter_name().show)
                .await;
        } else if message.has_report_song() {
            let report = message.report_song();

            report_song(&report.artist, &report.title, &report.explanation)
                .await?;
        }
    }
    Ok(())
}
