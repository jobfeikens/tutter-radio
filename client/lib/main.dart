import 'package:flutter/material.dart';
import 'package:opus_dart/opus_dart.dart';
import 'package:opus_flutter_web/opus_flutter_web.dart';

import 'model/implementation/web_audio_player.dart';
import 'model/implementation/web_socket_client.dart';
import 'view/tutter_radio_app.dart';
import 'view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initOpus(await OpusFlutterWeb().load());

  final player = WebAudioPlayer()..init();

  final viewModel = ViewModel(WebSocketClient(uri: "wss://tutter.nl:8443"), player); // digitalocean
  //final viewModel = ViewModel(WebSocketClient(uri: "ws://localhost:8080"), player);
  await viewModel.init();
  viewModel.connect();

  runApp(TutterRadioApp(viewModel: viewModel));
}
