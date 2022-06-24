import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:tutter_radio/view/cover_art_processor.dart';

import '../../common/player.dart';

class MetadataProvider extends InheritedWidget {
  final Metadata? metadata;

  const MetadataProvider(
      {Key? key, required this.metadata, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return oldWidget is! MetadataProvider || oldWidget.metadata != metadata;
  }

  static Metadata? get(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MetadataProvider>()!
        .metadata;
  }
}

class MetadataBuilder<T> extends StatelessWidget {
  final T? Function(Metadata) getter;
  final Widget Function(BuildContext, T?) builder;

  const MetadataBuilder({
    Key? key,
    required this.getter,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final metadata = MetadataProvider.get(context);
    T? value;
    if (metadata != null) {
      value = getter.call(metadata);
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: KeyedSubtree(
        key: ValueKey(metadata),
        child: builder.call(context, value),
      ),
    );
  }
}

class DefaultMetadataBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DefaultMetadata?) builder;

  const DefaultMetadataBuilder({Key? key, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MetadataBuilder(
      getter: (metadata) => DefaultMetadata(
          metadata.artist,
          metadata.title,
          metadata.album,
          metadata.potter,
      ),
      builder: builder,
    );
  }
}

class DefaultMetadata {
  final String artist;
  final String title;
  final String album;
  final String potter;

  const DefaultMetadata(this.artist, this.title, this.album, this.potter);
}

class CoverArt extends StatefulWidget {
  final double? width;
  final double? height;
  final BoxFit? fit;
  
  const CoverArt({Key? key, this.width, this.height, this.fit}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CoverArtState();
  }
}

class CoverArtState extends State<CoverArt> {
  final processor = CoverArtCache();
  
  @override
  Widget build(BuildContext context) {
    return MetadataBuilder(
      getter: (metadata) => CoverArtCache.getCoverArt(metadata),
      builder: (
        BuildContext context, 
        Uint8List? coverArt
      ) {
        final width = widget.width ?? double.maxFinite;
        final height = widget.height ?? double.maxFinite;
        final fit = widget.fit;

        if (coverArt != null) {
          return Image.memory(coverArt,
            width: width,
            height: height,
            fit: fit,
          );
        } else {
          return Image.asset('assets/tutterdj.jpg',
            width: width,
            height: height,
            fit: fit,
          );
        }
      }
    );
  }
}
