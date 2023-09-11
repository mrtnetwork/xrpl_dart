// ignore_for_file: constant_identifier_names, avoid_print

import 'dart:typed_data';

import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/xrpl/bytes/definations/definations.dart';
import 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';
import 'package:xrp_dart/src/xrpl/exception/exceptions.dart';

import '../definations/field.dart';
import '../serializer.dart';

class BinaryParser {
  Uint8List bytes;
  int position = 0;

  BinaryParser(String hexBytes) : bytes = hexToBytes(hexBytes);
  BinaryParser.fromBuffer(this.bytes);
  int get length => bytes.length - position;

  int? peek() {
    if (length > 0) {
      return bytes[position];
    }
    return null;
  }

  void skip(int n) {
    if (n > length) {
      throw XRPLBinaryCodecException(
          'BinaryParser can\'t skip $n bytes, only contains $length.');
    }
    position += n;
  }

  Uint8List read(int n) {
    final result = Uint8List.fromList(bytes.sublist(position, position + n));
    position += n;
    return result;
  }

  int readUint8() {
    return read(1)[0];
  }

  int readUint16() {
    final bytes = read(2);
    return (bytes[0] << 8) + bytes[1];
  }

  int readUint32() {
    final bytes = read(4);
    return (bytes[0] << 24) + (bytes[1] << 16) + (bytes[2] << 8) + bytes[3];
  }

  bool isEnd([int? customEnd]) {
    final len = length;
    return len == 0 || (customEnd != null && len <= customEnd);
  }

  Uint8List readVariableLength() {
    final length = _readLengthPrefix();
    return read(length);
  }

  int _readLengthPrefix() {
    final byte1 = readUint8();

    if (byte1 <= _MAX_SINGLE_BYTE_LENGTH) {
      return byte1;
    }

    if (byte1 <= _MAX_SECOND_BYTE_VALUE) {
      final byte2 = readUint8();
      return (_MAX_SINGLE_BYTE_LENGTH + 1) +
          ((byte1 - (_MAX_SINGLE_BYTE_LENGTH + 1)) * _MAX_BYTE_VALUE) +
          byte2;
    }

    if (byte1 <= 254) {
      final byte2 = readUint8();
      final byte3 = readUint8();
      return _MAX_DOUBLE_BYTE_LENGTH +
          ((byte1 - (_MAX_SECOND_BYTE_VALUE + 1)) * _MAX_DOUBLE_BYTE_VALUE) +
          (byte2 * _MAX_BYTE_VALUE) +
          byte3;
    }

    throw XRPLBinaryCodecException(
        'Length prefix must contain between 1 and 3 bytes.');
  }

  FieldHeader readFieldHeader() {
    int typeCode = readUint8();
    int fieldCode = typeCode & 15;
    typeCode >>= 4;

    if (typeCode == 0) {
      typeCode = readUint8();
      if (typeCode == 0 || typeCode < 16) {
        throw XRPLBinaryCodecException(
            'Cannot read field ID, typeCode out of range.');
      }
    }

    if (fieldCode == 0) {
      fieldCode = readUint8();
      if (fieldCode == 0 || fieldCode < 16) {
        throw XRPLBinaryCodecException(
            'Cannot read field ID, fieldCode out of range.');
      }
    }

    return FieldHeader(typeCode, fieldCode);
  }

  FieldInstance readField() {
    final fieldHeader = readFieldHeader();
    final fieldName = XRPLDefinitions.getFieldNameFromHeader(fieldHeader);
    return XRPLDefinitions.getFieldInstance(fieldName);
  }

  SerializedType readFieldValue(FieldInstance field) {
    if (field.isVariableLengthEncoded) {
      final sizeHint = _readLengthPrefix();
      final value = STObject.readData(field.type, this, sizeHint);

      return value;
    } else {
      return STObject.readData(field.type, this, null);
    }
  }

  (FieldInstance, SerializedType) readFieldAndValue() {
    final field = readField();
    final value = readFieldValue(field);
    return (field, value);
  }
}

const _MAX_SINGLE_BYTE_LENGTH = 192;
const _MAX_DOUBLE_BYTE_LENGTH = 12481;
const _MAX_SECOND_BYTE_VALUE = 240;
const _MAX_BYTE_VALUE = 256;
const _MAX_DOUBLE_BYTE_VALUE = 65536;
