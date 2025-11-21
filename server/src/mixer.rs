use crate::Playlist;
use rand::distr::weighted::WeightedIndex;
use rand::distr::Distribution;
use rand::seq::SliceRandom;
use rand::{rng};
use std::collections::HashMap;

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
}

impl Mixer {
    pub fn new() -> Self {
        Mixer {
            playlists: HashMap::new(),
        }
    }

    pub fn has_next(&self) -> bool {
        self.playlists.values().any(|playlist| {
            playlist.enabled && !playlist.random_order.is_empty()
        })
    }

    pub fn add(&mut self, playlist: &Playlist) {
        let mut random_order: Vec<usize> = (0..playlist.len).collect();
        random_order.shuffle(&mut rng());

        self.playlists.insert(
            playlist.name.clone(),
            MixedPlaylist {
                index: 0,
                random_order,
                enabled: true,
            },
        );
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
        let mut entries = self.playlists.iter_mut().collect::<Vec<_>>();

        let dist = WeightedIndex::new(entries.iter().map(|(_, playlist)| {
            if playlist.enabled {
                playlist.len()
            } else {
                0
            }
        }))
        .ok()?;

        let (key, playlist) = &mut entries[dist.sample(&mut rng())];
        let song = playlist.random_order[playlist.index];

        playlist.index += 1;

        // Check if last song is being played
        if playlist.index >= playlist.len() {
            playlist.index = 0;
        }

        Some((key.clone(), song))
    }
}
