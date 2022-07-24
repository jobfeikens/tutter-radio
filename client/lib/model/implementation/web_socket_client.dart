import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tutter_radio/common/connection_state.dart';
import 'package:tutter_radio/common/player.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tutter_radio/generated/message.pbserver.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:fixnum/fixnum.dart';

import '../../common/client_event.dart';
import '../abstract/client.dart';
import '../../common/client_event.dart';
import '../../common/connection_state.dart';
import '../../generated/message.pb.dart' as pb;

class WebSocketClient extends Client {
  final dynamic uri;

  WebSocketClient({this.uri});

  final connectionState =
      BehaviorSubject.seeded(ClientConnectionState.disconnected);

  late WebSocketChannel channel;

  @override
  Stream<ClientEvent> run() {
    final controller =
        StreamController<ClientEvent>(onCancel: () => channel.sink.close());

    Future(() async {
      try {
        channel = HtmlWebSocketChannel.connect(uri);

        await for (final data in channel.stream) {
          final pb.ClientBound proto;

          try {
            proto = pb.ClientBound.fromBuffer(data);
          } catch (exception) {
            // Message is not readable

            if (kDebugMode) {
              print('Unable to decode proto: $exception');
            }
            continue;
          }
          final message = _convertEvent(proto);

          if (message != null) {
            controller.add(message);
          }
        }
        controller.addError('End of stream');

      } catch (error) {
        controller.addError(error);
        rethrow;

      } finally {
        controller.close();
        channel.sink.close();
      }
    });

    return controller.stream;
  }

  @override
  void pauseResume(bool paused) {
    _sendMessage((message) => message.playPause = pb.PlayPause(isPaused: paused));
  }

  @override
  void selectPlaylist(int index, bool selected) {
    _sendMessage((message) => {
          message.selectPlaylist =
              pb.SelectPlaylist(index: Int64(index), selected: selected)
        });
  }

  @override
  void showPotterName(bool show) {
    _sendMessage((message) =>
    message.showPotterName = pb.ShowPotterName(show: show));
  }

  @override
  void reportSong(String artist, String title, String report) {
    _sendMessage((message) => message.reportSong =
        pb.ReportSong(artist: artist, title: title, explanation: report));
  }

  void _sendMessage(Function(pb.ServerBound) assign) {
    final message = pb.ServerBound();
    assign.call(message);
    channel.sink.add(message.writeToBuffer());
  }

  ClientEvent? _convertEvent(pb.ClientBound message) {

    switch (message.whichType()) {
      case pb.ClientBound_Type.playPause:
        return EventPauseResume()..paused = message.playPause.isPaused;

      case pb.ClientBound_Type.listeners:
        return EventListenerCount()..count = message.listeners.count.toInt();

      case pb.ClientBound_Type.clearPlaylists:
        return EventClearPlaylists();

      case pb.ClientBound_Type.addPlaylist:
        return EventAddPlaylist()
          ..playlist = Playlist(
              message.addPlaylist.name, message.addPlaylist.length.toInt());

      case pb.ClientBound_Type.selectPlaylist:
        return EventSelectPlaylist()
          ..playlist = message.selectPlaylist.index.toInt()
          ..selected = message.selectPlaylist.selected;

      case pb.ClientBound_Type.comment:
        final event = EventMetadata();

        if (message.comment.hasNoComment()) {
          event.metadata = null;

        } else {
          final entries = <String, String>{};

          for (final entry in message.comment.entries) {
            entries[entry.key] = entry.value;
          }
          event.metadata = Metadata(entries);
        }
        return event;

      case pb.ClientBound_Type.ready:
        return EventReady();

      case pb.ClientBound_Type.data:
        return EventData()..data = message.data.data;
        
      case pb.ClientBound_Type.showPotterName:
        return EventShowPotterName()..show = message.showPotterName.show;

      default:
        return null;
    }
  }
}
