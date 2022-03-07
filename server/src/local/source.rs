use crate::common::{MusicSource, Playlist, Result, Song};
use async_trait::async_trait;
use futures::{AsyncRead, TryFutureExt};
use std::path::Path;
use tokio::fs;
use tokio::fs::DirEntry;

pub struct LocalSource {
    path: String,
}

impl LocalSource {
    pub fn new(path: &str) -> Self {
        LocalSource {
            path: path.to_string(),
        }
    }
}

#[async_trait]
impl MusicSource for LocalSource {
    async fn load_playlists(&mut self) -> Result<Vec<Box<dyn Playlist>>> {
        let mut playlists = Vec::new();
        //
        // let mut files = fs::read_dir(&self.path).await?;
        //
        // while let Some(entry) = files.next_entry().await? {
        //     if entry.metadata().await?.is_dir() {
        //         playlists.push(Box::new(LocalPlaylist { entry }))
        //     }
        // }
        Ok(playlists)
    }
}

pub struct LocalPlaylist {
    entry: DirEntry,
}

impl Playlist for LocalPlaylist {
    fn get_songs(&self) -> Vec<Box<dyn Song>> {
        todo!()
    }
}

pub struct LocalSong {}

#[async_trait]
impl Song for LocalSong {
    async fn load(&self) -> Result<Box<dyn AsyncRead>> {
        todo!()
    }
}
