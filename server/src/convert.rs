use crate::generated::message as pb;
use crate::PlayerEvent;
use protobuf::Message;

pub fn convert_event(event: PlayerEvent) -> pb::Message {
    let mut message = pb::Message::new();

    match event {
        PlayerEvent::HeartBeat => {
            message.set_heart_beat(pb::HeartBeat::default());
        }
        PlayerEvent::PlayPause(paused) => {
            let mut p = pb::PlayPause::new();
            p.set_isPaused(paused);

            message.set_play_pause(p);
        }
        PlayerEvent::Listeners(listeners) => {
            let mut p = pb::Listeners::new();
            p.set_listeners(listeners as u64);

            message.set_listeners(p);
        }
        PlayerEvent::Ready => {
            message.set_ready(pb::Ready::default());
        }
        _ => todo!()
    };
    message
}
