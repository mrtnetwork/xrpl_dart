import 'dart:typed_data';
import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/formating/bytes_tracker.dart';
import 'package:xrp_dart/src/xrpl/bytes/definations/field.dart';

class BinarySerializer {
  DynamicByteTracker bytesink = DynamicByteTracker();
  void append(Uint8List bytesObject) {
    bytesink.add(bytesObject);
  }

  Uint8List toBytes() {
    return bytesink.toBytes();
  }

  void writeLengthEncoded(String value, {bool encodeValue = true}) {
    Uint8List byteObject = Uint8List.fromList([]);
    if (encodeValue) {
      byteObject = hexToBytes(value);
    }
    final lengthPrefix = _encodeVariableLengthPrefix(byteObject.length);
    append(lengthPrefix);
    append(byteObject);
  }

  void writeFieldAndValue(
    FieldInstance field,
    String value, {
    bool isUnlModifyWorkaround = false,
  }) {
    append(field.header.toBytes());

    if (field.isVariableLengthEncoded) {
      writeLengthEncoded(value, encodeValue: !isUnlModifyWorkaround);
    } else {
      append(hexToBytes(value));
    }
  }

  void close() {
    bytesink.close();
  }

  Uint8List _encodeVariableLengthPrefix(int length) {
    if (length <= _maxSingleByteLength) {
      return Uint8List.fromList([length]);
    }
    if (length < _maxDoubleByteLength) {
      length -= _maxSingleByteLength + 1;
      final byte1 = ((_maxSingleByteLength + 1) + (length >> 8));
      final byte2 = (length & 0xFF);
      return Uint8List.fromList([byte1, byte2]);
    }
    if (length <= _maxLengthValue) {
      length -= _maxDoubleByteLength;
      final byte1 = ((_maxSecondByteValue + 1) + (length >> 16));
      final byte2 = ((length >> 8) & 0xFF);
      final byte3 = (length & 0xFF);
      return Uint8List.fromList([byte1, byte2, byte3]);
    }

    throw Exception(
        'VariableLength field must be <= $_maxLengthValue bytes long');
  }

  static const int _maxSingleByteLength = 192;
  static const int _maxDoubleByteLength = 12481;
  static const int _maxSecondByteValue = 240;
  static const int _maxLengthValue = 918744;
}
