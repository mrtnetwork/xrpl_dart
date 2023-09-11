import 'dart:typed_data';

import 'package:xrp_dart/src/formating/bytes_num_formating.dart';

abstract class SerializedType {
  Uint8List buffer;

  SerializedType([Uint8List? buffer]) : buffer = buffer ?? Uint8List(0);

  // SerializedType fromParser(BinaryParser parser, [int? lengthHint]) {
  //   throw UnimplementedError();
  // }

  // SerializedType fromValue(dynamic value) {
  //   throw UnimplementedError();
  // }

  Uint8List toBytes() {
    return Uint8List.fromList(buffer);
  }

  dynamic toJson() {
    return toHex();
  }

  @override
  String toString() {
    return toHex();
  }

  String toHex() {
    return bytesToHex(buffer).toUpperCase();
  }

  int get length {
    return buffer.length;
  }
}
