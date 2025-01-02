part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class UInt32 extends UInt {
  static const int lengthInBytes = 4;

  UInt32([List<int>? buffer])
      : super(buffer ?? List<int>.filled(lengthInBytes, 0));

  @override
  factory UInt32.fromParser(BinaryParser parser, [int? lengthHint]) {
    return UInt32(parser.read(lengthInBytes));
  }

  @override
  factory UInt32.fromValue(dynamic value) {
    if (value is! String && value is! int) {
      throw XRPLBinaryCodecException(
          'Invalid type to construct a UInt32: expected String or int, received ${value.runtimeType}.');
    }
    List<int> valueBytes;
    try {
      valueBytes =
          IntUtils.toBytes(int.parse(value.toString()), length: lengthInBytes);
    } catch (e) {
      throw const XRPLBinaryCodecException(
          'Cannot construct UInt32 from given value');
    }
    return UInt32(valueBytes);
  }
}
