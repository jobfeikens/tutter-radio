use async_trait::async_trait;
use futures::AsyncRead;
use std::error::Error;

pub type Result<T> = std::result::Result<T, Box<dyn Error>>;

#[async_trait]
pub trait Song {
    async fn load(&self) -> Result<Box<dyn AsyncRead>>;
}

pub trait Playlist {
    fn get_songs(&self) -> Vec<Box<dyn Song>>;
}

#[async_trait]
pub trait MusicSource {
    async fn load_playlists(&mut self) -> Result<Vec<Box<dyn Playlist>>>;
}
