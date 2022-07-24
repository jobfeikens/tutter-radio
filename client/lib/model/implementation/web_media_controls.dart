import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:tutter_radio/common/player.dart';
import 'package:tutter_radio/model/abstract/media_controls.dart';
import 'package:js/js_util.dart' as js;


import 'package:tutter_radio/view/cover_art_processor.dart';


class WebMediaControls implements MediaControls {
  MediaSession? get mediaSession => window.navigator.mediaSession;

  late final AudioElement audioElement;

  String? _pictureUrl;

  void init() {
    audioElement = AudioElement()
      ..src = 'https://raw.githubusercontent.com/anars/blank-audio/master/10-seconds-of-silence.mp3'
      ..loop = true;

    audioElement.addEventListener('canplaythrough', (event) async {
      try {
        await audioElement.play();
      } catch (e) {
        window.addEventListener('click', (event) {
          audioElement.play();
        });
      }
    });
    document.body?.children.add(audioElement);
  }

  @override
  void registerHandlers(void Function() play, void Function() pause) {

    if (mediaSession == null) {
      return;
    }
    final actionHandlers = {
      'play': play,
      'pause': pause,
    };
    for (var entry in actionHandlers.entries) {
      try {
        mediaSession!.setActionHandler(entry.key, entry.value);
      } catch (error) {
        if (kDebugMode) {
          print('Unable to set action handler: ${entry.key}');
        }
      }
    }
  }

  @override
  void showMetadata(Metadata metadata, bool showPotter) async {

    if (mediaSession == null) {
      return;
    }
    if (_pictureUrl != null) {
      Url.revokeObjectUrl(_pictureUrl!);
    }
    var imageData = CoverArtCache.getCoverArt(metadata);

    Object? artwork;
    
    // If the song has cover art
    if (imageData != null) {
      var transformedImageData = await compute(_transformImage, imageData);

      // If the image was transformed successfully
      if (transformedImageData != null) {
        artwork = js.newObject()!;
        js.setProperty(artwork, 'src', Url.createObjectUrl(Blob([transformedImageData])));
        js.setProperty(artwork, 'sizes', '512x512');
        js.setProperty(artwork, 'type', 'image/jpeg');
      }
    }
    mediaSession!.playbackState = 'playing';

    var title = metadata.title;
    if (showPotter) {
      title = '$title (${metadata.potter})';
    }

    mediaSession!.metadata = MediaMetadata()
      ..artist = metadata.artist
      ..title = title
      ..album = metadata.album
      ..artwork = [
        if (artwork != null)
          artwork
      ];
  }

  @override
  void pauseResume(bool paused) {
    if (paused) {
      audioElement.pause();
      mediaSession?.playbackState = 'paused';
    } else {
      audioElement.play();
      mediaSession?.playbackState = 'playing';
    }
  }
}

Uint8List? _transformImage(Uint8List imageData) {
  var image = decodeImage(imageData);

  if (image == null) {
    return null;
  }
  image = copyResize(image, width: 512, height: 512);

  return Uint8List.fromList(encodePng(image));
}
