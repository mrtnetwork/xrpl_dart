part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class UInt8 extends UInt {
  static const int lengthInBytes = 1;

  UInt8([List<int>? buffer])
      : super(buffer ?? List<int>.filled(lengthInBytes, 0));

  @override
  factory UInt8.fromParser(BinaryParser parser, [int? lengthHint]) {
    return UInt8(parser.read(lengthInBytes));
  }

  @override
  factory UInt8.fromValue(int value) {
    return UInt8(IntUtils.toBytes(value, length: lengthInBytes));
  }
}
