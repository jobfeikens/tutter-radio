import 'dart:async';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:potter_music_client/generated/message.pb.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'generated/message.pb.dart' as pb;


class Socket {

  Stream<Message> getMessages() {
    throw Exception();
  }

  static Future<Socket> connect() {
    throw Exception();
  }

  Future<void> close() {
    throw Exception();
  }
}

class Client {
  final _connectedSubject = BehaviorSubject.seeded(false);

  final _isPlaying = BehaviorSubject<bool>();
  final _numberOfListeners = BehaviorSubject<int>();

  final dynamic uri;
  
  Client(this.uri);
  
  WebSocketChannel? _channel;

  CancelableOperation<void> run() {
    if (_channel != null) {
      throw StateError('Already connected');
    }
    _channel = HtmlWebSocketChannel.connect(uri);
    
    return CancelableOperation.fromFuture(Future(() async {
      try {
        _connectedSubject.add(true);

        await for (final data in _channel!.stream) {
          final pb.Message message;

          try {
            message = pb.Message.fromBuffer(data);

          } catch (exception) {
            // Message is not readable

            if (kDebugMode) {
              print('$exception');
            }
            continue;
          }
          _onMessage(message);
        }
      } finally {
        _channel = null;
        _connectedSubject.add(false);
      }
    }), onCancel: () async {
      _channel!.sink.close();
    });
  }

  void _onMessage(pb.Message message) {
    switch (message.whichType()){
      
      case Message_Type.paused:
        _isPlaying.add(false);
        break;

      case Message_Type.resumed:
        _isPlaying.add(true);
        break;

      case Message_Type.listeners:
        _numberOfListeners.add(message.listeners.listeners.toInt());
        break;

      default:
        break;
    }
  }
  
  void resume() {
    _isPlaying.add(true);
    _sendMessage((message) => message.resumed = pb.Resumed());
  }

  void pause() {
    ImplicitlyAnimatedWidget;
    _isPlaying.add(false);
    _sendMessage((message) => message.paused = pb.Paused());
  }

  bool? get isPlaying => _isPlaying.valueOrNull;
  Stream<bool> get isPlayingStream => _isPlaying.stream;

  int? get numberOfListeners => _numberOfListeners.valueOrNull;
  Stream<int> get numberOfListenersStream => _numberOfListeners.stream;
  
  void dispose() {
    _isPlaying.close();
  }

  void _sendMessage(Function(pb.Message) assign) {
    final message = pb.Message();
    assign.call(message);
    _channel!.sink.add(message.writeToBuffer());
  }
}
