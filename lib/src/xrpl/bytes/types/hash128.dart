part of 'package:xrp_dart/src/xrpl/bytes/serializer.dart';

class Hash128 extends Hash {
  Hash128([List<int>? buffer]) : super(buffer ?? List<int>.filled(16, 0));
  @override
  factory Hash128.fromValue(dynamic value) {
    if (value is! String || value.isEmpty) {
      throw XRPLBinaryCodecException('Invalid hash value: $value');
    }
    return Hash128(BytesUtils.fromHexString(value));
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
