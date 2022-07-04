import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher_web/url_launcher_web.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../common/connection_state.dart';
import '../common/constants.dart';
import '../common/player.dart';
import '../view_model.dart';
import 'util/exception_viewer.dart';
import 'util/metadata_builder.dart';
import 'util/subject_builder.dart';


class MyHomePage extends StatefulWidget {

  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  late final AnimationController playPauseAnimationController;
  late final Animation<double> playPauseAnimation;

  StreamSubscription? playPauseSubscription;
  
  @override
  void initState() {
    super.initState();

    playPauseAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    playPauseAnimation = CurvedAnimation(
        parent: playPauseAnimationController,
        curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    playPauseSubscription?.cancel();
    playPauseSubscription = ViewModel.of(context).isPaused.listen((isPaused) { 
      if (isPaused ?? true) {
        playPauseAnimationController.reverse();
      } else {
        playPauseAnimationController.forward();
      }
    });
  }
  
  @override
  void dispose() {
    playPauseSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SubjectBuilder(
      subject: (viewModel) => viewModel.metadata,
      builder: (
        BuildContext context,
        AsyncSnapshot<Metadata?> metadata,
      ) {
        return MetadataProvider(
          metadata: metadata.data,
          child: SubjectBuilder(
            subject: (viewModel) => viewModel.connectionState,
            builder: (
              BuildContext context,
              AsyncSnapshot<ClientConnectionState> connectionState
            ) {
              return Scaffold(
                appBar: buildAppBar(context, connectionState.data),
                body: buildBody(context),
                drawer: buildDrawer(context),
              );
            },
          )
        );
      });
  }

  PreferredSizeWidget buildAppBar(BuildContext context, ClientConnectionState? connectionState) {

    return AppBar(
      toolbarHeight: 64,
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          style: TextStyle(
            fontFamily: 'Fredoka',
            color: Theme.of(context).primaryColor,
            fontSize: 32
          ),
          text: 'Tutter ',
          children: [
            TextSpan(
              text: 'radio',
              style: TextStyle(
                  color: Theme.of(context).textTheme.titleMedium?.color
              )
            )
          ]
        )
      ),
    );
  }

  Widget buildVolumeSlider(BuildContext context) {
    return SubjectBuilder(
      subject: (viewModel) => viewModel.volume,
      builder: (
          BuildContext context,
          AsyncSnapshot<double> volumeSnapshot
          ) {
        final volume = volumeSnapshot.data ?? defaultVolume;
        return Slider(
          value: volume,
          onChanged: (volume) => ViewModel.of(context).setVolume(volume),
          divisions: 10,
        );
      },
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const SizedBox(height: 4),
          ListTile(
            title: Text('Volume',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          buildVolumeSlider(context),
          const Divider(),
          ListTile(
            title: Text('Settings',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          SubjectBuilder(
            subject: (viewModel) => viewModel.showPotterName,
            builder: (
              BuildContext context,
              AsyncSnapshot<bool?> showPotter
            ) {
              return CheckboxListTile(
                title: const Text('Show Potter name'),
                value: showPotter.data ?? true,
                onChanged: (value) {
                  ViewModel.of(context).setShowPotter(value ?? true);
                },
                visualDensity: VisualDensity.compact,
              );
            }
          ),
          const Divider(),
          ListTile(
            title: Text('Active playlists',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          SubjectBuilder(
            subject: (viewModel) => viewModel.playlists,
            builder: (
                BuildContext context,
                AsyncSnapshot<List<SelectedPlaylist>?> playlistSnapshot,
                ) {
              final playlists = playlistSnapshot.data ?? [];

              final songCount = playlists.fold<int>(0, (count, playlist) => count + (playlist.selected ? playlist.length : 0));
              return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    for (final playlist in playlists)
                      CheckboxListTile(
                        title: Text(playlist.name),
                        subtitle: Text('${playlist.length} songs',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        value: playlist.selected,
                        onChanged: (_) {
                          ViewModel.of(context).toggleSelectPlaylist(playlist);
                        },
                        visualDensity: VisualDensity.compact,
                      ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.queue_music,
                            color: Theme.of(context).textTheme.caption?.color,
                          ),
                          const SizedBox(width: 4),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 100),
                            child: Text(songCount.toString(),
                              key: ValueKey(songCount),
                              style: Theme.of(context).textTheme.caption,
                            ),
                            layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
                              return Stack(
                                alignment: Alignment.bottomLeft,
                                children: <Widget>[
                                  ...previousChildren,
                                  if (currentChild != null) currentChild,
                                ],
                              );
                            },
                          )
                        ],
                      ),
                    )
                  ]
              );
            },
          ),
          const Divider(),
          buildFooter(context),
          const Divider(),
          buildPoweredBy(context),
        ],
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SubjectBuilder(
            subject: (viewModel) => viewModel.connectionState,
            builder: (
                BuildContext context,
                AsyncSnapshot<ClientConnectionState> state
                ) {
              late final Widget child;

              switch (state.requireData) {

                case ClientConnectionState.disconnected:
                  child = buildBodyDisconnected(context);
                  break;

                case ClientConnectionState.connecting:
                  child = buildBodyConnecting(context);
                  break;

                case ClientConnectionState.ready:
                  child = buildBodyReady(context);
                  break;
              }
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                child: KeyedSubtree(
                  key: ValueKey(state.requireData),
                  child: child,
                ),
              );
            }
        ),
      ),
    );
  }

  Widget buildBodyConnecting(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildBodyReady(BuildContext context) {
    return buildPlayInfo(context);
  }

  Widget buildPlayInfo(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: LayoutBuilder(
              builder: (
                BuildContext context,
                BoxConstraints constraints
              ) {
                const padding = 32.0;
                final size = min(min(constraints.maxWidth, constraints.maxHeight - padding), 320.0);

                if (size < 160.0) {
                  return const SizedBox();
                } else {
                  return Padding(
                      padding: const EdgeInsets.only(bottom: padding),
                      child: Card(
                        color: Colors.transparent,
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: CoverArt(
                          width: size,
                          height: size,
                          fit: BoxFit.cover,
                        ),
                      )
                  );
                }
              },
            ),
          ),
          DefaultMetadataBuilder(
            builder: (
              BuildContext context,
              DefaultMetadata? metadata,
            ) {
              return buildTitle(metadata);
            }
          ),
          const SizedBox(height: 16),
          IconButton(
            icon: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: playPauseAnimation,
            ),
            color: Theme.of(context).primaryColor,
            onPressed: () => ViewModel.of(context).togglePause(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.people,
                color: Theme.of(context).textTheme.caption?.color,
              ),
              const SizedBox(width: 8),
              SubjectBuilder(
                subject: (viewModel) => viewModel.listenerCount,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<int?> listeners
                ) {
                  late final String text;
                  if (listeners.data != null) {
                    text = listeners.data!.toString();
                  } else {
                    text = '?';
                  }
                  return Text(text,
                    style: Theme.of(context).textTheme.caption,
                  );
                }
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTitle(DefaultMetadata? metadata) {
    if (metadata != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
                text: metadata.artist,
                style: Theme.of(context).textTheme.headline6?.copyWith(fontFamily: 'Fredoka'),
                children: [
                  TextSpan(
                      text: ' - ',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.caption?.color
                      )
                  ),
                  TextSpan(
                    text: metadata.title
                  )
                ]
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
              height: 12
          ),
          SubjectBuilder(
            subject: (viewModel) => viewModel.showPotterName,
            builder: (
              BuildContext context,
              AsyncSnapshot<bool?> showPotter
            ) {
              return RichText(
                text: TextSpan(
                  text: metadata.album,
                  style: Theme.of(context).textTheme.caption,
                  children: [
                    if (showPotter.data ?? true)
                      TextSpan(
                        text: ' - ${metadata.potter}'
                      )
                  ]
                )
              );
            }
          )
        ],
      );
    } else {
      return Text('No tracks selected',
        style: Theme.of(context).textTheme.headline6?.copyWith(fontFamily: 'Fredoka'),
      );
    }
  }

  Widget buildBodyDisconnected(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SubjectBuilder(
            subject: (viewModel) => viewModel.error,
            builder: (
              BuildContext context,
              AsyncSnapshot<Object?> error
            ) {
              return ExceptionViewer(error.data);
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: () => ViewModel.of(context).connect(), child: Text('Retry')),
        ],
      ),
    );
  }

  Widget buildBodyConnectionLost(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(onPressed: () => ViewModel.of(context).connect(), child: Text('Retry')),
        ],
      ),
    );
  }

  Widget buildFooter(BuildContext context) {
    return ListTile(
      title: Text('© 2022 Job Feikens',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: buildFooterPicture(
        assetName: 'assets/github.svg',
        link: 'https://github.com/jobfeikens/tutter-music',
        tooltip: 'View project on Github',
        color: Theme.of(context).textTheme.caption?.color
      ),
    );
  }

  Widget buildPoweredBy(BuildContext context) {
    return ListTile(
      title: Text('Powered by:',
        style: Theme.of(context).textTheme.caption,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildFooterPicture(
            assetName: 'assets/ferris.svg',
            link: 'https://www.rust-lang.org/',
            tooltip: 'Rust programming language',
          ),
          buildFooterPicture(
            assetName: 'assets/flutter.svg',
            link: 'https://flutter.dev/',
            tooltip: 'Flutter app framework',
          ),
          buildFooterPicture(
            assetName: 'assets/opus.svg',
            link: 'https://opus-codec.org/',
            tooltip: 'Opus audio codec',
            color: Theme.of(context).textTheme.caption?.color
          )
        ],
      ),
    );
  }
  
  Widget buildFooterPicture({required String assetName, required String link, String? tooltip, Color? color}) {
    return IconButton(
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      onPressed: () => UrlLauncherPlugin().launch(link),
      icon: WebsafeSvg.asset(assetName,
        height: 20,
        width: 20,
        fit: BoxFit.fitHeight,
        color: color,
      ),
      visualDensity: VisualDensity.comfortable,
    );
  }
}
