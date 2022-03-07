use crate::generated::message as pb;
use crate::PlayerEvent;
use protobuf::Message;

pub fn convert_event(event: PlayerEvent) -> pb::Message {
    let mut message = pb::Message::new();

    match event {
        PlayerEvent::HeartBeat => {
            message.set_heart_beat(pb::HeartBeat::default());
        }
        PlayerEvent::Paused => {
            message.set_paused(pb::Paused::default());
        }
        PlayerEvent::Resumed => {
            message.set_resumed(pb::Resumed::default());
        }
        PlayerEvent::Listeners(listeners) => {
            let mut p = pb::Listeners::new();
            p.set_listeners(listeners as u64);

            message.set_listeners(p);
        }
    };
    message
}
