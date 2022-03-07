import 'dart:math';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:opus_dart/opus_dart.dart';
import 'package:opus_flutter_web/opus_flutter_web.dart';
import 'package:potter_music_client/player.dart';
import 'package:potter_music_client/util/exception_viewer.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initOpus(await OpusFlutterWeb().load());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color(0xFF8BCEFC),
        scaffoldBackgroundColor: const Color(0xFF1A1C1E),
        brightness: Brightness.dark
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  late final Client player;

  CancelableOperation? connection;
  Object? error;

  @override
  void initState() {
    super.initState();
    player = Client("ws://127.0.0.1:8080");

    runClient();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: const Color(0xFF232A31),
        centerTitle: true,
        title: Text('Tutter Radio',
          style: Theme.of(context).textTheme.headline4,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.featured_play_list)
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(child: buildBody(context)),
          buildFooter(context)
        ],
      )
    );
  }
  Widget buildBody(BuildContext context) {

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (connection != null)
            StreamBuilder<bool?>(
              initialData: player.isPlaying,
              stream: player.isPlayingStream,
              builder: (context, snapshot) {
                final isPlaying = snapshot.data ?? false;
                return IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => isPlaying ? player.pause() : player.resume(),
                );
              },
            ),
          if (connection == null)
            ElevatedButton(onPressed: () => runClient(), child: Text('Retry')),
          const SizedBox(height: 32),
          if (error != null)
            ExceptionViewer(exception: error)
        ],
      ),
    );
  }

  Widget buildFooter(BuildContext context) {
    return Material(
      color: const Color(0xFF232A31),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: DefaultTextStyle(
            style: Theme.of(context).textTheme.caption ?? const TextStyle(),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('© 2022'),
                      const SizedBox(width: 4,),
                      Text('-'),
                      const SizedBox(width: 4,),
                      Text('Made with Rust'),
                      const SizedBox(width: 8,),
                      buildFooterPicture(assetName: 'assets/ferris.svg', link: 'https://www.rust-lang.org/'),
                      const SizedBox(width: 8,),
                      Text('and Flutter '),
                      buildFooterPicture(assetName: 'assets/flutter.svg', link: 'https://flutter.dev/'),
                    ],
                  ),
                ),
                buildFooterPicture(assetName: 'assets/github.svg', link: 'https://github.com/', color: Theme.of(context).textTheme.caption?.color, tooltip: 'View project on GitHub')
              ],
            )
        ),
      ),
    );
  }
  
  Widget buildFooterPicture({required String assetName, required String link, String? tooltip, Color? color}) {
    return IconButton(
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      onPressed: () => UrlLauncherPlugin().launch(link),
      icon: SvgPicture.asset(assetName,
          height: 20,
        fit: BoxFit.fitHeight,
        color: color,
      ),
      visualDensity: VisualDensity.comfortable,
    );
  }

  void runClient() {

    setState(() {
      connection = player.run();
      error = null;
    });

    Future(() async {
      try {
        await connection!.valueOrCancellation();

      } catch (error) {
        setState(() => this.error = error);

      } finally {
        setState(() => connection = null);
      }
    });
  }
}
