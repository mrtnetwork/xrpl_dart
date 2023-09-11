part of 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';

class UInt32 extends UInt {
  static const int _width = 4; // 32 / 8

  UInt32([Uint8List? buffer]) : super(buffer ?? Uint8List(_width));

  @override
  factory UInt32.fromParser(BinaryParser parser, [int? lengthHint]) {
    return UInt32(parser.read(_width));
  }

  @override
  factory UInt32.fromValue(dynamic value) {
    if (value is! String && value is! int) {
      throw XRPLBinaryCodecException(
          "Invalid type to construct a UInt32: expected String or int, received ${value.runtimeType}.");
    }

    final valueBytes = Uint8List(_width);
    final view = ByteData.sublistView(valueBytes);

    if (value is int) {
      view.setUint32(0, value, Endian.big);
    } else if (value is String && int.tryParse(value) != null) {
      view.setUint32(0, int.parse(value), Endian.big);
    } else {
      throw XRPLBinaryCodecException(
          "Cannot construct UInt32 from given value");
    }

    return UInt32(valueBytes);
  }
}
