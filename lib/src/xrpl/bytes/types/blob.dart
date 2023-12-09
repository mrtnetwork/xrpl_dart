part of 'package:xrp_dart/src/xrpl/bytes/serializer.dart';

class Blob extends SerializedType {
  Blob([super.buffer]);

  @override
  factory Blob.fromParser(BinaryParser parser, [int? lengthHint]) {
    return Blob(parser.read(lengthHint!));
  }

  @override
  factory Blob.fromValue(dynamic value) {
    if (value is! String) {
      throw XRPLBinaryCodecException(
          'Invalid type to construct a Blob: expected String, received ${value.runtimeType}.');
    }

    return Blob(BytesUtils.fromHexString(value));
  }
}
