import 'dart:typed_data';

import 'package:xrp_dart/src/formating/bytes_num_formating.dart';

/// An abstract class representing a serialized XRPL object.
abstract class SerializedType {
  Uint8List buffer;

  /// Constructs a SerializedType object with an optional buffer.
  /// If buffer is not provided, an empty Uint8List is used.
  SerializedType([Uint8List? buffer]) : buffer = buffer ?? Uint8List(0);

  /// Converts the serialized object to a Uint8List.
  Uint8List toBytes() {
    return Uint8List.fromList(buffer);
  }

  /// Converts the serialized object to a JSON representation.
  dynamic toJson() {
    return toHex();
  }

  @override
  String toString() {
    return toHex();
  }

  /// Converts the serialized object to a hexadecimal string.
  String toHex() {
    return bytesToHex(buffer).toUpperCase();
  }

  /// Returns the length of the serialized object in bytes.
  int get length {
    return buffer.length;
  }
}
