part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class UInt64 extends UInt {
  static const int lengthInBytes = 8;
  static final radix10 = RegExp(r'^\d{1,20}$');
  static const List<String> specialTypeNames = [
    "MaximumAmount",
    "OutstandingAmount",
    "MPTAmount",
  ];

  static final RegExp _hexRegex = RegExp(r'[a-fA-F0-9]{1,16}');

  UInt64([List<int>? buffer])
      : super(buffer ?? List<int>.filled(lengthInBytes, 0));

  @override
  factory UInt64.fromParser(BinaryParser parser, [int? lengthHint]) {
    return UInt64(parser.read(lengthInBytes));
  }

  @override
  factory UInt64.fromValue(dynamic value, {String? typeName}) {
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
      // typeName != null &&
      //     specialTypeNames.contains(typeName) &&
      if (radix10.hasMatch(value)) {
        return UInt64(BigintUtils.toBytes(BigintUtils.parse(value),
            length: lengthInBytes));
      }
      if (_hexRegex.hasMatch(value)) {
        return UInt64(BytesUtils.fromHexString(value));
      }
    }
    throw XRPLBinaryCodecException('Invalid Uint64. $value');
  }

  @override
  String toJson() {
    return BytesUtils.toHexString(_buffer, prefix: "0x");
  }
}
