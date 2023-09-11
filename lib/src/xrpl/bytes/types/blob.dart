part of 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';

class Blob extends SerializedType {
  Blob([Uint8List? buffer]) : super(buffer);

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

    return Blob(Uint8List.fromList(hexToBytes(value)));
  }
}
