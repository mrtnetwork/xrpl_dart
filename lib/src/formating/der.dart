import 'dart:typed_data';

import 'bytes_num_formating.dart' show hexToBytes;

/// Convert a list of BigInt integers to a DER-encoded Uint8List.
Uint8List listBigIntToDER(List<BigInt> bigIntList) {
  /// Encode each BigInt integer in the list to Uint8List
  List<Uint8List> encodedIntegers = bigIntList.map((bi) {
    var bytes = _encodeInteger(bi);
    return Uint8List.fromList(bytes);
  }).toList();

  /// Calculate the length of the content bytes
  final lengthBytes =
      _encodeLength(encodedIntegers.fold<int>(0, (sum, e) => sum + e.length));

  /// Concatenate all encoded integers to form the content bytes
  final contentBytes = encodedIntegers.fold<Uint8List>(
      Uint8List(0), (prev, e) => Uint8List.fromList([...prev, ...e]));

  /// Create the DER-encoded bytes by combining the header, length, and content
  final derBytes = Uint8List.fromList([
    0x30,

    /// Tag for SEQUENCE
    ...lengthBytes,
    ...contentBytes,
  ]);

  return derBytes;
}

/// Encode the length field for a DER sequence.
Uint8List _encodeLength(int length) {
  if (length < 128) {
    /// If the length is less than 128, it is encoded as a single byte.
    return Uint8List.fromList([length]);
  } else {
    /// If the length is 128 or greater, it is encoded in two parts:
    /// 1. The first byte specifies the number of bytes used to represent the length.
    /// 2. The subsequent bytes represent the actual length in big-endian format.

    var lengthBytes =
        length.toRadixString(16).padLeft((length.bitLength + 7) ~/ 8, '0');

    if (lengthBytes.length % 2 != 0) {
      /// Ensure that the length is an even number of hexadecimal digits.
      lengthBytes = '0$lengthBytes';
    }

    /// Calculate the first byte, which contains the number of length bytes.
    var firstByte = 0x80 | (lengthBytes.length ~/ 2);

    /// Combine the first byte and the actual length bytes.
    return Uint8List.fromList([firstByte, ...hexToBytes(lengthBytes)]);
  }
}

Uint8List _encodeInteger(BigInt r) {
  assert(r >= BigInt.zero);

  /// can't support negative numbers yet

  String h = r.toRadixString(16);
  if (h.length % 2 != 0) {
    h = '0$h';
  }
  Uint8List s = hexToBytes(h);

  int num = s[0];
  if (num <= 0x7F) {
    return Uint8List.fromList([0x02, ..._length(s.length), ...s]);
  } else {
    /// DER integers are two's complement, so if the first byte is
    /// 0x80-0xff then we need an extra 0x00 byte to prevent it from
    /// looking negative.
    return Uint8List.fromList([0x02, ..._length(s.length + 1), 0x00, ...s]);
  }
}

/// Encodes the length field for a DER sequence.
Uint8List _length(int length) {
  if (length < 128) {
    /// If the length is less than 128, it is encoded as a single byte.
    return Uint8List.fromList([length]);
  } else {
    /// If the length is 128 or greater, it is encoded in two parts:
    /// 1. The first byte specifies the number of bytes used to represent the length.
    /// 2. The subsequent bytes represent the actual length in big-endian format.

    /// Calculate the number of bytes needed to represent the length.
    final lengthBytes = hexToBytes(
        length.toRadixString(16).padLeft((length.bitLength + 7) ~/ 8, '0'));

    /// Determine the value of the first byte.
    final firstByte = 0x80 | lengthBytes.length;

    /// Combine the first byte and the actual length bytes.
    return Uint8List.fromList([firstByte, ...lengthBytes]);
  }
}

List<BigInt> decodeDERToListBigInt(Uint8List derData) {
  int currentPosition = 0;
  List<BigInt> result = [];

  while (currentPosition < derData.length) {
    /// Check for SEQUENCE tag (0x30)
    if (derData[currentPosition] == 0x30) {
      currentPosition++;

      /// Move past the SEQUENCE tag

      /// Read the length
      int length = derData[currentPosition];
      currentPosition++;

      /// Start of the content
      int start = currentPosition;

      /// Iterate through the content
      while (currentPosition < start + length) {
        /// Check for INTEGER tag (0x02)
        if (derData[currentPosition] == 0x02) {
          currentPosition++;

          /// Move past the INTEGER tag

          /// Read the length of the integer
          int intLength = derData[currentPosition];
          currentPosition++;

          /// Read the integer value
          BigInt integerValue = BigInt.zero;
          for (int i = 0; i < intLength; i++) {
            integerValue =
                (integerValue << 8) | BigInt.from(derData[currentPosition]);
            currentPosition++;
          }
          result.add(integerValue);
        } else {
          /// Skip unknown tags or types
          currentPosition++;
          int dataLength = derData[currentPosition];
          currentPosition += dataLength;
        }
      }
    } else {
      /// Skip unknown tags or types
      currentPosition++;
      int dataLength = derData[currentPosition];
      currentPosition += dataLength;
    }
  }

  return result;
}
