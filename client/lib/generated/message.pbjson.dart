///
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use serverBoundDescriptor instead')
const ServerBound$json = const {
  '1': 'ServerBound',
  '2': const [
    const {'1': 'play_pause', '3': 1, '4': 1, '5': 11, '6': '.PlayPause', '9': 0, '10': 'playPause'},
    const {'1': 'select_playlist', '3': 2, '4': 1, '5': 11, '6': '.SelectPlaylist', '9': 0, '10': 'selectPlaylist'},
    const {'1': 'show_potter_name', '3': 3, '4': 1, '5': 11, '6': '.ShowPotterName', '9': 0, '10': 'showPotterName'},
    const {'1': 'report_song', '3': 4, '4': 1, '5': 11, '6': '.ReportSong', '9': 0, '10': 'reportSong'},
  ],
  '8': const [
    const {'1': 'type'},
  ],
};

/// Descriptor for `ServerBound`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverBoundDescriptor = $convert.base64Decode('CgtTZXJ2ZXJCb3VuZBIrCgpwbGF5X3BhdXNlGAEgASgLMgouUGxheVBhdXNlSABSCXBsYXlQYXVzZRI6Cg9zZWxlY3RfcGxheWxpc3QYAiABKAsyDy5TZWxlY3RQbGF5bGlzdEgAUg5zZWxlY3RQbGF5bGlzdBI7ChBzaG93X3BvdHRlcl9uYW1lGAMgASgLMg8uU2hvd1BvdHRlck5hbWVIAFIOc2hvd1BvdHRlck5hbWUSLgoLcmVwb3J0X3NvbmcYBCABKAsyCy5SZXBvcnRTb25nSABSCnJlcG9ydFNvbmdCBgoEdHlwZQ==');
@$core.Deprecated('Use clientBoundDescriptor instead')
const ClientBound$json = const {
  '1': 'ClientBound',
  '2': const [
    const {'1': 'heart_beat', '3': 1, '4': 1, '5': 11, '6': '.HeartBeat', '9': 0, '10': 'heartBeat'},
    const {'1': 'play_pause', '3': 2, '4': 1, '5': 11, '6': '.PlayPause', '9': 0, '10': 'playPause'},
    const {'1': 'listeners', '3': 3, '4': 1, '5': 11, '6': '.Listeners', '9': 0, '10': 'listeners'},
    const {'1': 'clear_playlists', '3': 4, '4': 1, '5': 11, '6': '.ClearPlaylists', '9': 0, '10': 'clearPlaylists'},
    const {'1': 'add_playlist', '3': 5, '4': 1, '5': 11, '6': '.AddPlaylist', '9': 0, '10': 'addPlaylist'},
    const {'1': 'select_playlist', '3': 6, '4': 1, '5': 11, '6': '.SelectPlaylist', '9': 0, '10': 'selectPlaylist'},
    const {'1': 'ready', '3': 7, '4': 1, '5': 11, '6': '.Ready', '9': 0, '10': 'ready'},
    const {'1': 'comment', '3': 8, '4': 1, '5': 11, '6': '.Comment', '9': 0, '10': 'comment'},
    const {'1': 'data', '3': 9, '4': 1, '5': 11, '6': '.OpusData', '9': 0, '10': 'data'},
    const {'1': 'show_potter_name', '3': 10, '4': 1, '5': 11, '6': '.ShowPotterName', '9': 0, '10': 'showPotterName'},
  ],
  '8': const [
    const {'1': 'type'},
  ],
};

/// Descriptor for `ClientBound`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clientBoundDescriptor = $convert.base64Decode('CgtDbGllbnRCb3VuZBIrCgpoZWFydF9iZWF0GAEgASgLMgouSGVhcnRCZWF0SABSCWhlYXJ0QmVhdBIrCgpwbGF5X3BhdXNlGAIgASgLMgouUGxheVBhdXNlSABSCXBsYXlQYXVzZRIqCglsaXN0ZW5lcnMYAyABKAsyCi5MaXN0ZW5lcnNIAFIJbGlzdGVuZXJzEjoKD2NsZWFyX3BsYXlsaXN0cxgEIAEoCzIPLkNsZWFyUGxheWxpc3RzSABSDmNsZWFyUGxheWxpc3RzEjEKDGFkZF9wbGF5bGlzdBgFIAEoCzIMLkFkZFBsYXlsaXN0SABSC2FkZFBsYXlsaXN0EjoKD3NlbGVjdF9wbGF5bGlzdBgGIAEoCzIPLlNlbGVjdFBsYXlsaXN0SABSDnNlbGVjdFBsYXlsaXN0Eh4KBXJlYWR5GAcgASgLMgYuUmVhZHlIAFIFcmVhZHkSJAoHY29tbWVudBgIIAEoCzIILkNvbW1lbnRIAFIHY29tbWVudBIfCgRkYXRhGAkgASgLMgkuT3B1c0RhdGFIAFIEZGF0YRI7ChBzaG93X3BvdHRlcl9uYW1lGAogASgLMg8uU2hvd1BvdHRlck5hbWVIAFIOc2hvd1BvdHRlck5hbWVCBgoEdHlwZQ==');
@$core.Deprecated('Use heartBeatDescriptor instead')
const HeartBeat$json = const {
  '1': 'HeartBeat',
};

/// Descriptor for `HeartBeat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List heartBeatDescriptor = $convert.base64Decode('CglIZWFydEJlYXQ=');
@$core.Deprecated('Use playPauseDescriptor instead')
const PlayPause$json = const {
  '1': 'PlayPause',
  '2': const [
    const {'1': 'is_paused', '3': 1, '4': 1, '5': 8, '10': 'isPaused'},
  ],
};

/// Descriptor for `PlayPause`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List playPauseDescriptor = $convert.base64Decode('CglQbGF5UGF1c2USGwoJaXNfcGF1c2VkGAEgASgIUghpc1BhdXNlZA==');
@$core.Deprecated('Use listenersDescriptor instead')
const Listeners$json = const {
  '1': 'Listeners',
  '2': const [
    const {'1': 'count', '3': 1, '4': 1, '5': 4, '10': 'count'},
  ],
};

/// Descriptor for `Listeners`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listenersDescriptor = $convert.base64Decode('CglMaXN0ZW5lcnMSFAoFY291bnQYASABKARSBWNvdW50');
@$core.Deprecated('Use readyDescriptor instead')
const Ready$json = const {
  '1': 'Ready',
};

/// Descriptor for `Ready`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readyDescriptor = $convert.base64Decode('CgVSZWFkeQ==');
@$core.Deprecated('Use clearPlaylistsDescriptor instead')
const ClearPlaylists$json = const {
  '1': 'ClearPlaylists',
};

/// Descriptor for `ClearPlaylists`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List clearPlaylistsDescriptor = $convert.base64Decode('Cg5DbGVhclBsYXlsaXN0cw==');
@$core.Deprecated('Use addPlaylistDescriptor instead')
const AddPlaylist$json = const {
  '1': 'AddPlaylist',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'length', '3': 2, '4': 1, '5': 4, '10': 'length'},
  ],
};

/// Descriptor for `AddPlaylist`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addPlaylistDescriptor = $convert.base64Decode('CgtBZGRQbGF5bGlzdBISCgRuYW1lGAEgASgJUgRuYW1lEhYKBmxlbmd0aBgCIAEoBFIGbGVuZ3Ro');
@$core.Deprecated('Use selectPlaylistDescriptor instead')
const SelectPlaylist$json = const {
  '1': 'SelectPlaylist',
  '2': const [
    const {'1': 'index', '3': 1, '4': 1, '5': 4, '10': 'index'},
    const {'1': 'selected', '3': 2, '4': 1, '5': 8, '10': 'selected'},
  ],
};

/// Descriptor for `SelectPlaylist`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selectPlaylistDescriptor = $convert.base64Decode('Cg5TZWxlY3RQbGF5bGlzdBIUCgVpbmRleBgBIAEoBFIFaW5kZXgSGgoIc2VsZWN0ZWQYAiABKAhSCHNlbGVjdGVk');
@$core.Deprecated('Use commentDescriptor instead')
const Comment$json = const {
  '1': 'Comment',
  '2': const [
    const {'1': 'noComment', '3': 1, '4': 1, '5': 8, '10': 'noComment'},
    const {'1': 'entries', '3': 2, '4': 3, '5': 11, '6': '.CommentEntry', '10': 'entries'},
    const {'1': 'song_id', '3': 3, '4': 1, '5': 9, '10': 'songId'},
  ],
};

/// Descriptor for `Comment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commentDescriptor = $convert.base64Decode('CgdDb21tZW50EhwKCW5vQ29tbWVudBgBIAEoCFIJbm9Db21tZW50EicKB2VudHJpZXMYAiADKAsyDS5Db21tZW50RW50cnlSB2VudHJpZXMSFwoHc29uZ19pZBgDIAEoCVIGc29uZ0lk');
@$core.Deprecated('Use commentEntryDescriptor instead')
const CommentEntry$json = const {
  '1': 'CommentEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
};

/// Descriptor for `CommentEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commentEntryDescriptor = $convert.base64Decode('CgxDb21tZW50RW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVl');
@$core.Deprecated('Use opusDataDescriptor instead')
const OpusData$json = const {
  '1': 'OpusData',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'duration', '3': 2, '4': 1, '5': 13, '10': 'duration'},
    const {'1': 'song_id', '3': 3, '4': 1, '5': 9, '10': 'songId'},
  ],
};

/// Descriptor for `OpusData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opusDataDescriptor = $convert.base64Decode('CghPcHVzRGF0YRISCgRkYXRhGAEgASgMUgRkYXRhEhoKCGR1cmF0aW9uGAIgASgNUghkdXJhdGlvbhIXCgdzb25nX2lkGAMgASgJUgZzb25nSWQ=');
@$core.Deprecated('Use opusFrameDescriptor instead')
const OpusFrame$json = const {
  '1': 'OpusFrame',
  '2': const [
    const {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
  ],
};

/// Descriptor for `OpusFrame`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List opusFrameDescriptor = $convert.base64Decode('CglPcHVzRnJhbWUSEgoEZGF0YRgBIAEoDFIEZGF0YQ==');
@$core.Deprecated('Use showPotterNameDescriptor instead')
const ShowPotterName$json = const {
  '1': 'ShowPotterName',
  '2': const [
    const {'1': 'show', '3': 1, '4': 1, '5': 8, '10': 'show'},
  ],
};

/// Descriptor for `ShowPotterName`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List showPotterNameDescriptor = $convert.base64Decode('Cg5TaG93UG90dGVyTmFtZRISCgRzaG93GAEgASgIUgRzaG93');
@$core.Deprecated('Use reportSongDescriptor instead')
const ReportSong$json = const {
  '1': 'ReportSong',
  '2': const [
    const {'1': 'artist', '3': 1, '4': 1, '5': 9, '10': 'artist'},
    const {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'explanation', '3': 3, '4': 1, '5': 9, '10': 'explanation'},
  ],
};

/// Descriptor for `ReportSong`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportSongDescriptor = $convert.base64Decode('CgpSZXBvcnRTb25nEhYKBmFydGlzdBgBIAEoCVIGYXJ0aXN0EhQKBXRpdGxlGAIgASgJUgV0aXRsZRIgCgtleHBsYW5hdGlvbhgDIAEoCVILZXhwbGFuYXRpb24=');
