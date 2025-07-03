part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class Hash128 extends Hash {
  static const int lengthInBytes = 16;
  Hash128([List<int>? buffer])
      : super(buffer ?? List<int>.filled(lengthInBytes, 0));
  @override
  factory Hash128.fromValue(String value) {
    return Hash128(BytesUtils.fromHexString(value));
  }
  @override
  factory Hash128.fromParser(BinaryParser parser, [int? lengthHint]) {
    final numBytes = lengthHint ?? lengthInBytes;
    final bytes = parser.read(numBytes);
    return Hash128(bytes);
  }

  @override
  int getLength() {
    return lengthInBytes;
  }
}
