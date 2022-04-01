use rand::seq::SliceRandom;
use rand::thread_rng;
use crate::Playlist;

type QualifiedSong = (String, usize);

pub struct Mixer {
    done: Vec<QualifiedSong>,
    remaining: Vec<QualifiedSong>,
}

impl Mixer {
    pub fn new() -> Self {
        Mixer {
            done: Vec::new(),
            remaining: Vec::new(),
        }
    }

    pub fn add(&mut self, playlist: &Playlist) {
        for index in 0..playlist.len {
            self.remaining.push((playlist.name.clone(), index))
        }
        self.shuffle();
    }

    pub fn remove(&mut self, playlist: &Playlist) {
        let predicate = |(p, _): &QualifiedSong| p != &playlist.name;
        self.done.retain(predicate);
        self.remaining.retain(predicate);
    }

    pub fn has_next(&self) -> bool {
        self.done.len() + self.remaining.len() > 0
    }

    pub fn next(&mut self) -> Option<(String, usize)> {
        // All songs were played so reshuffle everything
        if self.remaining.is_empty() {
            self.remaining.append(&mut self.done);
            self.shuffle();
        }
        if self.remaining.is_empty() {
            None
        } else {
            let song = self.remaining.pop().unwrap();
            self.done.push(song.clone());
            Some(song)
        }
    }

    fn shuffle(&mut self) {
        self.remaining.shuffle(&mut thread_rng());
    }
}
