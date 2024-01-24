part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class UInt16 extends UInt {
  static const int lengthInBytes = 2;

  UInt16([List<int>? buffer])
      : super(buffer ?? List<int>.filled(lengthInBytes, 0));

  factory UInt16.fromParser(BinaryParser parser, [int? lengthHint]) {
    return UInt16(parser.read(lengthInBytes));
  }

  factory UInt16.fromValue(int value) {
    return UInt16(IntUtils.toBytes(value, length: lengthInBytes));
  }
}
