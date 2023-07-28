use std::collections::HashMap;
use rand::seq::SliceRandom;
use rand::thread_rng;
use crate::Playlist;

struct MixedPlaylist {
    index: usize,
    random_order: Vec<usize>,
    enabled: bool,
}

impl MixedPlaylist {
    pub fn len(&self) -> usize {
        self.random_order.len()
    }
}

pub struct Mixer {
    playlists: HashMap<String, MixedPlaylist>,
    playlist_keys: Vec<String>,  // Used to get a random playlist
}

impl Mixer {
    pub fn new() -> Self {
        Mixer {
            playlists: HashMap::new(),
            playlist_keys: Vec::new(),
        }
    }

    pub fn has_next(&self) -> bool {
        self.playlists
            .values()
            .any(|playlist| playlist.enabled && !playlist.random_order.is_empty())
    }

    pub fn add(&mut self, playlist: &Playlist) {
        let mut random_order: Vec<usize> = (0..playlist.len).collect();
        random_order.shuffle(&mut thread_rng());

        self.playlists.insert(
            playlist.name.clone(),
            MixedPlaylist { index: 0, random_order, enabled: true });

        self.playlist_keys.push(playlist.name.clone());
    }

    pub fn enable(&mut self, playlist: &Playlist) {
        if let Some(playlist) = self.playlists.get_mut(&playlist.name) {
            playlist.enabled = true;
        }
    }

    pub fn disable(&mut self, playlist: &Playlist) {
        if let Some(playlist) = self.playlists.get_mut(&playlist.name) {
            playlist.enabled = false;
        }
    }

    pub fn next(&mut self) -> Option<(String, usize)> {
        if !self.has_next() {
            return None
        }
        self.playlist_keys.shuffle(&mut thread_rng());  // Select a random playlist

        for key in &self.playlist_keys {

            if let Some(playlist) = self.playlists.get_mut(key) {

                if !playlist.enabled || playlist.len() == 0 {
                    continue
                }
                if playlist.index + 1 >= playlist.len() {
                    playlist.index = 0;
                    playlist.random_order.shuffle(&mut thread_rng())
                } else {
                    playlist.index += 1;
                }
                return Some((key.to_string(), playlist.random_order[playlist.index]))
            }
        }
        return None
    }
}
