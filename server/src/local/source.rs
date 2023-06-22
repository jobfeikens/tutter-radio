use std::collections::HashMap;
use std::ffi::{OsString};
use std::path::Path;
use crate::common::{MusicSource, Playlist, Result, Song};
use async_trait::async_trait;
use async_std::fs;
use futures::TryStreamExt;


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
        let mut song_count: usize = 0;
        let mut playlist_count: usize = 0;

        self.files.clear();

        let mut directories = fs::read_dir(&self.path).await?;
        while let Some(directory) = directories.try_next().await? {
            let mut songs = Vec::new();

            let mut files = fs::read_dir(directory.path()).await?;
            while let Some(song) = files.try_next().await? {
                songs.push(get_string(song.file_name()));
                song_count += 1;
            }

            self.files.insert(get_string(directory.file_name()), songs);
            playlist_count += 1;
        }
        log::info!("Loaded {} songs in {} playlists", song_count, playlist_count);

        Ok(())
    }

    pub async fn initialize(&mut self) -> Result<()> {
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

    async fn load_song(&mut self, playlist: &str, index: &usize) -> Result<Song> {
        self.initialize().await?;

        let songs = self.files.get(playlist).unwrap();
        let song = &songs[*index];

        let path = Path::new(&self.path).join(playlist).join(song);

        let x = tokio::fs::File::open(path).await?;
        Ok(Song { id: song.to_string(), read: Box::new(x) })
    }
}

fn get_string(s: OsString) -> String {
    s.into_string().unwrap_or("".to_string())
}
