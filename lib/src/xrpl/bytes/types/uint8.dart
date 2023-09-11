part of 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';

class UInt8 extends UInt {
  static const int _width = 1;

  UInt8([Uint8List? buffer]) : super(buffer ?? Uint8List(_width));

  @override
  factory UInt8.fromParser(BinaryParser parser, [int? lengthHint]) {
    return UInt8(parser.read(_width));
  }

  @override
  factory UInt8.fromValue(dynamic value) {
    if (value is! int) {
      throw XRPLBinaryCodecException(
          "Invalid type to construct a UInt8: expected int, received ${value.runtimeType}.");
    }

    final valueBytes = Uint8List(_width);
    final view = ByteData.sublistView(valueBytes);
    view.setUint8(0, value);

    return UInt8(valueBytes);
  }
}
