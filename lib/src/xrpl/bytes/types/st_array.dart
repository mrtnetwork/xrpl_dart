part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class _StArrayConst {
  static const List<int> _arrayEndMarker = [0xF1];
  static const String _arrayEndMarkerName = 'ArrayEndMarker';
  static const List<int> _objectEndMarker = [0xE1];
}

class STArray extends SerializedType {
  STArray(super.buffer);

  factory STArray.fromParser(BinaryParser parser, [int? lengthHint]) {
    final BuBytes bytestring = BuBytes.empty();
    while (!parser.isEnd()) {
      final field = parser.readField();
      if (field.name == _StArrayConst._arrayEndMarkerName) {
        break;
      }
      bytestring.addAll(field.header.toBytes());
      bytestring.addAll(parser.readFieldValue(field)._buffer);
      bytestring.addAll(_StArrayConst._objectEndMarker);
    }
    bytestring.addAll(_StArrayConst._arrayEndMarker);
    return STArray(bytestring);
  }

  factory STArray.fromValue(List value) {
    if (value.isNotEmpty && value[0] is! Map) {
      throw const BuError(DefaultErrorType.invalidArgument, 
        'Cannot construct STArray from a list of non-map objects',
      );
    }
    final BuBytes bytestring = BuBytes.empty();
    for (final obj in value) {
      final transaction = STObject.fromValue(obj);
      bytestring.addAll(transaction.toBytes());
    }
    bytestring.addAll(_StArrayConst._arrayEndMarker);
    return STArray(bytestring);
  }

  @override
  List<dynamic> toJson() {
    final List<dynamic> result = [];
    final BinaryParser parser = BinaryParser(_buffer);

    while (!parser.isEnd()) {
      final field = parser.readField();
      if (field.name == _StArrayConst._arrayEndMarkerName) {
        break;
      }
      final outer = <String, dynamic>{};
      outer[field.name] = STObject.fromParser(parser).toJson();
      result.add(outer);
    }
    return result;
  }
}
