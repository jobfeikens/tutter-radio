import "./Checkbox.css";

export function Checkbox(props) {
  const {onMouseDown, ...inputProps} = props;

  return <label className="icon-checkbox" onMouseDown={onMouseDown}>
    <input type="checkbox" {...props} />
    <span className="checkmark">
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round"
         stroke-linejoin="round">
      <polyline points="20 6 9 17 4 12"></polyline>
    </svg>
  </span>
  </label>
}
