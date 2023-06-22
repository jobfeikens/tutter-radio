use async_trait::async_trait;

use tokio::io::{AsyncRead};

pub type Result<T> = anyhow::Result<T>;

#[derive(Clone, Debug)]
pub struct Playlist {
    pub name: String,
    pub len: usize,
}

pub struct Song {
    pub id: String,
    pub read: Box<dyn AsyncRead + Unpin>,
}

#[async_trait]
pub trait MusicSource {
    async fn playlists(&mut self) -> Result<Vec<Playlist>>;

    async fn load_song(&mut self, playlist: &str, index: &usize) -> Result<Song>;
}
