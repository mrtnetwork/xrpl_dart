part of 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';

class Hash128 extends Hash {
  Hash128([Uint8List? buffer]) : super(buffer ?? Uint8List(16));
  @override
  factory Hash128.fromValue(dynamic value) {
    if (value is! String || value.isEmpty) {
      throw XRPLBinaryCodecException('Invalid hash value: $value');
    }
    return Hash128(hexToBytes(value));
  }
  @override
  factory Hash128.fromParser(BinaryParser parser, [int? lengthHint]) {
    final numBytes = lengthHint ?? 16;
    final bytes = parser.read(numBytes);
    return Hash128(bytes);
  }
  @override
  String toString() {
    String hex = toHex();
    if (hex == '0' * hex.length) {
      return '';
    }
    return hex;
  }

  @override
  int getLength() {
    return 16;
  }
}
