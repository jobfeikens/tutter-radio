class Playlist {
  final String name;
  final int length;

  const Playlist(this.name, this.length);
}

class SelectedPlaylist {
  final Playlist _playlist;

  bool selected;

  SelectedPlaylist(this._playlist, this.selected);

  String get name => _playlist.name;
  int get length => _playlist.length;
}

class Metadata {
  final String songId;
  final Map<String, String> entries;

  Metadata(this.songId, Map<String, String> entries):
        entries = entries.map((key, value) => MapEntry(key.toLowerCase(), value));

  String get artist {
    return entries['artist'] ?? 'Unknown artist';
  }

  String get title {
    return entries['title'] ?? 'Unknown title';
  }

  String? get description {
    return entries['description'];
  }

  String get album {
    return entries['album'] ?? 'Unknown album';
  }

  // Encoded as base64
  String? get metadataBlockPicture {
    return entries['metadata_block_picture'];
  }

  String get potter {
    return entries['potter'] ?? 'Unknown Potter';
  }

  @override
  bool operator ==(Object other) {
    return other is Metadata && artist == other.artist && title == other.title;
  }

  @override
  // TODO: implement hashCode
  int get hashCode {
    return artist.hashCode ^ title.hashCode;
  }
}
