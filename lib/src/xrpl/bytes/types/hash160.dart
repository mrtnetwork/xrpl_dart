part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class Hash160 extends Hash {
  static const int lengthBytes = 20;
  Hash160([List<int>? buffer])
      : super(buffer ?? List<int>.filled(0, lengthBytes));
  @override
  factory Hash160.fromValue(String value) {
    if (value.isEmpty) {
      throw XRPLBinaryCodecException('Invalid hash value: $value');
    }
    return Hash160(BytesUtils.fromHexString(value));
  }
  @override
  factory Hash160.fromParser(BinaryParser parser, [int? lengthHint]) {
    final numBytes = lengthHint ?? lengthBytes;
    final bytes = parser.read(numBytes);
    return Hash160(bytes);
  }
  @override
  int getLength() {
    return lengthBytes;
  }
}
