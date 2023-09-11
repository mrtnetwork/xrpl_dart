part of 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';

class UInt64 extends UInt {
  static const int _width = 8; // 64 / 8
  static final RegExp _hexRegex = RegExp(r'[a-fA-F0-9]{1,16}');

  UInt64([Uint8List? buffer]) : super(buffer ?? Uint8List(_width));

  @override
  factory UInt64.fromParser(BinaryParser parser, [int? lengthHint]) {
    return UInt64(parser.read(_width));
  }

  @override
  factory UInt64.fromValue(dynamic value) {
    if (value is! String && value is! int) {
      throw XRPLBinaryCodecException(
          'Invalid type to construct a UInt64: expected String or int, received ${value.runtimeType}.');
    }

    final valueBytes = Uint8List(_width);

    if (value is int) {
      if (value < 0) {
        throw XRPLBinaryCodecException('$value must be an unsigned integer');
      }
      final view = ByteData.sublistView(valueBytes);
      view.setUint64(0, value, Endian.big);
      return UInt64(valueBytes);
    } else if (value is String) {
      if (!_hexRegex.hasMatch(value)) {
        throw XRPLBinaryCodecException('$value is not a valid hex string');
      }
      final valueBytes = hexToBytes(value);
      return UInt64(valueBytes);
    } else {
      throw XRPLBinaryCodecException(
          'Cannot construct UInt64 from given value $value');
    }
  }

  @override
  String toJson() {
    return bytesToHex(buffer);
  }
}
