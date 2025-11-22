import { Subject } from "rxjs";
import { connect } from "./client.js";
import { useEffect, useState } from "react";
import { init_player } from "./player.js";

const player = await init_player();

export function useModel() {
  const [listeners, setListeners] = useState(0);
  const [playlists, setPlaylists] = useState({});
  const [comment, setComment] = useState();
  const [showPotterName, _setShowPotterName] = useState(false);

  const [volume, _setVolume] = useState(1.0);

  const [outbound] = useState(new Subject());

  const selectPlaylist = (playlist, selected) => {
    outbound.next((visitor) => visitor.onSelectPlaylist(playlist, selected));
    setPlaylists((playlists) => ({
      ...playlists,
      [playlist]: { ...playlists[playlist], selected },
    }));
  };

  const setShowPotterName = (show) => {
    outbound.next((visitor) => visitor.onShowPotterName(show));
    _setShowPotterName(show);
  };

  const setVolume = (volume) => {
    player.setVolume(volume);
    _setVolume(volume);
  }

  useEffect(() => {
    const subscription = connect("ws://localhost:8443", outbound).subscribe({
      next: (visitable) => {
        visitable({
          onPlayPause(isPaused) {
            player.pauseResume(isPaused);
          },
          onListeners(count) {
            setListeners(count);
          },
          onClearPlaylists() {
            setPlaylists({});
          },
          onAddPlaylist(playlist, length) {
            setPlaylists((playlists) => ({
              ...playlists,
              [playlist]: { length, selected: true },
            }));
          },
          onSelectPlaylist(playlist, selected) {
            setPlaylists((playlists) => ({
              ...playlists,
              [playlist]: { ...playlists[playlist], selected },
            }));
          },
          onComment(songId, comment) {
            setComment(comment);
          },
          onReady() {
            console.info("READY!!");
          },
          onData(songId, data) {
            player.playFrame(data, songId).then(() => {});
          },
          onShowPotterName: _setShowPotterName,
        });
      },
      error: (error) => {
        console.error(error);
      },
      complete: () => {},
    });

    return () => subscription.unsubscribe();
  }, []);

  return [
    listeners,
    playlists,
    comment,
    [showPotterName, setShowPotterName],
    selectPlaylist,
    [volume, setVolume],
  ];
}
