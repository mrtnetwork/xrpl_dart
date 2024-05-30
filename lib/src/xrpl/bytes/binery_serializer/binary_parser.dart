// Copyright (c) 2021, XRP Ledger Foundation

// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE
// INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE
// FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
// LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING
// OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

//   Note: This code has been adapted from its original Python version to Dart.

//   The 3-Clause BSD License

//   Copyright (c) 2023 Mohsen Haydari (MRTNETWORK)
//   All rights reserved.

//   Redistribution and use in source and binary forms, with or without
//   modification, are permitted provided that the following conditions are met:

//   1. Redistributions of source code must retain the above copyright notice, this
//      list of conditions, and the following disclaimer.
//   2. Redistributions in binary form must reproduce the above copyright notice, this
//      list of conditions, and the following disclaimer in the documentation and/or
//      other materials provided with the distribution.
//   3. Neither the name of the [organization] nor the names of its contributors may be
//      used to endorse or promote products derived from this software without
//      specific prior written permission.

//   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//   WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//   IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//   INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
//   BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
//   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
//   OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
//   OF THE POSSIBILITY OF SUCH DAMAGE.

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/xrpl/bytes/definations/definations.dart';
import 'package:xrpl_dart/src/xrpl/exception/exceptions.dart';

import '../definations/field.dart';
import '../serializer.dart';

/// Constants for binary parser
class _BinaryParserConst {
  /// Maximum length for a single byte
  static const maxSingleByteLength = 192;

  /// Maximum length for a double byte
  static const maxDoubleByteLength = 12481;

  /// Maximum value for the second byte
  static const maxSecondByteValue = 240;

  /// Maximum value for a single byte
  static const maxByteValue = 256;

  /// Maximum value for a double byte
  static const maxDoubleByteValue = 65536;
}

/// A class for parsing binary data represented as a hexadecimal string.
class BinaryParser {
  final List<int> _bytes;
  int _position = 0;

  BinaryParser(List<int> bytes)
      : _bytes = BytesUtils.toBytes(bytes, unmodifiable: true);

  /// Get the remaining length of bytes to be parsed
  int get length => _bytes.length - _position;

  /// Peek at the next byte without advancing the position
  int? peek() {
    if (length > 0) {
      return _bytes[_position];
    }
    return null;
  }

  /// Skip a specified number of bytes
  void skip(int n) {
    if (n > length) {
      throw XRPLBinaryCodecException(
          'BinaryParser can\'t skip $n bytes, only contains $length.');
    }
    _position += n;
  }

  /// Read and return a specified number of bytes
  List<int> read(int n) {
    final result = _bytes.sublist(_position, _position + n);
    _position += n;
    return result;
  }

  /// Read a single Uint8
  int readUint8() {
    final bytes = read(1);
    return IntUtils.fromBytes(bytes);
  }

  /// Read a Uint16 in big-endian format
  int readUint16() {
    final bytes = read(2);
    return IntUtils.fromBytes(bytes);
  }

  /// Read a Uint32 in big-endian format
  int readUint32() {
    final bytes = read(4);
    return IntUtils.fromBytes(bytes);
  }

  /// Check if the parser is at the end or if the end position is reached
  bool isEnd([int? customEnd]) {
    final len = length;
    return len == 0 || (customEnd != null && len <= customEnd);
  }

  /// Read a variable-length byte sequence
  List<int> readVariableLength() {
    final length = _readLengthPrefix();
    return read(length);
  }

  /// Read the length prefix for a variable-length byte sequence
  int _readLengthPrefix() {
    final byte1 = readUint8();

    if (byte1 <= _BinaryParserConst.maxSingleByteLength) {
      return byte1;
    }

    if (byte1 <= _BinaryParserConst.maxSecondByteValue) {
      final byte2 = readUint8();
      return (_BinaryParserConst.maxSingleByteLength + 1) +
          ((byte1 - (_BinaryParserConst.maxSingleByteLength + 1)) *
              _BinaryParserConst.maxByteValue) +
          byte2;
    }

    if (byte1 <= 254) {
      final byte2 = readUint8();
      final byte3 = readUint8();
      return _BinaryParserConst.maxDoubleByteLength +
          ((byte1 - (_BinaryParserConst.maxSecondByteValue + 1)) *
              _BinaryParserConst.maxDoubleByteValue) +
          (byte2 * _BinaryParserConst.maxByteValue) +
          byte3;
    }

    throw const XRPLBinaryCodecException(
        'Length prefix must contain between 1 and 3 bytes.');
  }

  /// Read a field header (type and field code)
  FieldHeader readFieldHeader() {
    int typeCode = readUint8();
    int fieldCode = typeCode & 15;
    typeCode >>= 4;

    if (typeCode == 0) {
      typeCode = readUint8();
      if (typeCode == 0 || typeCode < 16) {
        throw const XRPLBinaryCodecException(
            'Cannot read field ID, typeCode out of range.');
      }
    }

    if (fieldCode == 0) {
      fieldCode = readUint8();
      if (fieldCode == 0 || fieldCode < 16) {
        throw const XRPLBinaryCodecException(
            'Cannot read field ID, fieldCode out of range.');
      }
    }

    return FieldHeader(typeCode, fieldCode);
  }

  /// Read a field instance based on its header
  FieldInstance readField() {
    final fieldHeader = readFieldHeader();
    final fieldName = XRPLDefinitions.getFieldNameFromHeader(fieldHeader);
    return XRPLDefinitions.getFieldInstance(fieldName);
  }

  /// Read and return the value of a field based on its type and size hint
  SerializedType readFieldValue(FieldInstance field) {
    if (field.isVariableLengthEncoded) {
      final sizeHint = _readLengthPrefix();
      final value = STObject.readData(field.type, this, sizeHint);

      return value;
    } else {
      return STObject.readData(field.type, this, null);
    }
  }

  /// Read both a field and its value
  Tuple<FieldInstance, SerializedType> readFieldAndValue() {
    final field = readField();
    final value = readFieldValue(field);
    return Tuple(field, value);
  }
}
