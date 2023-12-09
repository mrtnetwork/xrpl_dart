part of 'package:xrp_dart/src/xrpl/bytes/serializer.dart';

class UInt8 extends UInt {
  static const int lengthInBytes = 1;

  UInt8([List<int>? buffer])
      : super(buffer ?? List<int>.filled(lengthInBytes, 0));

  @override
  factory UInt8.fromParser(BinaryParser parser, [int? lengthHint]) {
    return UInt8(parser.read(lengthInBytes));
  }

  @override
  factory UInt8.fromValue(dynamic value) {
    if (value is! int) {
      throw XRPLBinaryCodecException(
          "Invalid type to construct a UInt8: expected int, received ${value.runtimeType}.");
    }
    return UInt8(IntUtils.toBytes(value, length: lengthInBytes));
  }
}
