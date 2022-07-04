use crate::generated::message as pb;
use crate::PlayerEvent;

pub fn convert_event(event: PlayerEvent) -> pb::ClientBound {
    let mut message = pb::ClientBound::new();

    match event {
        PlayerEvent::HeartBeat => {
            message.set_heart_beat(pb::HeartBeat::default());
        }
        PlayerEvent::PlayPause(paused) => {
            let mut play_pause = pb::PlayPause::new();
            play_pause.is_paused = paused;
            message.set_play_pause(play_pause);
        }
        PlayerEvent::Listeners(count) => {
            let mut listeners = pb::Listeners::new();
            listeners.count = count as u64;
            message.set_listeners(listeners);
        }
        PlayerEvent::ClearPlaylists() => {
            message.set_clear_playlists(pb::ClearPlaylists::default());
        }
        PlayerEvent::AddPlaylist(name, length) => {
            let mut add_playlist = pb::AddPlaylist::new();
            add_playlist.name = name;
            add_playlist.length = length as u64;
            message.set_add_playlist(add_playlist);
        }
        PlayerEvent::SelectPlaylist(index, selected) => {
            let mut select_playlist = pb::SelectPlaylist::new();
            select_playlist.index = index as u64;
            select_playlist.selected = selected;
            message.set_select_playlist(select_playlist);
        }
        PlayerEvent::Metadata(comment_data) => {
            let mut comment = pb::Comment::new();

            if let Some(comment_data) = comment_data {
                for (key, value) in comment_data.entries {
                    let mut entry = pb::CommentEntry::new();
                    entry.key = key;
                    entry.value = value;
                    comment.entries.push(entry);
                }
            } else {
                comment.noComment = true;
            }
            message.set_comment(comment);
        }
        PlayerEvent::Ready => {
            message.set_ready(pb::Ready::default());
        }
        PlayerEvent::OpusData(frame) => {
            let mut opus_data = pb::OpusData::new();

            opus_data.data = frame.data.clone();
            opus_data.duration = frame.duration.as_micros() as u32;

            message.set_data(opus_data);
        }
        PlayerEvent::ShowPotterName(show) => {
            let mut show_potter_name = pb::ShowPotterName::new();
            show_potter_name.show = show;
            message.set_show_potter_name(show_potter_name);
        }
    };
    message
}
