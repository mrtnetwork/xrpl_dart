part of 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';

const int _hashLengthBytes = 32;

class Vector256 extends SerializedType {
  Vector256([Uint8List? buffer]) : super(buffer);

  @override
  factory Vector256.fromValue(dynamic value) {
    if (value is! List) {
      throw XRPLBinaryCodecException(
          "Invalid type to construct a Vector256: expected list, received ${value.runtimeType}.");
    }

    final byteList = <Uint8List>[];
    for (final string in value) {
      byteList.add(Hash256.fromValue(string).buffer);
    }

    return Vector256(Uint8List.fromList(byteList.expand((e) => e).toList()));
  }

  @override
  factory Vector256.fromParser(BinaryParser parser, [int? lengthHint]) {
    final byteList = <Uint8List>[];
    final numBytes = lengthHint ?? parser.length;
    final numHashes = numBytes ~/ _hashLengthBytes;
    for (var i = 0; i < numHashes; i++) {
      byteList.add(Hash256.fromParser(parser).buffer);
    }
    return Vector256(Uint8List.fromList(byteList.expand((e) => e).toList()));
  }

  @override
  List<String> toJson() {
    if (buffer.length % _hashLengthBytes != 0) {
      throw XRPLBinaryCodecException("Invalid bytes for Vector256.");
    }

    final hashList = <String>[];
    for (int i = 0; i < buffer.length; i += _hashLengthBytes) {
      hashList.add(
          bytesToHex(buffer.sublist(i, i + _hashLengthBytes)).toUpperCase());
    }

    return hashList;
  }
}
