part of 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';

abstract class UInt extends SerializedType {
  UInt([Uint8List? buffer]) : super(buffer);

  int get value {
    return int.parse(bytesToHex(buffer), radix: 16);
  }

  bool equals(dynamic other) {
    if (other is int) {
      return value == other;
    }
    if (other is UInt) {
      return value == other.value;
    }
    throw XRPLBinaryCodecException(
        "Cannot compare UInt and ${other.runtimeType}");
  }

  bool notEquals(dynamic other) {
    if (other is int) {
      return value != other;
    }
    if (other is UInt) {
      return value != other.value;
    }
    throw XRPLBinaryCodecException(
        "Cannot compare UInt and ${other.runtimeType}");
  }

  bool lessThan(dynamic other) {
    if (other is int) {
      return value < other;
    }
    if (other is UInt) {
      return value < other.value;
    }
    throw XRPLBinaryCodecException(
        "Cannot compare UInt and ${other.runtimeType}");
  }

  bool lessThanOrEqual(dynamic other) {
    if (other is int) {
      return value <= other;
    }
    if (other is UInt) {
      return value <= other.value;
    }
    throw XRPLBinaryCodecException(
        "Cannot compare UInt and ${other.runtimeType}");
  }

  bool greaterThan(dynamic other) {
    if (other is int) {
      return value > other;
    }
    if (other is UInt) {
      return value > other.value;
    }
    throw XRPLBinaryCodecException(
        "Cannot compare UInt and ${other.runtimeType}");
  }

  bool greaterThanOrEqual(dynamic other) {
    if (other is int) {
      return value >= other;
    }
    if (other is UInt) {
      return value >= other.value;
    }
    throw XRPLBinaryCodecException(
        "Cannot compare UInt and ${other.runtimeType}");
  }

  @override
  dynamic toJson() {
    return value;
  }
}
