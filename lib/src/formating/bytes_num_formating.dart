import 'dart:core';
import 'dart:typed_data';
import 'package:convert/convert.dart';

/// Converts a list of bytes to a hexadecimal string.
String bytesToHex(List<int> bytes) => hex.encode(bytes);

/// Pads a Uint8List to a length of 32 bytes by adding leading zeros if needed.
Uint8List padUint8ListTo32(Uint8List data) {
  assert(data.length <= 32);
  if (data.length == 32) return data;
  return Uint8List(32)..setRange(32 - data.length, 32, data);
}

/// Removes the "0x" prefix from a hexadecimal string if present.
String strip0x(String hex) {
  if (hex.toLowerCase().startsWith("0x")) {
    return hex.substring(2);
  }
  return hex;
}

/// Converts a hexadecimal string to a Uint8List.
Uint8List hexToBytes(String hexStr) {
  /// Remove the "0x" prefix if present and decode the hexadecimal string.
  final bytes = hex.decode(strip0x(hexStr));

  /// Check if the result is already a Uint8List, and return it if so.
  if (bytes is Uint8List) return bytes;

  /// Otherwise, create a new Uint8List from the decoded bytes.
  return Uint8List.fromList(bytes);
}

/// Checks if a string is a valid hexadecimal string.
bool isHex(String value) {
  /// Define a regular expression pattern for valid hexadecimal strings.
  final RegExp hexPattern = RegExp(r'^[0-9A-Fa-f]+$');

  /// Use the regular expression to match the input value.
  return hexPattern.hasMatch(value);
}

/// Compare two Uint8Lists lexicographically.
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

/// Calculate (base^exponent) % modulus efficiently using BigInt arithmetic.
BigInt bigintPow(BigInt base, BigInt exponent, BigInt modulus) {
  BigInt result = BigInt.one;
  base %= modulus;
  while (exponent > BigInt.zero) {
    if (exponent.isOdd) {
      result = (result * base) % modulus;
    }
    exponent >>= 1;

    /// Equivalent to exponent /= 2
    base = (base * base) % modulus;
  }
  return result;
}

/// Parse a dynamic value into an integer if possible, or return null if not.
int? parseInt(dynamic value) {
  if (value is String) {
    try {
      return int.parse(value);
    } catch (_) {
      /// Parsing failed, return null.
      return null;
    }
  } else if (value is int) {
    return value;
  }
  return null;

  /// Return null for other types or invalid input.
}

/// Parse a dynamic value into a BigInt if possible, or return null if not.
BigInt? parseBigInt(dynamic value) {
  if (value is String) {
    try {
      return BigInt.parse(value);
    } catch (_) {
      /// Parsing failed, return null.
      return null;
    }
  } else if (value is BigInt) {
    return value;
  } else if (value is int) {
    return BigInt.from(value);
  }
  return null;

  /// Return null for other types or invalid input.
}

/// Convert a list of bytes to an integer based on the specified endianness.
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

/// Compare two lists of bytes for equality.
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
