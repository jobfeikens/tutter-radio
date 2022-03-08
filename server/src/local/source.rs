use std::ffi::{OsStr, OsString};
use crate::common::{MusicSource, Playlist, Result};
use async_trait::async_trait;
use futures::{AsyncRead, TryFutureExt};
use std::path::Path;
use async_std::fs;
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
        let playlists = Vec::new();

        let mut paths = fs::read_dir("./").await?;

        while let Some(result) = paths.next().await {
            let entry = result?;

            if entry.metadata().await?.is_dir() {


            }
        }
        Ok(playlists)
    }

    async fn load_song(&mut self, playlist: &str, index: &usize) -> Result<()> {
        todo!()
    }
}

fn get_string(s: OsString) -> String {
    s.into_string().unwrap_or("".to_string())
}

//
// #[async_trait]
// impl MusicSource for LocalSource {
//     async fn load_playlists(&mut self) -> Result<Vec<Playlist>> {
//         todo!()
//     }
//
//     async fn load_song(&mut self, playlist: &str, index: &usize) -> Result {
//         todo!()
//     }
// }
