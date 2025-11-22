import "./Slider.css"

export function Slider(props) {
  return <div className="icon-volume-slider">
    <input type="range" {...props} />
  </div>
}
