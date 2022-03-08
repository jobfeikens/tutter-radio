use async_trait::async_trait;
use futures::AsyncRead;
use std::error::Error;

pub type Result<T> = std::result::Result<T, Box<dyn Error>>;



#[derive(Clone, Debug)]
pub struct Metadata {
    title: String,
    artist: Option<String>,
    art: Option<Vec<u8>>,
}

#[derive(Clone, Debug)]
pub struct Playlist {
    pub name: String,
    pub len: usize,
}

#[async_trait]
pub trait MusicSource {
    async fn load_playlists(&mut self) -> Result<Vec<Playlist>>;

    async fn load_song(&mut self, playlist: &str, index: &usize) -> Result<()>;
}


