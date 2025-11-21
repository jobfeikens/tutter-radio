export function decodeMetadataBlockPicture(block) {
  const decoded = Uint8Array.fromBase64(block);
  const dataView = new DataView(decoded.buffer);

  const mimeSize = dataView.getUint32(4);
  const descriptionSize = dataView.getUint32(8 + mimeSize);

  const offset = 8 + mimeSize + 4 + descriptionSize + 20;

  return decoded.slice(offset);
}
