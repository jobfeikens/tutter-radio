import "./VolumeSlider.css";
import { IconButton } from "./IconButton";
import {
  SpeakerOffIcon,
  SpeakerQuietIcon,
  SpeakerModerateIcon,
  SpeakerLoudIcon,
} from "@radix-ui/react-icons";
import { useState } from "react";

function getSpeakerIcon(volume) {
  if (volume === 0.0) {
    return <SpeakerOffIcon />;
  } else if (volume <= 0.33) {
    return <SpeakerQuietIcon />;
  } else if (volume <= 0.66) {
    return <SpeakerModerateIcon />;
  } else {
    return <SpeakerLoudIcon />;
  }
}

export function VolumeSlider(props) {
  const { volume, onChange, ...inputProps } = props;
  const [volumeBeforeMute, setVolumeBeforeMute] = useState(undefined);

  const changeValue = (value) => {
    // Input slider doesn't go to 0 on small step values
    onChange(value < 0.0001 ? 0 : value);
  }

  const toggle = () => {
    if (volume === 0.0) {
      // Unmute
      changeValue(volumeBeforeMute ?? 0.5);
    } else {
      // Mute
      setVolumeBeforeMute(volume);
      changeValue(0.0);
    }
  };

  return (
    <div className="icon-volume-slider">
      <IconButton
        ariaLabel="Turn off volume"
        className="slider-speaker-button"
        onClick={toggle}
      >
        {getSpeakerIcon(props.volume)}
      </IconButton>
      <input
        type="range"
        {...inputProps}
        value={volume}
        onChange={(event) => changeValue(event.target.value)}
      />
    </div>
  );
}
