/*
Copyright (c) 2021, XRP Ledger Foundation

Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE
INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE
FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING
OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  
  Note: This code has been adapted from its original Python version to Dart.
*/
/*
  The 3-Clause BSD License
  
  Copyright (c) 2023 Mohsen Haydari (MRTNETWORK)
  All rights reserved.
  
  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
  
  1. Redistributions of source code must retain the above copyright notice, this
     list of conditions, and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright notice, this
     list of conditions, and the following disclaimer in the documentation and/or
     other materials provided with the distribution.
  3. Neither the name of the [organization] nor the names of its contributors may be
     used to endorse or promote products derived from this software without
     specific prior written permission.
  
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
  OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
  OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import 'package:blockchain_utils/utils/utils.dart';
import 'package:xrpl_dart/src/xrpl/bytes/definations/field.dart';
import 'package:xrpl_dart/src/xrpl/exception/exceptions.dart';

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

    throw const XRPLBinaryCodecException(
        'VariableLength field must be <= ${_BinerySerializerConst._maxLengthValue} bytes long');
  }
}
