import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:tutter_radio/common/client_event.dart';
import 'package:tutter_radio/common/player.dart';
import 'package:tutter_radio/model/abstract/media_controls.dart';
import 'package:tutter_radio/model/persistence.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';

import 'common/constants.dart';
import 'common/connection_state.dart';
import 'model/abstract/client.dart';
import 'model/abstract/player.dart';
import 'view/util/view_model_provider.dart';

class ViewModel implements ClientEventVisitor {

  final Client client;
  final Player player;
  final MediaControls mediaControls;

  ViewModel(this.client, this.player, this.mediaControls);

  static ViewModel of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ViewModelProvider>()!
        .viewModel;
  }

  final _persistence = Persistence();
  final _metadataCache = MetadataCache();

  final volume = BehaviorSubject<double>();
  final showPotterName = BehaviorSubject<bool>();
  final listenerCount = BehaviorSubject<int?>();
  final isPaused = BehaviorSubject<bool?>();
  final playlists = BehaviorSubject<List<SelectedPlaylist>>();
  final error = BehaviorSubject<Object?>();
  final connectionState = BehaviorSubject<ClientConnectionState>();

  Stream<Metadata?> get metadata =>
      player.getCurrentSongId().map(_metadataCache.get);

  Future<void> init() async {
    await _persistence.init();
    setVolume(_persistence.volume ?? defaultVolume);
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

  void setShowPotter(bool show) {
    showPotterName.add(show);

    client.showPotterName(show);
  }

  void togglePause() {
    final paused = !(isPaused.valueOrNull ?? true);
    
    isPaused.add(paused);
    
    player.pauseResume(paused);
    client.pauseResume(paused);
    mediaControls.pauseResume(paused);
  }

  void toggleSelectPlaylist(SelectedPlaylist playlist) {
    playlist.selected = !playlist.selected;
    playlists.add(playlists.value);
    client.selectPlaylist(playlists.value.indexOf(playlist), playlist.selected);
  }

  void reportSong(String artist, String title, String report) {
    client.reportSong(artist, title, report);
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
  void onData(List<int> data, String songId) {
    player.playFrame(data, songId);
  }

  @override
  void onListenerCount(int count) {
    listenerCount.add(count);
  }

  @override
  void onMetadata(Metadata metadata) {
    _metadataCache.add(metadata);
    _updateNotificationMetadata();
  }

  @override
  void onPauseResume(bool paused) {
    isPaused.add(paused);

    player.pauseResume(paused);
    mediaControls.pauseResume(paused);
  }

  @override
  void onReady() {
    connectionState.add(ClientConnectionState.ready);
  }

  @override
  void onShowPotterName(bool show) {
    showPotterName.add(show);
    _updateNotificationMetadata();
  }

  void _updateNotificationMetadata() {
    // final metadata = this.metadata.valueOrNull;
    //
    // if (metadata != null) {
    //   mediaControls.showMetadata(metadata, showPotterName.valueOrNull ?? false);
    // }
  }

  void _resetState() {
    showPotterName.add(false);
    listenerCount.add(0);
    isPaused.add(true);
    playlists.add([]);
    // metadata.add(null);
    error.add(null);
    connectionState.add(ClientConnectionState.disconnected);
  }
}

class MetadataCache {
  static const int STORE_LAST = 3;
  final _cache = <Metadata>[];

  void add(Metadata metadata) {
    _cache.add(metadata);
    if (_cache.length > STORE_LAST) {
      _cache.removeAt(0);
    }
  }

  Metadata? get(String songId) {
    return _cache.firstWhereOrNull(
            (metadata) => metadata.songId == songId);
  }
}
