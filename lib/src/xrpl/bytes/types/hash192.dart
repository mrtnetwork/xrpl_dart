part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class Hash192 extends Hash {
  static const int lengthInBytes = 24;
  Hash192([List<int>? buffer])
      : super(buffer ?? List<int>.filled(lengthInBytes, 0));
  @override
  factory Hash192.fromValue(String value) {
    if (value.isEmpty) {
      throw XRPLBinaryCodecException('Invalid hash value: $value');
    }
    return Hash192(BytesUtils.fromHexString(value));
  }
  @override
  factory Hash192.fromParser(BinaryParser parser, [int? lengthHint]) {
    final numBytes = lengthHint ?? lengthInBytes;
    final bytes = parser.read(numBytes);
    return Hash192(bytes);
  }

  @override
  int getLength() {
    return lengthInBytes;
  }
}
