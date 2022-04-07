abstract class Player {

  void setVolume(double volume);

  void pauseResume(bool paused);

  void playFrame(List<int> encodedFrame);

  void dispose();
}
