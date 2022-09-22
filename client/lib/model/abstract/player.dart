import 'dart:typed_data';

abstract class Player {

  void setVolume(double volume);

  void pauseResume(bool paused);

  Future<void> playFrame(List<int> encodedFrame);

  void dispose();
}
