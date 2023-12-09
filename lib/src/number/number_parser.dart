import 'dart:core';

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
}
