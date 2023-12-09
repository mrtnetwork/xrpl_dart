library xrp_serializer;

import 'dart:convert';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:blockchain_utils/compare/compare.dart';
import 'package:xrp_dart/src/xrpl/bytes/binery_serializer/binary_serializer.dart';
import 'package:xrp_dart/src/xrpl/bytes/definations/definations.dart';
import 'package:xrp_dart/src/xrpl/bytes/definations/field.dart';
import 'package:xrp_dart/src/xrpl/bytes/binery_serializer/binary_parser.dart';
import 'package:xrp_dart/src/xrpl/exception/exceptions.dart';
part 'types/account_id.dart';
part 'types/amount.dart';
part 'types/blob.dart';
part 'types/currency.dart';
part 'types/hash.dart';
part 'types/hash128.dart';
part 'types/hash160.dart';
part 'types/hash256.dart';
part 'types/issue.dart';
part 'types/path.dart';
part 'types/st_array.dart';
part 'types/st_object.dart';
part 'types/uint.dart';
part 'types/uint16.dart';
part 'types/uint32.dart';
part 'types/uint64.dart';
part 'types/uint8.dart';
part 'types/vector256.dart';

/// An abstract class representing a serialized XRPL object.
abstract class SerializedType {
  late final List<int> _buffer;

  /// Constructs a SerializedType object with an optional buffer.
  /// If buffer is not provided, an empty bytes is used.
  SerializedType([List<int>? buffer]) {
    if (buffer != null) {
      _buffer = List.unmodifiable(BytesUtils.toBytes(buffer));
      return;
    }
    _buffer = List.empty();
  }

  /// Converts the serialized object to a bytes.
  List<int> toBytes() {
    return List<int>.from(_buffer);
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
    return BytesUtils.toHexString(_buffer, false);
  }

  /// Returns the length of the serialized object in bytes.
  int get length {
    return _buffer.length;
  }
}
