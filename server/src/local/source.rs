use std::ffi::{OsStr, OsString};
use crate::common::{MusicSource, Playlist, Result};
use async_trait::async_trait;
use futures::{TryFutureExt};
use std::path::Path;
use async_std::fs;
use tokio::io::AsyncRead;
use crate::StreamExt;


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
    async fn load_playlists(&mut self) -> Result<Vec<Playlist>> {
        let mut playlists = Vec::new();

        let mut directories = fs::read_dir(&self.path).await?;
        while let Some(result) = directories.next().await {
            let directory = result?;

            let name = get_string(directory.file_name());
            let len = fs::read_dir(directory.path()).await?.count().await;

            playlists.push(Playlist { name, len })
        }
        Ok(playlists)
    }

    async fn load_song(&mut self, playlist: &str, index: &usize) -> Result<Box<dyn AsyncRead + Unpin>> {
        let x = tokio::fs::File::open("/home/job/Music/tuttermusic/tutter1/test.opus").await?;
        Ok(Box::new(x))
    }
}

fn get_string(s: OsString) -> String {
    s.into_string().unwrap_or("".to_string())
}
