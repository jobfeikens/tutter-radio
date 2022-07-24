
import 'package:tutter_radio/common/player.dart';

abstract class MediaControlHandler {

  void play();

  void pause();
}

abstract class MediaControls {
  void registerHandlers(void Function() play, void Function() pause);

  void showMetadata(Metadata metaData, bool showPotter);

  void pauseResume(bool playPause);
}
