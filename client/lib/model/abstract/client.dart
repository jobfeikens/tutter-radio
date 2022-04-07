import '../../common/client_event.dart';

abstract class Client {

  Stream<ClientEvent> run();

  void pauseResume(bool paused);

  void selectPlaylist(int index, bool selected);
}
