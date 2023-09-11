part of 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';

class Hash256 extends Hash {
  Hash256([Uint8List? buffer]) : super(buffer ?? Uint8List(32));

  @override
  int getLength() {
    return 32;
  }

  @override
  factory Hash256.fromValue(dynamic value) {
    if (value is! String || value.isEmpty) {
      throw XRPLBinaryCodecException('Invalid hash value: $value');
    }
    return Hash256(hexToBytes(value));
  }
  @override
  factory Hash256.fromParser(BinaryParser parser, [int? lengthHint]) {
    final numBytes = lengthHint ?? 32;
    final bytes = parser.read(numBytes);
    return Hash256(bytes);
  }
}
