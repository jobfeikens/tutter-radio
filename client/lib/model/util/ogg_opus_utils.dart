import 'dart:convert';
import 'dart:typed_data';

// Frame size in microseconds
int getFrameSize(Uint8List frame) {
  final tocByte = frame[0];
  final config = tocByte >> 3;

  switch (config) {
    case 16:
    case 20:
    case 24:
    case 28:
      return 2500;
    case 17:
    case 21:
    case 25:
    case 29:
      return 5000;
    case 0:
    case 4:
    case 8:
    case 12:
    case 14:
    case 18:
    case 22:
    case 26:
    case 30:
      return 10000;
    case 1:
    case 5:
    case 9:
    case 13:
    case 15:
    case 19:
    case 23:
    case 27:
    case 31:
      return 20000;
    case 2:
    case 6:
    case 10:
      return 40000;
    case 3:
    case 7:
    case 11:
      return 60000;
    default:
      throw StateError('Unreachable');
  }
}

Uint8List decodeMetadataBlockPicture(String block) {
  final decoded = base64.decode(base64.normalize(block));

  var buffer = decoded.buffer.asByteData();

  final mimeSize = buffer.getUint32(4);
  final descriptionSize = buffer.getUint32(8 + mimeSize);

  final offset = 8 + mimeSize + 4 + descriptionSize + 20;

  return decoded.sublist(offset);
}
