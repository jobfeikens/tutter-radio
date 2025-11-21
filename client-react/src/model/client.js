
import { Observable } from "rxjs";
import * as proto from "../generated/message.js";

export function connect(url, outbound) {
  return new Observable((subscriber) => {
    const socket = new WebSocket(url);
    socket.binaryType = "arraybuffer";

    const send = (setter) => {
      let message = {};
      setter(message);
      socket.send(proto.ServerBound.encode(message).finish().buffer);
    };

    const outboundSubscription = outbound.subscribe({
      next: (visitable) => {
        visitable({
          playPause: (isPaused) =>
            send((message) => (message.playPause = { isPaused: isPaused })),
          selectPlaylist: (index, selected) =>
            send(
              (message) =>
                (message.selectPlaylist = {
                  index,
                  selected,
                }),
            ),
          showPotterName: (show) =>
            send((message) => (message.showPotterName = { show })),
          reportSong: (artist, title, explanation) =>
            send(
              (message) =>
                (message.reportSong = {
                  artist,
                  title,
                  explanation,
                }),
            ),
        });
      },
      error: subscriber.error,
      complete: subscriber.complete,
    });

    socket.onmessage = (event) => {
      let message;

      try {
        message = proto.ClientBound.decode(new Uint8Array(event.data));
      } catch (error) {
        subscriber.error(error);
        return;
      }

      if (message.playPause) {
        subscriber.next((visitor) =>
          visitor.onPlayPause(message.playPause.isPaused),
        );
      } else if (message.listeners) {
        subscriber.next((visitor) =>
          visitor.onListeners(message.listeners.count),
        );
      } else if (message.clearPlaylists) {
        subscriber.next((visitor) => visitor.onClearPlaylists());
      } else if (message.addPlaylist) {
        subscriber.next((visitor) =>
          visitor.onAddPlaylist(
            message.addPlaylist.name,
            message.addPlaylist.length,
          ),
        );
      } else if (message.selectPlaylist) {
        subscriber.next((visitor) =>
          visitor.onSelectPlaylist(
            message.selectPlaylist.index,
            message.selectPlaylist.selected,
          ),
        );
      } else if (message.comment) {
        subscriber.next((visitor) =>
          visitor.onComment(
            message.comment.songId,
            Object.fromEntries(
              message.comment.entries.map((entry) => [entry.key, entry.value]),
            ),
          ),
        );
      } else if (message.ready) {
        subscriber.next((visitor) => visitor.onReady());
      } else if (message.data) {
        subscriber.next((visitor) =>
          visitor.onData(message.data.songId, message.data.data),
        );
      } else if (message.showPotterName) {
        subscriber.next((visitor) =>
          visitor.onShowPotterName(message.showPotterName.show),
        );
      }
    };

    socket.onerror = (event) => {
      subscriber.error(event);
    };

    socket.onclose = () => {
      subscriber.error("End of stream");
    };

    return () => {
      outboundSubscription.unsubscribe();
      socket.close();  // GOING_AWAY
    };
  });
}
