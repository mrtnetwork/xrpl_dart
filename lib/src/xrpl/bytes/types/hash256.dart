part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class Hash256 extends Hash {
  static const int lengthBytes = 32;
  Hash256([List<int>? buffer])
      : super(buffer ?? List<int>.filled(lengthBytes, 0));

  @override
  int getLength() {
    return 32;
  }

  @override
  factory Hash256.fromValue(String value) {
    if (value.isEmpty) {
      throw XRPLBinaryCodecException('Invalid hash value: $value');
    }
    return Hash256(BytesUtils.fromHexString(value));
  }
  @override
  factory Hash256.fromParser(BinaryParser parser, [int? lengthHint]) {
    final numBytes = lengthHint ?? lengthBytes;
    final bytes = parser.read(numBytes);
    return Hash256(bytes);
  }
}
