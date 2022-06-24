import 'package:flutter/material.dart';
import 'package:opus_dart/opus_dart.dart';
import 'package:opus_flutter_web/opus_flutter_web.dart';
import 'package:tutter_radio/model/implementation/web_notification_service.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';


import 'model/implementation/web_audio_player.dart';
import 'model/implementation/web_socket_client.dart';
import 'view/tutter_radio_app.dart';
import 'view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initOpus(await OpusFlutterWeb().load());

  final client = WebSocketClient(uri: "wss://tutter.nl:8443");
  final player = WebAudioPlayer()..init();
  final notificationService = WebNotificationService();

  final viewModel = ViewModel(client, player, notificationService); // digitalocean
  //final viewModel = ViewModel(WebSocketClient(uri: "wss://localhost:8443"), player);
  await viewModel.init();
  viewModel.connect();

  setUrlStrategy(PathUrlStrategy());
  runApp(TutterRadioApp(viewModel: viewModel));
}
