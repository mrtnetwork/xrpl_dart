part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class UInt64 extends UInt {
  static const int lengthInBytes = 8;

  static final RegExp _hexRegex = RegExp(r'[a-fA-F0-9]{1,16}');

  UInt64([List<int>? buffer])
      : super(buffer ?? List<int>.filled(lengthInBytes, 0));

  @override
  factory UInt64.fromParser(BinaryParser parser, [int? lengthHint]) {
    return UInt64(parser.read(lengthInBytes));
  }

  @override
  factory UInt64.fromValue(dynamic value) {
    if (value is! String && value is! int && value is! BigInt) {
      throw XRPLBinaryCodecException(
          'Invalid type to construct a UInt64: expected String or int, received ${value.runtimeType}.');
    }

    if (value is int) {
      if (value < 0) {
        throw XRPLBinaryCodecException('$value must be an unsigned integer');
      }
      return UInt64(
          BigintUtils.toBytes(BigInt.from(value), length: lengthInBytes));
    } else if (value is String) {
      if (!_hexRegex.hasMatch(value)) {
        throw XRPLBinaryCodecException('$value is not a valid hex string');
      }
      final valueBytes = BytesUtils.fromHexString(value);
      return UInt64(valueBytes);
    } else {
      return UInt64(BigintUtils.toBytes(value, length: lengthInBytes));
    }
  }

  @override
  String toJson() {
    return BytesUtils.toHexString(_buffer);
  }
}
