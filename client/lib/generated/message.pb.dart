///
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

enum ServerBound_Type {
  playPause, 
  selectPlaylist, 
  showPotterName, 
  reportSong, 
  notSet
}

class ServerBound extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, ServerBound_Type> _ServerBound_TypeByTag = {
    1 : ServerBound_Type.playPause,
    2 : ServerBound_Type.selectPlaylist,
    3 : ServerBound_Type.showPotterName,
    4 : ServerBound_Type.reportSong,
    0 : ServerBound_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ServerBound', createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<PlayPause>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playPause', subBuilder: PlayPause.create)
    ..aOM<SelectPlaylist>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'selectPlaylist', subBuilder: SelectPlaylist.create)
    ..aOM<ShowPotterName>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'showPotterName', subBuilder: ShowPotterName.create)
    ..aOM<ReportSong>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'reportSong', subBuilder: ReportSong.create)
    ..hasRequiredFields = false
  ;

  ServerBound._() : super();
  factory ServerBound({
    PlayPause? playPause,
    SelectPlaylist? selectPlaylist,
    ShowPotterName? showPotterName,
    ReportSong? reportSong,
  }) {
    final _result = create();
    if (playPause != null) {
      _result.playPause = playPause;
    }
    if (selectPlaylist != null) {
      _result.selectPlaylist = selectPlaylist;
    }
    if (showPotterName != null) {
      _result.showPotterName = showPotterName;
    }
    if (reportSong != null) {
      _result.reportSong = reportSong;
    }
    return _result;
  }
  factory ServerBound.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServerBound.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServerBound clone() => ServerBound()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServerBound copyWith(void Function(ServerBound) updates) => super.copyWith((message) => updates(message as ServerBound)) as ServerBound; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ServerBound create() => ServerBound._();
  ServerBound createEmptyInstance() => create();
  static $pb.PbList<ServerBound> createRepeated() => $pb.PbList<ServerBound>();
  @$core.pragma('dart2js:noInline')
  static ServerBound getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerBound>(create);
  static ServerBound? _defaultInstance;

  ServerBound_Type whichType() => _ServerBound_TypeByTag[$_whichOneof(0)]!;
  void clearType() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  PlayPause get playPause => $_getN(0);
  @$pb.TagNumber(1)
  set playPause(PlayPause v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlayPause() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlayPause() => clearField(1);
  @$pb.TagNumber(1)
  PlayPause ensurePlayPause() => $_ensure(0);

  @$pb.TagNumber(2)
  SelectPlaylist get selectPlaylist => $_getN(1);
  @$pb.TagNumber(2)
  set selectPlaylist(SelectPlaylist v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSelectPlaylist() => $_has(1);
  @$pb.TagNumber(2)
  void clearSelectPlaylist() => clearField(2);
  @$pb.TagNumber(2)
  SelectPlaylist ensureSelectPlaylist() => $_ensure(1);

  @$pb.TagNumber(3)
  ShowPotterName get showPotterName => $_getN(2);
  @$pb.TagNumber(3)
  set showPotterName(ShowPotterName v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasShowPotterName() => $_has(2);
  @$pb.TagNumber(3)
  void clearShowPotterName() => clearField(3);
  @$pb.TagNumber(3)
  ShowPotterName ensureShowPotterName() => $_ensure(2);

  @$pb.TagNumber(4)
  ReportSong get reportSong => $_getN(3);
  @$pb.TagNumber(4)
  set reportSong(ReportSong v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasReportSong() => $_has(3);
  @$pb.TagNumber(4)
  void clearReportSong() => clearField(4);
  @$pb.TagNumber(4)
  ReportSong ensureReportSong() => $_ensure(3);
}

enum ClientBound_Type {
  heartBeat, 
  playPause, 
  listeners, 
  clearPlaylists, 
  addPlaylist, 
  selectPlaylist, 
  ready, 
  comment, 
  data, 
  showPotterName, 
  notSet
}

class ClientBound extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, ClientBound_Type> _ClientBound_TypeByTag = {
    1 : ClientBound_Type.heartBeat,
    2 : ClientBound_Type.playPause,
    3 : ClientBound_Type.listeners,
    4 : ClientBound_Type.clearPlaylists,
    5 : ClientBound_Type.addPlaylist,
    6 : ClientBound_Type.selectPlaylist,
    7 : ClientBound_Type.ready,
    8 : ClientBound_Type.comment,
    9 : ClientBound_Type.data,
    10 : ClientBound_Type.showPotterName,
    0 : ClientBound_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ClientBound', createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
    ..aOM<HeartBeat>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'heartBeat', subBuilder: HeartBeat.create)
    ..aOM<PlayPause>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playPause', subBuilder: PlayPause.create)
    ..aOM<Listeners>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'listeners', subBuilder: Listeners.create)
    ..aOM<ClearPlaylists>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'clearPlaylists', subBuilder: ClearPlaylists.create)
    ..aOM<AddPlaylist>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'addPlaylist', subBuilder: AddPlaylist.create)
    ..aOM<SelectPlaylist>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'selectPlaylist', subBuilder: SelectPlaylist.create)
    ..aOM<Ready>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ready', subBuilder: Ready.create)
    ..aOM<Comment>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'comment', subBuilder: Comment.create)
    ..aOM<OpusData>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', subBuilder: OpusData.create)
    ..aOM<ShowPotterName>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'showPotterName', subBuilder: ShowPotterName.create)
    ..hasRequiredFields = false
  ;

  ClientBound._() : super();
  factory ClientBound({
    HeartBeat? heartBeat,
    PlayPause? playPause,
    Listeners? listeners,
    ClearPlaylists? clearPlaylists,
    AddPlaylist? addPlaylist,
    SelectPlaylist? selectPlaylist,
    Ready? ready,
    Comment? comment,
    OpusData? data,
    ShowPotterName? showPotterName,
  }) {
    final _result = create();
    if (heartBeat != null) {
      _result.heartBeat = heartBeat;
    }
    if (playPause != null) {
      _result.playPause = playPause;
    }
    if (listeners != null) {
      _result.listeners = listeners;
    }
    if (clearPlaylists != null) {
      _result.clearPlaylists = clearPlaylists;
    }
    if (addPlaylist != null) {
      _result.addPlaylist = addPlaylist;
    }
    if (selectPlaylist != null) {
      _result.selectPlaylist = selectPlaylist;
    }
    if (ready != null) {
      _result.ready = ready;
    }
    if (comment != null) {
      _result.comment = comment;
    }
    if (data != null) {
      _result.data = data;
    }
    if (showPotterName != null) {
      _result.showPotterName = showPotterName;
    }
    return _result;
  }
  factory ClientBound.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ClientBound.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ClientBound clone() => ClientBound()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ClientBound copyWith(void Function(ClientBound) updates) => super.copyWith((message) => updates(message as ClientBound)) as ClientBound; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ClientBound create() => ClientBound._();
  ClientBound createEmptyInstance() => create();
  static $pb.PbList<ClientBound> createRepeated() => $pb.PbList<ClientBound>();
  @$core.pragma('dart2js:noInline')
  static ClientBound getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClientBound>(create);
  static ClientBound? _defaultInstance;

  ClientBound_Type whichType() => _ClientBound_TypeByTag[$_whichOneof(0)]!;
  void clearType() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  HeartBeat get heartBeat => $_getN(0);
  @$pb.TagNumber(1)
  set heartBeat(HeartBeat v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasHeartBeat() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeartBeat() => clearField(1);
  @$pb.TagNumber(1)
  HeartBeat ensureHeartBeat() => $_ensure(0);

  @$pb.TagNumber(2)
  PlayPause get playPause => $_getN(1);
  @$pb.TagNumber(2)
  set playPause(PlayPause v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPlayPause() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlayPause() => clearField(2);
  @$pb.TagNumber(2)
  PlayPause ensurePlayPause() => $_ensure(1);

  @$pb.TagNumber(3)
  Listeners get listeners => $_getN(2);
  @$pb.TagNumber(3)
  set listeners(Listeners v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasListeners() => $_has(2);
  @$pb.TagNumber(3)
  void clearListeners() => clearField(3);
  @$pb.TagNumber(3)
  Listeners ensureListeners() => $_ensure(2);

  @$pb.TagNumber(4)
  ClearPlaylists get clearPlaylists => $_getN(3);
  @$pb.TagNumber(4)
  set clearPlaylists(ClearPlaylists v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasClearPlaylists() => $_has(3);
  @$pb.TagNumber(4)
  void clearClearPlaylists() => clearField(4);
  @$pb.TagNumber(4)
  ClearPlaylists ensureClearPlaylists() => $_ensure(3);

  @$pb.TagNumber(5)
  AddPlaylist get addPlaylist => $_getN(4);
  @$pb.TagNumber(5)
  set addPlaylist(AddPlaylist v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasAddPlaylist() => $_has(4);
  @$pb.TagNumber(5)
  void clearAddPlaylist() => clearField(5);
  @$pb.TagNumber(5)
  AddPlaylist ensureAddPlaylist() => $_ensure(4);

  @$pb.TagNumber(6)
  SelectPlaylist get selectPlaylist => $_getN(5);
  @$pb.TagNumber(6)
  set selectPlaylist(SelectPlaylist v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasSelectPlaylist() => $_has(5);
  @$pb.TagNumber(6)
  void clearSelectPlaylist() => clearField(6);
  @$pb.TagNumber(6)
  SelectPlaylist ensureSelectPlaylist() => $_ensure(5);

  @$pb.TagNumber(7)
  Ready get ready => $_getN(6);
  @$pb.TagNumber(7)
  set ready(Ready v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasReady() => $_has(6);
  @$pb.TagNumber(7)
  void clearReady() => clearField(7);
  @$pb.TagNumber(7)
  Ready ensureReady() => $_ensure(6);

  @$pb.TagNumber(8)
  Comment get comment => $_getN(7);
  @$pb.TagNumber(8)
  set comment(Comment v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasComment() => $_has(7);
  @$pb.TagNumber(8)
  void clearComment() => clearField(8);
  @$pb.TagNumber(8)
  Comment ensureComment() => $_ensure(7);

  @$pb.TagNumber(9)
  OpusData get data => $_getN(8);
  @$pb.TagNumber(9)
  set data(OpusData v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasData() => $_has(8);
  @$pb.TagNumber(9)
  void clearData() => clearField(9);
  @$pb.TagNumber(9)
  OpusData ensureData() => $_ensure(8);

  @$pb.TagNumber(10)
  ShowPotterName get showPotterName => $_getN(9);
  @$pb.TagNumber(10)
  set showPotterName(ShowPotterName v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasShowPotterName() => $_has(9);
  @$pb.TagNumber(10)
  void clearShowPotterName() => clearField(10);
  @$pb.TagNumber(10)
  ShowPotterName ensureShowPotterName() => $_ensure(9);
}

class HeartBeat extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'HeartBeat', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  HeartBeat._() : super();
  factory HeartBeat() => create();
  factory HeartBeat.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HeartBeat.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HeartBeat clone() => HeartBeat()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HeartBeat copyWith(void Function(HeartBeat) updates) => super.copyWith((message) => updates(message as HeartBeat)) as HeartBeat; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HeartBeat create() => HeartBeat._();
  HeartBeat createEmptyInstance() => create();
  static $pb.PbList<HeartBeat> createRepeated() => $pb.PbList<HeartBeat>();
  @$core.pragma('dart2js:noInline')
  static HeartBeat getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HeartBeat>(create);
  static HeartBeat? _defaultInstance;
}

class PlayPause extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PlayPause', createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isPaused')
    ..hasRequiredFields = false
  ;

  PlayPause._() : super();
  factory PlayPause({
    $core.bool? isPaused,
  }) {
    final _result = create();
    if (isPaused != null) {
      _result.isPaused = isPaused;
    }
    return _result;
  }
  factory PlayPause.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlayPause.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlayPause clone() => PlayPause()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlayPause copyWith(void Function(PlayPause) updates) => super.copyWith((message) => updates(message as PlayPause)) as PlayPause; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PlayPause create() => PlayPause._();
  PlayPause createEmptyInstance() => create();
  static $pb.PbList<PlayPause> createRepeated() => $pb.PbList<PlayPause>();
  @$core.pragma('dart2js:noInline')
  static PlayPause getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlayPause>(create);
  static PlayPause? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isPaused => $_getBF(0);
  @$pb.TagNumber(1)
  set isPaused($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIsPaused() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsPaused() => clearField(1);
}

class Listeners extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Listeners', createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'count', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  Listeners._() : super();
  factory Listeners({
    $fixnum.Int64? count,
  }) {
    final _result = create();
    if (count != null) {
      _result.count = count;
    }
    return _result;
  }
  factory Listeners.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Listeners.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Listeners clone() => Listeners()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Listeners copyWith(void Function(Listeners) updates) => super.copyWith((message) => updates(message as Listeners)) as Listeners; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Listeners create() => Listeners._();
  Listeners createEmptyInstance() => create();
  static $pb.PbList<Listeners> createRepeated() => $pb.PbList<Listeners>();
  @$core.pragma('dart2js:noInline')
  static Listeners getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Listeners>(create);
  static Listeners? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get count => $_getI64(0);
  @$pb.TagNumber(1)
  set count($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearCount() => clearField(1);
}

class Ready extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Ready', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  Ready._() : super();
  factory Ready() => create();
  factory Ready.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Ready.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Ready clone() => Ready()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Ready copyWith(void Function(Ready) updates) => super.copyWith((message) => updates(message as Ready)) as Ready; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Ready create() => Ready._();
  Ready createEmptyInstance() => create();
  static $pb.PbList<Ready> createRepeated() => $pb.PbList<Ready>();
  @$core.pragma('dart2js:noInline')
  static Ready getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Ready>(create);
  static Ready? _defaultInstance;
}

class ClearPlaylists extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ClearPlaylists', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  ClearPlaylists._() : super();
  factory ClearPlaylists() => create();
  factory ClearPlaylists.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ClearPlaylists.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ClearPlaylists clone() => ClearPlaylists()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ClearPlaylists copyWith(void Function(ClearPlaylists) updates) => super.copyWith((message) => updates(message as ClearPlaylists)) as ClearPlaylists; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ClearPlaylists create() => ClearPlaylists._();
  ClearPlaylists createEmptyInstance() => create();
  static $pb.PbList<ClearPlaylists> createRepeated() => $pb.PbList<ClearPlaylists>();
  @$core.pragma('dart2js:noInline')
  static ClearPlaylists getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClearPlaylists>(create);
  static ClearPlaylists? _defaultInstance;
}

class AddPlaylist extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AddPlaylist', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..a<$fixnum.Int64>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'length', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  AddPlaylist._() : super();
  factory AddPlaylist({
    $core.String? name,
    $fixnum.Int64? length,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (length != null) {
      _result.length = length;
    }
    return _result;
  }
  factory AddPlaylist.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddPlaylist.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddPlaylist clone() => AddPlaylist()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddPlaylist copyWith(void Function(AddPlaylist) updates) => super.copyWith((message) => updates(message as AddPlaylist)) as AddPlaylist; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddPlaylist create() => AddPlaylist._();
  AddPlaylist createEmptyInstance() => create();
  static $pb.PbList<AddPlaylist> createRepeated() => $pb.PbList<AddPlaylist>();
  @$core.pragma('dart2js:noInline')
  static AddPlaylist getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddPlaylist>(create);
  static AddPlaylist? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get length => $_getI64(1);
  @$pb.TagNumber(2)
  set length($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLength() => $_has(1);
  @$pb.TagNumber(2)
  void clearLength() => clearField(2);
}

class SelectPlaylist extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SelectPlaylist', createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'index', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'selected')
    ..hasRequiredFields = false
  ;

  SelectPlaylist._() : super();
  factory SelectPlaylist({
    $fixnum.Int64? index,
    $core.bool? selected,
  }) {
    final _result = create();
    if (index != null) {
      _result.index = index;
    }
    if (selected != null) {
      _result.selected = selected;
    }
    return _result;
  }
  factory SelectPlaylist.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SelectPlaylist.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SelectPlaylist clone() => SelectPlaylist()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SelectPlaylist copyWith(void Function(SelectPlaylist) updates) => super.copyWith((message) => updates(message as SelectPlaylist)) as SelectPlaylist; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SelectPlaylist create() => SelectPlaylist._();
  SelectPlaylist createEmptyInstance() => create();
  static $pb.PbList<SelectPlaylist> createRepeated() => $pb.PbList<SelectPlaylist>();
  @$core.pragma('dart2js:noInline')
  static SelectPlaylist getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SelectPlaylist>(create);
  static SelectPlaylist? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get index => $_getI64(0);
  @$pb.TagNumber(1)
  set index($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndex() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get selected => $_getBF(1);
  @$pb.TagNumber(2)
  set selected($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSelected() => $_has(1);
  @$pb.TagNumber(2)
  void clearSelected() => clearField(2);
}

class Comment extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Comment', createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'noComment', protoName: 'noComment')
    ..pc<CommentEntry>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'entries', $pb.PbFieldType.PM, subBuilder: CommentEntry.create)
    ..hasRequiredFields = false
  ;

  Comment._() : super();
  factory Comment({
    $core.bool? noComment,
    $core.Iterable<CommentEntry>? entries,
  }) {
    final _result = create();
    if (noComment != null) {
      _result.noComment = noComment;
    }
    if (entries != null) {
      _result.entries.addAll(entries);
    }
    return _result;
  }
  factory Comment.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Comment.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Comment clone() => Comment()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Comment copyWith(void Function(Comment) updates) => super.copyWith((message) => updates(message as Comment)) as Comment; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Comment create() => Comment._();
  Comment createEmptyInstance() => create();
  static $pb.PbList<Comment> createRepeated() => $pb.PbList<Comment>();
  @$core.pragma('dart2js:noInline')
  static Comment getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Comment>(create);
  static Comment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get noComment => $_getBF(0);
  @$pb.TagNumber(1)
  set noComment($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNoComment() => $_has(0);
  @$pb.TagNumber(1)
  void clearNoComment() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<CommentEntry> get entries => $_getList(1);
}

class CommentEntry extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CommentEntry', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'key')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'value')
    ..hasRequiredFields = false
  ;

  CommentEntry._() : super();
  factory CommentEntry({
    $core.String? key,
    $core.String? value,
  }) {
    final _result = create();
    if (key != null) {
      _result.key = key;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory CommentEntry.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CommentEntry.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CommentEntry clone() => CommentEntry()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CommentEntry copyWith(void Function(CommentEntry) updates) => super.copyWith((message) => updates(message as CommentEntry)) as CommentEntry; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CommentEntry create() => CommentEntry._();
  CommentEntry createEmptyInstance() => create();
  static $pb.PbList<CommentEntry> createRepeated() => $pb.PbList<CommentEntry>();
  @$core.pragma('dart2js:noInline')
  static CommentEntry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommentEntry>(create);
  static CommentEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);
}

class OpusData extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OpusData', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.OY)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'duration', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  OpusData._() : super();
  factory OpusData({
    $core.List<$core.int>? data,
    $core.int? duration,
  }) {
    final _result = create();
    if (data != null) {
      _result.data = data;
    }
    if (duration != null) {
      _result.duration = duration;
    }
    return _result;
  }
  factory OpusData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OpusData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OpusData clone() => OpusData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OpusData copyWith(void Function(OpusData) updates) => super.copyWith((message) => updates(message as OpusData)) as OpusData; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OpusData create() => OpusData._();
  OpusData createEmptyInstance() => create();
  static $pb.PbList<OpusData> createRepeated() => $pb.PbList<OpusData>();
  @$core.pragma('dart2js:noInline')
  static OpusData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpusData>(create);
  static OpusData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get duration => $_getIZ(1);
  @$pb.TagNumber(2)
  set duration($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDuration() => $_has(1);
  @$pb.TagNumber(2)
  void clearDuration() => clearField(2);
}

class OpusFrame extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'OpusFrame', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  OpusFrame._() : super();
  factory OpusFrame({
    $core.List<$core.int>? data,
  }) {
    final _result = create();
    if (data != null) {
      _result.data = data;
    }
    return _result;
  }
  factory OpusFrame.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OpusFrame.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OpusFrame clone() => OpusFrame()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OpusFrame copyWith(void Function(OpusFrame) updates) => super.copyWith((message) => updates(message as OpusFrame)) as OpusFrame; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OpusFrame create() => OpusFrame._();
  OpusFrame createEmptyInstance() => create();
  static $pb.PbList<OpusFrame> createRepeated() => $pb.PbList<OpusFrame>();
  @$core.pragma('dart2js:noInline')
  static OpusFrame getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OpusFrame>(create);
  static OpusFrame? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
}

class ShowPotterName extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ShowPotterName', createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'show')
    ..hasRequiredFields = false
  ;

  ShowPotterName._() : super();
  factory ShowPotterName({
    $core.bool? show,
  }) {
    final _result = create();
    if (show != null) {
      _result.show = show;
    }
    return _result;
  }
  factory ShowPotterName.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ShowPotterName.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ShowPotterName clone() => ShowPotterName()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ShowPotterName copyWith(void Function(ShowPotterName) updates) => super.copyWith((message) => updates(message as ShowPotterName)) as ShowPotterName; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ShowPotterName create() => ShowPotterName._();
  ShowPotterName createEmptyInstance() => create();
  static $pb.PbList<ShowPotterName> createRepeated() => $pb.PbList<ShowPotterName>();
  @$core.pragma('dart2js:noInline')
  static ShowPotterName getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ShowPotterName>(create);
  static ShowPotterName? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get show => $_getBF(0);
  @$pb.TagNumber(1)
  set show($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasShow() => $_has(0);
  @$pb.TagNumber(1)
  void clearShow() => clearField(1);
}

class ReportSong extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ReportSong', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'artist')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'title')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'explanation')
    ..hasRequiredFields = false
  ;

  ReportSong._() : super();
  factory ReportSong({
    $core.String? artist,
    $core.String? title,
    $core.String? explanation,
  }) {
    final _result = create();
    if (artist != null) {
      _result.artist = artist;
    }
    if (title != null) {
      _result.title = title;
    }
    if (explanation != null) {
      _result.explanation = explanation;
    }
    return _result;
  }
  factory ReportSong.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReportSong.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReportSong clone() => ReportSong()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReportSong copyWith(void Function(ReportSong) updates) => super.copyWith((message) => updates(message as ReportSong)) as ReportSong; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReportSong create() => ReportSong._();
  ReportSong createEmptyInstance() => create();
  static $pb.PbList<ReportSong> createRepeated() => $pb.PbList<ReportSong>();
  @$core.pragma('dart2js:noInline')
  static ReportSong getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReportSong>(create);
  static ReportSong? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get artist => $_getSZ(0);
  @$pb.TagNumber(1)
  set artist($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasArtist() => $_has(0);
  @$pb.TagNumber(1)
  void clearArtist() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get explanation => $_getSZ(2);
  @$pb.TagNumber(3)
  set explanation($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasExplanation() => $_has(2);
  @$pb.TagNumber(3)
  void clearExplanation() => clearField(3);
}

