use std::collections::HashMap;
use std::ffi::{OsString};
use std::path::Path;
use crate::common::{MusicSource, Playlist, Result};
use async_trait::async_trait;
use async_std::fs;
use futures::TryStreamExt;
use tokio::io::AsyncRead;
use crate::StreamExt;


pub struct LocalSource {
    path: String,
    initialized: bool,
    files: HashMap<String, Vec<String>>,
}

impl LocalSource {
    pub fn new(path: &str) -> Self {
        LocalSource {
            path: path.to_string(),
            initialized: false,
            files: HashMap::new(),
        }
    }
}

impl LocalSource {
    async fn reload(&mut self) -> Result<()> {
        self.files.clear();

        let mut directories = fs::read_dir(&self.path).await?;
        while let Some(directory) = directories.try_next().await? {
            let mut songs = Vec::new();

            let mut files = fs::read_dir(directory.path()).await?;
            while let Some(song) = files.try_next().await? {
                println!("{}", get_string(song.file_name()));

                songs.push(get_string(song.file_name()));
            }

            self.files.insert(get_string(directory.file_name()), songs);

            println!("{}", get_string(directory.file_name()));
        }
        Ok(())
    }

    async fn initialize(&mut self) -> Result<()> {
        if !self.initialized {
            self.reload().await?;
            self.initialized = true;
        }
        Ok(())
    }
}

#[async_trait]
impl MusicSource for LocalSource {
    async fn playlists(&mut self) -> Result<Vec<Playlist>> {
        self.initialize().await?;

        let mut playlists = Vec::new();

        for (name, songs) in &self.files {
            playlists.push(Playlist { name: name.clone(), len: songs.len() })
        }
        Ok(playlists)
    }

    async fn load_song(&mut self, playlist: &str, index: &usize) -> Result<Box<dyn AsyncRead + Unpin>> {
        self.initialize().await?;

        let songs = self.files.get(playlist).unwrap();
        let song = &songs[*index];

        let path = Path::new(&self.path).join(playlist).join(song);

        let x = tokio::fs::File::open(path).await?;
        Ok(Box::new(x))
    }
}

fn get_string(s: OsString) -> String {
    s.into_string().unwrap_or("".to_string())
}
