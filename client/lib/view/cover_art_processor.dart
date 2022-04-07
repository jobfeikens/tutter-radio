import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../common/player.dart';
import '../model/util/ogg_opus_utils.dart';

class CoverArtCache {

  static Uint8List? cachedData;

  // HashCode of the comment which the cachedData belongs to
  static int? cachedHash;

  static Uint8List? getCoverArt(Metadata comment) {
    if (cachedHash != comment.hashCode) {
      cachedHash = comment.hashCode;

      final block = comment.metadataBlockPicture;
      if (block != null) {
        try {
          cachedData = decodeMetadataBlockPicture(block);

        } catch (exception) {
          if (kDebugMode) {
            print('Unable to decode picture: $exception');
          }
          cachedData = null;
        }
      } else {
        cachedData = null;
      }
    }
    return cachedData;
  }
}