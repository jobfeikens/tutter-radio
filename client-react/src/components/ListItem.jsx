import "./ListItem.css";

export function ListItem(props) {
  const { leading, title, subtitle, ...other } = props;

  return (
    <div className="playlist-item" {...other}>
      {leading}
      <div className="playlist-text">
        <div>
          {title && <h4>{title}</h4>}
          {subtitle && <h5>{subtitle}</h5>}
        </div>
      </div>
    </div>
  );
}
