part of 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';

class UInt16 extends UInt {
  static const int _width = 2;

  UInt16([Uint8List? buffer]) : super(buffer ?? Uint8List(_width));

  factory UInt16.fromParser(BinaryParser parser, [int? lengthHint]) {
    return UInt16(parser.read(_width));
  }

  factory UInt16.fromValue(dynamic value) {
    if (value is! int) {
      throw XRPLBinaryCodecException(
          "Invalid type to construct a UInt16: expected int, received ${value.runtimeType}.");
    }

    final valueBytes = Uint8List(_width);
    final view = ByteData.sublistView(valueBytes);
    view.setUint16(0, value, Endian.big);

    return UInt16(valueBytes);
  }
}
