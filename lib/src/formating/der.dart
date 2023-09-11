import 'dart:typed_data';

import 'bytes_num_formating.dart' show hexToBytes;

Uint8List listBigIntToDER(List<BigInt> bigIntList) {
  List<Uint8List> encodedIntegers = bigIntList.map((bi) {
    var bytes = _encodeInteger(bi);
    return Uint8List.fromList(bytes);
  }).toList();

  var lengthBytes =
      _encodeLength(encodedIntegers.fold<int>(0, (sum, e) => sum + e.length));
  var contentBytes = encodedIntegers.fold<Uint8List>(
      Uint8List(0), (prev, e) => Uint8List.fromList([...prev, ...e]));

  var derBytes = Uint8List.fromList([
    0x30,
    ...lengthBytes,
    ...contentBytes,
  ]);

  return derBytes;
}

Uint8List _encodeLength(int length) {
  if (length < 128) {
    return Uint8List.fromList([length]);
  } else {
    var lengthBytes =
        length.toRadixString(16).padLeft((length.bitLength + 7) ~/ 8, '0');
    if (lengthBytes.length % 2 != 0) {
      lengthBytes = '0$lengthBytes';
    }
    return Uint8List.fromList(
        [0x80 | (lengthBytes.length ~/ 2), ...hexToBytes(lengthBytes)]);
  }
}

Uint8List _encodeInteger(BigInt r) {
  assert(r >= BigInt.zero); // can't support negative numbers yet

  String h = r.toRadixString(16);
  if (h.length % 2 != 0) {
    h = '0$h';
  }
  Uint8List s = hexToBytes(h);

  int num = s[0];
  if (num <= 0x7F) {
    return Uint8List.fromList([0x02, ..._length(s.length), ...s]);
  } else {
    // DER integers are two's complement, so if the first byte is
    // 0x80-0xff then we need an extra 0x00 byte to prevent it from
    // looking negative.
    return Uint8List.fromList([0x02, ..._length(s.length + 1), 0x00, ...s]);
  }
}

Uint8List _length(int length) {
  if (length < 128) {
    return Uint8List.fromList([length]);
  } else {
    var lengthBytes = hexToBytes(
        length.toRadixString(16).padLeft((length.bitLength + 7) ~/ 8, '0'));
    return Uint8List.fromList([0x80 | (lengthBytes.length), ...lengthBytes]);
  }
}

List<BigInt> decodeDERToListBigInt(Uint8List derData) {
  int currentPosition = 0;
  List<BigInt> result = [];

  while (currentPosition < derData.length) {
    // Check for SEQUENCE tag (0x30)
    if (derData[currentPosition] == 0x30) {
      currentPosition++; // Move past the SEQUENCE tag

      // Read the length
      int length = derData[currentPosition];
      currentPosition++;

      // Start of the content
      int start = currentPosition;

      // Iterate through the content
      while (currentPosition < start + length) {
        // Check for INTEGER tag (0x02)
        if (derData[currentPosition] == 0x02) {
          currentPosition++; // Move past the INTEGER tag

          // Read the length of the integer
          int intLength = derData[currentPosition];
          currentPosition++;

          // Read the integer value
          BigInt integerValue = BigInt.zero;
          for (int i = 0; i < intLength; i++) {
            integerValue =
                (integerValue << 8) | BigInt.from(derData[currentPosition]);
            currentPosition++;
          }
          result.add(integerValue);
        } else {
          // Skip unknown tags or types
          currentPosition++;
          int dataLength = derData[currentPosition];
          currentPosition += dataLength;
        }
      }
    } else {
      // Skip unknown tags or types
      currentPosition++;
      int dataLength = derData[currentPosition];
      currentPosition += dataLength;
    }
  }

  return result;
}
