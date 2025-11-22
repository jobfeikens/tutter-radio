// IconButton.jsx
import * as React from "react";
import "./IconButton.css";

export function IconButton(props) {
    const {onClick, children, ariaLabel} = props;

    return (
        <button
            className="icon-button"
            onClick={onClick}
            aria-label={ariaLabel}
            type="button"
        >
            {children}
        </button>
    );
}
