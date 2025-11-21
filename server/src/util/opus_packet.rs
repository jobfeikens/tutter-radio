use std::cmp::min;
use std::collections::HashMap;
use std::time::Duration;
use byteorder::{ByteOrder, LE};

const HEADER_SIGNATURE: [u8; 8] = [
    0x4F, // O
    0x70, // p
    0x75, // u
    0x73, // s
    0x48, // H
    0x65, // e
    0x61, // a
    0x64, // d
];

const COMMENT_SIGNATURE: [u8; 8] = [
    0x4F, // O
    0x70, // p
    0x75, // u
    0x73, // s
    0x54, // T
    0x61, // a
    0x67, // g
    0x73, // s
];

#[derive(Clone, Debug)]
pub struct VorbisCommentData {
    pub entries: HashMap<String, String>
}

#[derive(Clone, Debug)]
pub struct OpusFrame {
    pub duration: Duration, // microseconds, from 2.5ms to 120ms
    pub data: Vec<u8>,
}

pub enum OggData {
    OggHeader(),
    VorbisComment(VorbisCommentData),
    Opus(OpusFrame),
}

pub fn read_packet(data: Vec<u8>) -> OggData {
    let begin = &data[0..min(8, data.len())];

    if begin == HEADER_SIGNATURE {
        OggData::OggHeader()

    } else if begin == COMMENT_SIGNATURE {
        OggData::VorbisComment(decode_comment(data[8..].to_vec()))

    } else {
        OggData::Opus(decode_opus(data))
    }
}

fn decode_opus(buffer: Vec<u8>) -> OpusFrame {
    let toc_byte = buffer[0];
    let config = toc_byte >> 3;

    let mut frame_size = match config {
        16 | 20 | 24 | 28 => 2500,
        17 | 21 | 25 | 29 => 5000,
        0 | 4 | 8 | 12 | 14 | 18 | 22 | 26 | 30 => 10000,
        1 | 5 | 9 | 13 | 15 | 19 | 23 | 27 | 31 => 20000,
        2 | 6 | 10 => 40000,
        3 | 7 | 11 => 60000,
        _ => unreachable!()
    };

    let code = toc_byte & 0b11;

    match code {
        1 | 2 => frame_size *= 2,
        3 => {
            let count = buffer[1] as u16 & 0x3F;
            frame_size *= count;
        }
        _ => {},
    };

    OpusFrame {
        duration: Duration::from_micros(frame_size as u64),
        data: buffer
    }
}

fn decode_comment(buffer: Vec<u8>) -> VorbisCommentData {
    let mut pos = 0usize;

    let vendor_length = LE::read_u32(&buffer[pos..]) as usize;
    pos += 4 + vendor_length;

    let list_length = LE::read_u32(&buffer[pos..]);
    pos += 4;

    let mut entries = HashMap::new();

    for _ in 0..list_length {
        let entry_length = LE::read_u32(&buffer[pos..]) as usize;
        pos += 4;
        let comment = std::str::from_utf8(&buffer[pos..pos + entry_length]).unwrap();
        let split: Vec<&str> = comment.split('=').collect();
        entries.insert(split[0].to_string(), split[1].to_string());
        pos += entry_length;
    }
    VorbisCommentData { entries }
}
