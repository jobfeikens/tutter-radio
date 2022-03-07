import 'dart:typed_data';

abstract class MessageTypeCodec<T> {
  const MessageTypeCodec();

  Uint8List encode(T data);

  T? decode(Uint8List data);
}

class NoDecoder extends MessageTypeCodec<Uint8List> {
  const NoDecoder();

  @override
  Uint8List encode(Uint8List data) {
    // TODO: implement encode
    throw UnimplementedError();
  }

  @override
  Uint8List decode(Uint8List data) => data;
}

class BoolDecoder extends MessageTypeCodec<bool> {
  const BoolDecoder();

  @override
  Uint8List encode(bool data) {
    // TODO: implement encode
    throw UnimplementedError();
  }

  @override
  bool decode(Uint8List data) {
    return data[0] > 0;
  }
}