import "./Slider.css"
import { IconButton } from "./IconButton";
import { SpeakerOffIcon, SpeakerQuietIcon, SpeakerModerateIcon, SpeakerLoudIcon } from "@radix-ui/react-icons";

function getSpeakerIcon(volume) {
  if (volume == 0.0) {
    return <SpeakerOffIcon />
  } else if (volume <= 0.33) {
    return <SpeakerQuietIcon />;
  } else if (volume <= 0.66) {
    return <SpeakerModerateIcon />;
  } else {
    return <SpeakerLoudIcon />;
  }
}

export function Slider(props) {
  return (
    <div className="icon-volume-slider">
      <IconButton
        ariaLabel="Turn off volume"
        className="slider-speaker-button"
        onClick={() => console.log("Turn off volume")}
      >
        {getSpeakerIcon(props.value)}
      </IconButton>
      <input type="range" {...props} />
    </div>
  )
}
