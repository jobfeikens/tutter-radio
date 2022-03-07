///
//  Generated code. Do not modify.
//  source: message.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use messageDescriptor instead')
const Message$json = const {
  '1': 'Message',
  '2': const [
    const {'1': 'heart_beat', '3': 1, '4': 1, '5': 11, '6': '.HeartBeat', '9': 0, '10': 'heartBeat'},
    const {'1': 'paused', '3': 2, '4': 1, '5': 11, '6': '.Paused', '9': 0, '10': 'paused'},
    const {'1': 'resumed', '3': 3, '4': 1, '5': 11, '6': '.Resumed', '9': 0, '10': 'resumed'},
    const {'1': 'listeners', '3': 4, '4': 1, '5': 11, '6': '.Listeners', '9': 0, '10': 'listeners'},
  ],
  '8': const [
    const {'1': 'type'},
  ],
};

/// Descriptor for `Message`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List messageDescriptor = $convert.base64Decode('CgdNZXNzYWdlEisKCmhlYXJ0X2JlYXQYASABKAsyCi5IZWFydEJlYXRIAFIJaGVhcnRCZWF0EiEKBnBhdXNlZBgCIAEoCzIHLlBhdXNlZEgAUgZwYXVzZWQSJAoHcmVzdW1lZBgDIAEoCzIILlJlc3VtZWRIAFIHcmVzdW1lZBIqCglsaXN0ZW5lcnMYBCABKAsyCi5MaXN0ZW5lcnNIAFIJbGlzdGVuZXJzQgYKBHR5cGU=');
@$core.Deprecated('Use heartBeatDescriptor instead')
const HeartBeat$json = const {
  '1': 'HeartBeat',
};

/// Descriptor for `HeartBeat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List heartBeatDescriptor = $convert.base64Decode('CglIZWFydEJlYXQ=');
@$core.Deprecated('Use pausedDescriptor instead')
const Paused$json = const {
  '1': 'Paused',
};

/// Descriptor for `Paused`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pausedDescriptor = $convert.base64Decode('CgZQYXVzZWQ=');
@$core.Deprecated('Use resumedDescriptor instead')
const Resumed$json = const {
  '1': 'Resumed',
};

/// Descriptor for `Resumed`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resumedDescriptor = $convert.base64Decode('CgdSZXN1bWVk');
@$core.Deprecated('Use listenersDescriptor instead')
const Listeners$json = const {
  '1': 'Listeners',
  '2': const [
    const {'1': 'listeners', '3': 1, '4': 1, '5': 4, '10': 'listeners'},
  ],
};

/// Descriptor for `Listeners`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listenersDescriptor = $convert.base64Decode('CglMaXN0ZW5lcnMSHAoJbGlzdGVuZXJzGAEgASgEUglsaXN0ZW5lcnM=');
