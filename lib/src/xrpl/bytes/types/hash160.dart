part of 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';

class Hash160 extends Hash {
  static const int lengthBytes = 20;
  Hash160([Uint8List? buffer]) : super(buffer ?? Uint8List(lengthBytes));
  @override
  factory Hash160.fromValue(dynamic value) {
    if (value is! String || value.isEmpty) {
      throw XRPLBinaryCodecException('Invalid hash value: $value');
    }
    return Hash160(hexToBytes(value));
  }
  @override
  factory Hash160.fromParser(BinaryParser parser, [int? lengthHint]) {
    final numBytes = lengthHint ?? 20;
    final bytes = parser.read(numBytes);
    return Hash160(bytes);
  }
  @override
  int getLength() {
    return 20;
  }
}
