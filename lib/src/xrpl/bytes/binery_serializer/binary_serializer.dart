import 'package:blockchain_utils/binary/binary.dart';
import 'package:xrp_dart/src/xrpl/bytes/definations/field.dart';

/// Constants for binary serializer
class _BinerySerializerConst {
  /// Maximum length for a single byte
  static const int _maxSingleByteLength = 192;

  /// Maximum length for a double byte
  static const int _maxDoubleByteLength = 12481;

  /// Maximum value for the second byte
  static const int _maxSecondByteValue = 240;

  /// Maximum length value
  static const int _maxLengthValue = 918744;
}

/// A class for serializing binary data.
class BinarySerializer {
  DynamicByteTracker bytesink = DynamicByteTracker();

  /// Append bytes to the serializer
  void append(List<int> bytesObject) {
    bytesink.add(bytesObject);
  }

  /// Get the serialized bytes
  List<int> toBytes() {
    return bytesink.toBytes();
  }

  /// Write a length-encoded value to the serializer
  void writeLengthEncoded(String value, {bool encodeValue = true}) {
    List<int> byteObject = List<int>.empty();
    if (encodeValue) {
      byteObject = BytesUtils.fromHexString(value);
    }
    final lengthPrefix = _encodeVariableLengthPrefix(byteObject.length);
    append(lengthPrefix);
    append(byteObject);
  }

  /// Write a field and its value to the serializer
  void writeFieldAndValue(
    FieldInstance field,
    String value, {
    bool isUnlModifyWorkaround = false,
  }) {
    append(field.header.toBytes());

    if (field.isVariableLengthEncoded) {
      writeLengthEncoded(value, encodeValue: !isUnlModifyWorkaround);
    } else {
      append(BytesUtils.fromHexString(value));
    }
  }

  /// Encode the length prefix for a variable-length value
  List<int> _encodeVariableLengthPrefix(int length) {
    if (length <= _BinerySerializerConst._maxSingleByteLength) {
      return [length];
    }
    if (length < _BinerySerializerConst._maxDoubleByteLength) {
      length -= _BinerySerializerConst._maxSingleByteLength + 1;
      final byte1 =
          ((_BinerySerializerConst._maxSingleByteLength + 1) + (length >> 8));
      final byte2 = (length & mask8);
      return [byte1, byte2];
    }
    if (length <= _BinerySerializerConst._maxLengthValue) {
      length -= _BinerySerializerConst._maxDoubleByteLength;
      final byte1 =
          ((_BinerySerializerConst._maxSecondByteValue + 1) + (length >> 16));
      final byte2 = ((length >> 8) & mask8);
      final byte3 = (length & mask8);
      return [byte1, byte2, byte3];
    }

    throw Exception(
        'VariableLength field must be <= ${_BinerySerializerConst._maxLengthValue} bytes long');
  }
}
