// The MIT License (MIT)

// Copyright (c) 2016 PromonLogicalis

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import 'package:blockchain_utils/blockchain_utils.dart';

class ASN1RawEncoder {
  /// Encode an ASN.1 raw value
  static List<int> encode(ANS1RawOptions raw) {
    List<int> buf = encodeIdentifier(raw);

    // Add length information and raw data
    if (!raw.indefinite) {
      int length = raw.content.length;
      buf.addAll(encodeLength(length));
      buf.addAll(raw.content);
    } else {
      // Indefinite length uses 0x80, data..., 0x00, 0x00
      if (!raw.constructed) {
        throw Exception(
            'indefinite length is only allowed for constructed types');
      }
      buf.add(0x80);
      buf.addAll(raw.content);
      buf.addAll([0x00, 0x00]);
    }

    return buf;
  }

  /// Encode the identifier of an ASN.1 raw value
  static List<int> encodeIdentifier(ANS1RawOptions node) {
    if (node.classValue > 0x03) {
      throw Exception('invalid class value: ${node.classValue}');
    }

    List<int> identifier = List<int>.from([0x00], growable: true);

    // Class (bits 7 and 6) + primitive/constructed (1 bit) + tag (5 bits)
    identifier[0] += ((node.classValue & 0x03) << 6);

    // Primitive/constructed (bit 5)
    if (node.constructed) {
      identifier[0] += (1 << 5);
    }

    // Tag (bits 4 to 0)
    if (node.tag <= 30) {
      identifier[0] += (0x1f & node.tag);
    } else {
      identifier[0] += 0x1f;
      identifier.addAll(encodeMultiByteTag(node.tag));
    }

    return identifier;
  }

  /// Encode a multi-byte tag
  static List<int> encodeMultiByteTag(int tag) {
    int bufLen = ((32 - 1) ~/ 7) + 1; // Assuming a 32-bit integer
    List<int> buf = List.filled(bufLen, 0);

    for (int i = 0; i < buf.length; i++) {
      int shift = 7 * (buf.length - i - 1);
      int mask = 0x7F << shift;
      buf[i] = ((tag & mask) >> shift) & mask8;
      // Only the last byte is not marked with 0x80
      if (i != buf.length - 1) {
        buf[i] |= 0x80;
      }
    }

    /// Discard leading zero values
    return removeLeadingBytes(buf, 0x80);
  }

  /// Encode the length of an ASN.1 raw value
  static List<int> encodeLength(int length) {
    if (length < 0x80) {
      return [length];
    }

    int bufLen = 4; // Assuming a 32-bit integer
    List<int> buf = List.filled(bufLen, 0);

    for (int i = 0; i < buf.length; i++) {
      int shift = (buf.length - i - 1) * 8;
      int mask = mask8 << shift;
      buf[i] = ((mask & length) >> shift) & mask8;
    }

    // Ignore leading zeros
    buf = removeLeadingBytes(buf, 0x00);

    // Add leading byte with the number of following bytes
    buf.insert(0, 0x80 + buf.length);
    return buf;
  }

  /// Remove leading bytes from a list
  static List<int> removeLeadingBytes(List<int> buf, int target) {
    int start = 0;
    while (start < buf.length - 1 && buf[start] == target) {
      start++;
    }
    return buf.sublist(start);
  }

  static List<int> encodeIntegerValue(int value) {
    if (value == 0) {
      return [0];
    }
    List<int> encoded = [];

    // Determine the number of bytes needed to represent the value
    int byteCount = (value.bitLength + 7) ~/ 8;

    // Encode value
    for (int i = byteCount - 1; i >= 0; i--) {
      encoded.add((value >> (8 * i)) & mask8);
    }
    // If the first bit of the first byte is 1 (negative number), prepend a zero byte
    if ((encoded[0] & 0x80) != 0) {
      encoded.insert(0, 0);
    }
    return encoded;
  }
}

/// Placeholder for the ANS1RawOptions class - adjust according to your actual implementation
class ANS1RawOptions {
  final int classValue;
  final int tag;
  final bool constructed;
  final bool indefinite;
  final List<int> content;

  ANS1RawOptions({
    required this.classValue,
    required this.tag,
    required this.constructed,
    required this.indefinite,
    required List<int> content,
  }) : content = List<int>.unmodifiable(content);
}
