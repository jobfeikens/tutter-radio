import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';import 'package:potter_music_client/common/client_event.dart';
import 'package:potter_music_client/common/player.dart';
import 'package:potter_music_client/model/persistence.dart';
import 'package:rxdart/rxdart.dart';

import 'common/constants.dart';
import 'common/connection_state.dart';
import 'model/abstract/client.dart';
import 'model/abstract/player.dart';
import 'view/util/view_model_provider.dart';

class ViewModel implements ClientEventVisitor {

  final Client client;
  final Player player;

  ViewModel(this.client, this.player);

  static ViewModel of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ViewModelProvider>()!
        .viewModel;
  }

  final _persistence = Persistence();

  final volume = BehaviorSubject<double>();
  final showPotter = BehaviorSubject<bool>();
  final listenerCount = BehaviorSubject<int?>();
  final isPaused = BehaviorSubject<bool?>();
  final playlists = BehaviorSubject<List<SelectedPlaylist>>();
  final metadata = BehaviorSubject<Metadata?>();
  final error = BehaviorSubject<Object?>();
  final connectionState = BehaviorSubject<ClientConnectionState>();

  Future<void> init() async {
    await _persistence.init();
    setVolume(_persistence.volume ?? defaultVolume);
    setShowPotter(_persistence.showPotter ?? true);
    _resetState();
  }

  StreamSubscription<void>? _runOperation;

  void connect() {
    if (_runOperation != null) {
      throw StateError('Already connected');
    }
    _resetState();

    connectionState.add(ClientConnectionState.connecting);

    _runOperation =
        client.run().listen((event) => event.visit(this), onDone: () {
          connectionState.add(ClientConnectionState.disconnected);

          _runOperation = null;

    }, onError: (error) {
      if (kDebugMode) {
        print('Client error: $error');
      }
      this.error.add(error);
      connectionState.add(ClientConnectionState.disconnected);
    });
  }

  void setVolume(double volume) {
    this.volume.add(volume);

    player.setVolume(volume);
    _persistence.volume = volume;
  }

  void setShowPotter(bool showPotter) {
    this.showPotter.add(showPotter);
    _persistence.showPotter = showPotter;
  }

  void togglePause() {
    final paused = !(isPaused.valueOrNull ?? true);
    
    isPaused.add(paused);
    
    player.pauseResume(paused);
    client.pauseResume(paused);
  }

  void toggleSelectPlaylist(SelectedPlaylist playlist) {
    playlist.selected = !playlist.selected;
    playlists.add(playlists.value);
    client.selectPlaylist(playlists.value.indexOf(playlist), playlist.selected);
  }

  void dispose() {
    _runOperation?.cancel();
  }

  @override
  void onClearPlaylists() {
    playlists.add([]);
  }

  @override
  void onAddPlaylist(Playlist playlist) {
    final playlists = this.playlists.valueOrNull ?? [];
    playlists.add(SelectedPlaylist(playlist, true));
    this.playlists.add(playlists);
  }

  @override
  void onSelectPlaylist(int playlist, bool selected) {
    final playlists = this.playlists.valueOrNull ?? [];
    playlists[playlist].selected = selected;
    this.playlists.add(playlists);
  }

  @override
  void onData(List<int> data) {
    player.playFrame(data);
  }

  @override
  void onListenerCount(int count) {
    listenerCount.add(count);
  }

  @override
  void onMetadata(Metadata? metadata) {
    this.metadata.add(metadata);
  }

  @override
  void onPauseResume(bool paused) {
    isPaused.add(paused);
    
    player.pauseResume(paused);
    client.pauseResume(paused);
  }

  @override
  void onReady() {
    connectionState.add(ClientConnectionState.ready);
  }

  void _resetState() {
    listenerCount.add(0);
    isPaused.add(true);
    playlists.add([]);
    metadata.add(null);
    error.add(null);
    connectionState.add(ClientConnectionState.disconnected);
  }
}
