import 'dart:core';
import 'dart:typed_data';
import 'package:convert/convert.dart';

String bytesToHex(
  List<int> bytes,
) =>
    hex.encode(bytes);

Uint8List padUint8ListTo32(Uint8List data) {
  assert(data.length <= 32);
  if (data.length == 32) return data;
  return Uint8List(32)..setRange(32 - data.length, 32, data);
}

// final _reg = RegExp(r'^[0x|0X]');
String strip0x(String hex) {
  if (hex.toLowerCase().startsWith("0x")) {
    return hex.substring(2);
  }
  return hex;
}

Uint8List hexToBytes(String hexStr) {
  final bytes = hex.decode(strip0x(hexStr));
  if (bytes is Uint8List) return bytes;

  return Uint8List.fromList(bytes);
}

bool isHex(String value) {
  final RegExp hexPattern = RegExp(r'^[0-9A-Fa-f]+$');
  return hexPattern.hasMatch(value);
}

String bytesToBinary(Uint8List bytes) {
  return bytes.map((byte) => byte.toRadixString(2).padLeft(8, '0')).join('');
}

int binaryToByte(String binary) {
  return int.parse(binary, radix: 2);
}

int compareUint8Lists(Uint8List a, Uint8List b) {
  final length = a.length < b.length ? a.length : b.length;

  for (var i = 0; i < length; i++) {
    if (a[i] < b[i]) {
      return -1;
    } else if (a[i] > b[i]) {
      return 1;
    }
  }

  if (a.length < b.length) {
    return -1;
  } else if (a.length > b.length) {
    return 1;
  }

  return 0;
}

BigInt bigintPow(BigInt base, BigInt exponent, BigInt modulus) {
  BigInt result = BigInt.one;
  base %= modulus;
  while (exponent > BigInt.zero) {
    if (exponent.isOdd) {
      result = (result * base) % modulus;
    }
    exponent >>= 1;
    base = (base * base) % modulus;
  }
  return result;
}

int? parseInt(dynamic value) {
  if (value is String) {
    return int.parse(value);
  } else if (value is int) {
    return value;
  }
  return null;
}

BigInt? parseBigInt(dynamic value) {
  if (value is String) {
    return BigInt.parse(value);
  } else if (value is BigInt) {
    return value;
  } else if (value is int) {
    return BigInt.from(value);
  }
  return null;
}

int intFromBytes(List<int> bytes, Endian endian) {
  if (bytes.isEmpty) {
    throw ArgumentError("Input bytes should not be empty");
  }

  final buffer = Uint8List.fromList(bytes);
  final byteData = ByteData.sublistView(buffer);

  switch (bytes.length) {
    case 1:
      return byteData.getInt8(0);
    case 2:
      return byteData.getInt16(0, endian);
    case 4:
      return byteData.getInt32(0, endian);
    default:
      throw ArgumentError("Unsupported byte length: ${bytes.length}");
  }
}

bool bytesListEqual(List<int>? a, List<int>? b) {
  if (a == null) {
    return b == null;
  }
  if (b == null || a.length != b.length) {
    return false;
  }
  for (int index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) {
      return false;
    }
  }
  return true;
}
