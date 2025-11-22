import "./HomePage.css";
import { IconButton, ListItem, Slider, useModelContext } from "../components";
import { HamburgerMenuIcon, PersonIcon } from "@radix-ui/react-icons";
import { useState } from "react";
import { useModel } from "../model/model.js";
import { AlbumArt } from "../components/AlbumArt.jsx";
import { Checkbox } from "../components/Checkbox.jsx";

function HomePage() {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [imageUrl, setImageUrl] = useState("");

  const model = useModelContext();

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
                value={model.volume}
                onChange={(event) => {
                  setVolume(event.target.value);
                }}
              />
              <h2>Afspeellijsten</h2>
              {Object.entries(model.playlists)
                .sort(([key1, _], [key2, __]) => key1.localeCompare(key2))
                .map(([key, playlist]) => (
                  <ListItem
                    title={key}
                    subtitle={`${playlist.length ?? 0} nummers`}
                    leading={
                      <Checkbox
                        checked={playlist.selected}
                        onMouseDown={() => {
                          model.selectPlaylist(key, !playlist.selected);
                        }}
                      />
                    }
                  />
                ))}
              <h2>Opties</h2>
              <ListItem
                leading={
                  <Checkbox
                    checked={model.showPotterName}
                    onMouseDown={() => {
                      model.setShowPotterName(!model.showPotterName);
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
            <AlbumArt comment={model.comment} className={"album-art"} />
            <h2>{`${model.comment?.artist ?? "Unknown artist"} - ${model.comment?.title ?? "Unknown title"}`}</h2>
            <h4>
              <span>{model.comment?.album ?? "Unknown album"}</span>
              {model.showPotterName && model.comment?.potter && (
                <span>{` (${model.comment.potter})`}</span>
              )}
            </h4>
            <h4><PersonIcon /> {model.listeners}</h4>
          </div>
        </div>
      </div>
    </div>
  );
}

export default HomePage;
