import "./App.css";
import { IconButton } from "./IconButton.jsx";
import { HamburgerMenuIcon } from "@radix-ui/react-icons";
import { useState } from "react";
import { useModel } from "./model/model.js";
import { AlbumArt } from "./AlbumArt.jsx";

function App() {
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [imageUrl, setImageUrl] = useState("");

  const [comment] = useModel();

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
            {/*<DropdownMenuDemo/>*/}
            {/*<SliderDemo/>*/}
          </div>
        )}
        <div className="main-content">
          <AlbumArt comment={comment} className={"album-art"}/>
        </div>
      </div>
    </div>
  );
}

export default App;
