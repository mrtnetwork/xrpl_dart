part of 'package:xrp_dart/src/xrpl/bytes/serializer.dart';

class Vector256 extends SerializedType {
  static const int lengthInBytes = 32;
  Vector256([super.buffer]);

  @override
  factory Vector256.fromValue(dynamic value) {
    if (value is! List) {
      throw XRPLBinaryCodecException(
          "Invalid type to construct a Vector256: expected list, received ${value.runtimeType}.");
    }

    final byteList = <List<int>>[];
    for (final string in value) {
      byteList.add(Hash256.fromValue(string)._buffer);
    }

    return Vector256(byteList.expand((e) => e).toList());
  }

  @override
  factory Vector256.fromParser(BinaryParser parser, [int? lengthHint]) {
    final byteList = <List<int>>[];
    final numBytes = lengthHint ?? parser.length;
    final numHashes = numBytes ~/ lengthInBytes;
    for (var i = 0; i < numHashes; i++) {
      byteList.add(Hash256.fromParser(parser)._buffer);
    }
    return Vector256(byteList.expand((e) => e).toList());
  }

  @override
  List<String> toJson() {
    if (_buffer.length % lengthInBytes != 0) {
      throw const XRPLBinaryCodecException("Invalid bytes for Vector256.");
    }

    final hashList = <String>[];
    for (int i = 0; i < _buffer.length; i += lengthInBytes) {
      hashList.add(
          BytesUtils.toHexString(_buffer.sublist(i, i + lengthInBytes), false));
    }

    return hashList;
  }
}
