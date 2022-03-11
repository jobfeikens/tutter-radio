use crate::generated::message as pb;
use crate::PlayerEvent;
use protobuf::Message;

pub fn convert_event(event: PlayerEvent) -> pb::ClientBound {
    let mut message = pb::ClientBound::new();

    match event {
        PlayerEvent::HeartBeat => {
            message.set_heart_beat(pb::HeartBeat::default());
        }
        PlayerEvent::PlayPause(paused) => {
            let mut play_pause = pb::PlayPause::new();
            play_pause.set_is_paused(paused);
            message.set_play_pause(play_pause);
        }
        PlayerEvent::Listeners(count) => {
            let mut listeners = pb::Listeners::new();
            listeners.set_count(count as u64);
            message.set_listeners(listeners);
        }
        PlayerEvent::ClearPlaylists() => {
            message.set_clear_playlists(pb::ClearPlaylists::default());
        }
        PlayerEvent::AddPlaylist(name, length) => {
            let mut add_playlist = pb::AddPlaylist::new();
            add_playlist.set_name(name);
            add_playlist.set_length(length as u64);
            message.set_add_playlist(add_playlist);
        }
        PlayerEvent::SelectPlaylist(index, selected) => {
            let mut select_playlist = pb::SelectPlaylist::new();
            select_playlist.set_index(index as u64);
            select_playlist.set_selected(selected);
            message.set_select_playlist(select_playlist);
        }
        PlayerEvent::Ready => {
            message.set_ready(pb::Ready::default());
        }
        PlayerEvent::OpusFrame(data) => {
            let mut opus_frame = pb::OpusFrame::new();
            opus_frame.set_data(data);
            message.set_opus_frame(opus_frame);
        }
    };
    message
}
