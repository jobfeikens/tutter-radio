use rand::seq::SliceRandom;
use rand::thread_rng;
use crate::Playlist;

#[derive(Clone)]
struct MixedSong {
    playlist: String,
    index: usize,
}

pub struct Mixer {
    songs: Vec<MixedSong>,
    enabled_playlists: Vec<String>,
    index: usize,
}

impl Mixer {
    pub fn new() -> Self {
        Mixer {
            songs: Vec::new(),
            enabled_playlists: Vec::new(),
            index: 0,
        }
    }

    pub fn has_next(&self) -> bool {
        !self.songs.is_empty() && !self.enabled_playlists.is_empty()
    }

    pub fn add(&mut self, playlist: &Playlist) {
        for index in 0..playlist.len {
            self.songs.push(
                MixedSong {
                    playlist: playlist.name.clone(),
                    index,
                }
            );
        }
        self.songs.shuffle(&mut thread_rng());
        self.enable(playlist);
    }

    pub fn enable(&mut self, playlist: &Playlist) {
        self.disable(playlist);
        self.enabled_playlists.push(playlist.name.clone());
    }

    pub fn disable(&mut self, playlist: &Playlist) {
        self.enabled_playlists.retain(|other| other != &playlist.name);
    }

    pub fn next(&mut self) -> Option<(String, usize)> {
        let start_index = self.index;

        loop {
            if self.index < self.songs.len() {
                let song = self.songs[self.index].clone();

                self.index += 1;

                if self.enabled_playlists.contains(&song.playlist) {
                    return Some((song.playlist, song.index));
                }
            } else {
                self.index = 0;
            }
            if self.index == start_index {
                return None;
            }
        }
    }
}
