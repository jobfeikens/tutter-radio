import { Subject } from "rxjs";
import { connect } from "./client.js";
import { useEffect, useState } from "react";
import { init_player } from "./player.js";

const player = await init_player();

export function useModel() {
  const [comment, setComment] = useState();

  const [subscription] = useState()

  useEffect(() => {
    const subscription = connect(
      "ws://localhost:8443",
      new Subject(),
    ).subscribe({
      next: (visitable) =>
      {
        visitable({
          onPlayPause(isPaused) {},
          onListeners(count) {},
          onClearPlaylists() {},
          onAddPlaylist(name, length) {},
          onSelectPlaylist(index, selected) {},
          onComment(songId, comment) {
            setComment(comment);
          },
          onReady() {
            console.info("READY!!");
          },
          onData(songId, data) {

            player.playFrame(data, songId).then(() => {

            });
          },
          onShowPotterName(show) {},
        })
      },
      error: (error) => {
        console.error(error);
      },
      complete: () => {

      },
    });

    return () => subscription.unsubscribe();
  }, [])

  return [comment];
}
