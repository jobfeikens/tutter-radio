import '../../common/client_event.dart';

abstract class Client {

  Stream<ClientEvent> run();

  void pauseResume(bool paused);

  void selectPlaylist(int index, bool selected);

  void showPotterName(bool show);

  void reportSong(String artist, String title, String report);
}
