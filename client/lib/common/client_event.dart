import 'player.dart';

abstract class ClientEventVisitor {

  void onListenerCount(int count);

  void onClearPlaylists();

  void onAddPlaylist(Playlist playlist);

  void onSelectPlaylist(int playlist, bool selected);

  void onMetadata(Metadata metadata);

  void onReady();

  void onPauseResume(bool paused);

  void onData(List<int> data, String songId);

  void onShowPotterName(bool show);
}

abstract class ClientEvent {
  ClientEvent._();

  void visit(ClientEventVisitor visitor);
}

class EventListenerCount implements ClientEvent {
  late final int count;

  @override
  void visit(ClientEventVisitor visitor) => visitor.onListenerCount(count);
}

class EventClearPlaylists implements ClientEvent {

  @override
  void visit(ClientEventVisitor visitor) => visitor.onClearPlaylists();
}

class EventAddPlaylist implements ClientEvent {
  late final Playlist playlist;

  @override
  void visit(ClientEventVisitor visitor) => visitor.onAddPlaylist(playlist);
}

class EventSelectPlaylist implements ClientEvent {
  late final int playlist;
  late final bool selected;

  @override
  void visit(ClientEventVisitor visitor) => visitor.onSelectPlaylist(playlist, selected);
}

class EventMetadata implements ClientEvent {
  late final Metadata metadata;

  @override
  void visit(ClientEventVisitor visitor) => visitor.onMetadata(metadata);
}

class EventReady implements ClientEvent {

  @override
  void visit(ClientEventVisitor visitor) => visitor.onReady();
}

class EventPauseResume implements ClientEvent {
  late final bool paused;

  @override
  void visit(ClientEventVisitor visitor) => visitor.onPauseResume(paused);
}

class EventData implements ClientEvent {
  late final List<int> dat.a;
  late final String songId;

  @override
  void visit(ClientEventVisitor visitor) => visitor.onData(data, songId);
}

class EventShowPotterName implements ClientEvent {
  late final bool show;

  @override
  void visit(ClientEventVisitor visitor) => visitor.onShowPotterName(show);
}
