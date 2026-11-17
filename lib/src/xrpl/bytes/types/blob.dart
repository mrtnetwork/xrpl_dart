part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class Blob extends SerializedType {
  Blob(super.buffer);

  factory Blob.fromParser(BinaryParser parser, [int? lengthHint]) {
    if (lengthHint == null) {
      throw const BuError(DefaultErrorType.invalidArgument, 
        'Cannot parse Blob: missing length hint.',
      );
    }
    return Blob(parser.read(lengthHint));
  }

  factory Blob.fromValue(String value) {
    List<int> bytes = [];
    try {
      bytes = BytesUtils.fromHexString(value);
    } catch (e) {
      bytes = StringUtils.encode(value);
    }
    return Blob(bytes);
  }
}
