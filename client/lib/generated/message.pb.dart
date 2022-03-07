///
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

enum Message_Type {
  heartBeat, 
  paused, 
  resumed, 
  listeners, 
  notSet
}

class Message extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, Message_Type> _Message_TypeByTag = {
    1 : Message_Type.heartBeat,
    2 : Message_Type.paused,
    3 : Message_Type.resumed,
    4 : Message_Type.listeners,
    0 : Message_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Message', createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<HeartBeat>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'heartBeat', subBuilder: HeartBeat.create)
    ..aOM<Paused>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'paused', subBuilder: Paused.create)
    ..aOM<Resumed>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'resumed', subBuilder: Resumed.create)
    ..aOM<Listeners>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'listeners', subBuilder: Listeners.create)
    ..hasRequiredFields = false
  ;

  Message._() : super();
  factory Message({
    HeartBeat? heartBeat,
    Paused? paused,
    Resumed? resumed,
    Listeners? listeners,
  }) {
    final _result = create();
    if (heartBeat != null) {
      _result.heartBeat = heartBeat;
    }
    if (paused != null) {
      _result.paused = paused;
    }
    if (resumed != null) {
      _result.resumed = resumed;
    }
    if (listeners != null) {
      _result.listeners = listeners;
    }
    return _result;
  }
  factory Message.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Message.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Message clone() => Message()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Message copyWith(void Function(Message) updates) => super.copyWith((message) => updates(message as Message)) as Message; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Message create() => Message._();
  Message createEmptyInstance() => create();
  static $pb.PbList<Message> createRepeated() => $pb.PbList<Message>();
  @$core.pragma('dart2js:noInline')
  static Message getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Message>(create);
  static Message? _defaultInstance;

  Message_Type whichType() => _Message_TypeByTag[$_whichOneof(0)]!;
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
  Paused get paused => $_getN(1);
  @$pb.TagNumber(2)
  set paused(Paused v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPaused() => $_has(1);
  @$pb.TagNumber(2)
  void clearPaused() => clearField(2);
  @$pb.TagNumber(2)
  Paused ensurePaused() => $_ensure(1);

  @$pb.TagNumber(3)
  Resumed get resumed => $_getN(2);
  @$pb.TagNumber(3)
  set resumed(Resumed v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasResumed() => $_has(2);
  @$pb.TagNumber(3)
  void clearResumed() => clearField(3);
  @$pb.TagNumber(3)
  Resumed ensureResumed() => $_ensure(2);

  @$pb.TagNumber(4)
  Listeners get listeners => $_getN(3);
  @$pb.TagNumber(4)
  set listeners(Listeners v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasListeners() => $_has(3);
  @$pb.TagNumber(4)
  void clearListeners() => clearField(4);
  @$pb.TagNumber(4)
  Listeners ensureListeners() => $_ensure(3);
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

class Paused extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Paused', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  Paused._() : super();
  factory Paused() => create();
  factory Paused.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Paused.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Paused clone() => Paused()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Paused copyWith(void Function(Paused) updates) => super.copyWith((message) => updates(message as Paused)) as Paused; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Paused create() => Paused._();
  Paused createEmptyInstance() => create();
  static $pb.PbList<Paused> createRepeated() => $pb.PbList<Paused>();
  @$core.pragma('dart2js:noInline')
  static Paused getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Paused>(create);
  static Paused? _defaultInstance;
}

class Resumed extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Resumed', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  Resumed._() : super();
  factory Resumed() => create();
  factory Resumed.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Resumed.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Resumed clone() => Resumed()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Resumed copyWith(void Function(Resumed) updates) => super.copyWith((message) => updates(message as Resumed)) as Resumed; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Resumed create() => Resumed._();
  Resumed createEmptyInstance() => create();
  static $pb.PbList<Resumed> createRepeated() => $pb.PbList<Resumed>();
  @$core.pragma('dart2js:noInline')
  static Resumed getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Resumed>(create);
  static Resumed? _defaultInstance;
}

class Listeners extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Listeners', createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'listeners', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  Listeners._() : super();
  factory Listeners({
    $fixnum.Int64? listeners,
  }) {
    final _result = create();
    if (listeners != null) {
      _result.listeners = listeners;
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
  $fixnum.Int64 get listeners => $_getI64(0);
  @$pb.TagNumber(1)
  set listeners($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasListeners() => $_has(0);
  @$pb.TagNumber(1)
  void clearListeners() => clearField(1);
}

