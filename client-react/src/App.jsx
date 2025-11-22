import "./App.css";
import { IconButton, ListItem, Slider } from "./components";
import { HamburgerMenuIcon } from "@radix-ui/react-icons";
import { useState } from "react";
import { useModel } from "./model/model.js";
import { AlbumArt } from "./AlbumArt.jsx";
import { Checkbox } from "./components/Checkbox.jsx";

function App() {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [imageUrl, setImageUrl] = useState("");

  const [
    listeners,
    playlists,
    comment,
    [showPotterName, setShowPotterName],
    selectPlaylist,
    [volume, setVolume],
  ] = useModel();

  return (
    <div className="app-root">
      <header className="app-bar">
        <div className="app-bar-section left">
          <IconButton onClick={() => setSidebarOpen(!sidebarOpen)}>
            <HamburgerMenuIcon />
          </IconButton>
        </div>
        <div className="app-bar-title">
          <h1>
            <span className="tutter-blue">Tutter</span>
            <span> radio</span>
          </h1>
        </div>
        <div className="app-bar-section right"></div>
      </header>
      <div className="app-container">
        {sidebarOpen && (
          <div className="sidebar">
            <div className="sidebar-content">
              <h2>Volume</h2>
              <Slider
                min={0.0}
                max={1.0}
                step={0.01}
                value={volume}
                onChange={(event) => {
                  setVolume(event.target.value);
                }}
              />
              <h2>Afspeellijsten</h2>
              {Object.entries(playlists)
                .sort(([key1, _], [key2, __]) => key1.localeCompare(key2))
                .map(([key, playlist]) => (
                  <ListItem
                    title={key}
                    subtitle={`${playlist.length ?? 0} nummers`}
                    leading={
                      <Checkbox
                        checked={playlist.selected}
                        onMouseDown={() => {
                          selectPlaylist(key, !playlist.selected);
                        }}
                      />
                    }
                  />
                ))}
              <h2>Opties</h2>
              <ListItem
                leading={
                  <Checkbox
                    checked={showPotterName}
                    onMouseDown={() => {
                      setShowPotterName(!showPotterName);
                    }}
                  />
                }
                title={"Laat Potter zien"}
              />
            </div>
          </div>
        )}
        <div className="main-content">
          <div>
            <AlbumArt comment={comment} className={"album-art"} />
            <h2>{`${comment?.artist ?? "Unknown artist"} - ${comment?.title ?? "Unknown title"}`}</h2>
            <h4>
              <span>{comment?.album ?? "Unknown album"}</span>
              {showPotterName && <span>{` (${comment?.potter})`}</span>}
            </h4>
            <h4>{listeners}</h4>
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
