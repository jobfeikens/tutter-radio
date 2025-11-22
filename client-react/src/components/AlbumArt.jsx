import { useEffect, useState } from "react";
import { decodeMetadataBlockPicture } from "../util.js";
import "./AlbumArt.css";

export function AlbumArt(props) {
  let { comment, ...imgProps } = props;

  const [imageUrl, setImageUrl] = useState("");

  useEffect(() => {
    const metadataBlockPicture = comment?.["metadata_block_picture"];

    if (!metadataBlockPicture) {
      setImageUrl("");
      return;
    }

    const url = URL.createObjectURL(
      new Blob([decodeMetadataBlockPicture(metadataBlockPicture)], {
        type: "image/jpg",
      }),
    );
    setImageUrl(url);

    return () => URL.revokeObjectURL(url);
  }, [comment]);

  return (
    <img
      {...imgProps}
      src={imageUrl}
      alt={`${comment?.["artist"] ?? "Unknown artist"} - ${comment?.["title"] ?? "Unknown title"}`}
    />
  );
}
