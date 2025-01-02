part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class _StArrayConst {
  static const List<int> _arrayEndMarker = [0xF1];
  static const String _arrayEndMarkerName = 'ArrayEndMarker';
  static const List<int> _objectEndMarker = [0xE1];
}

class STArray extends SerializedType {
  STArray(super.buffer);

  @override
  factory STArray.fromParser(BinaryParser parser, [int? lengthHint]) {
    final DynamicByteTracker bytestring = DynamicByteTracker();
    while (!parser.isEnd()) {
      final field = parser.readField();
      if (field.name == _StArrayConst._arrayEndMarkerName) {
        break;
      }
      bytestring.add(field.header.toBytes());
      bytestring.add(parser.readFieldValue(field)._buffer);
      bytestring.add(_StArrayConst._objectEndMarker);
    }
    bytestring.add(_StArrayConst._arrayEndMarker);
    return STArray(bytestring.toBytes());
  }

  @override
  factory STArray.fromValue(List value) {
    if (value.isNotEmpty && value[0] is! Map) {
      throw const XRPLBinaryCodecException(
          'Cannot construct STArray from a list of non-map objects');
    }
    final DynamicByteTracker bytestring = DynamicByteTracker();
    for (final obj in value) {
      final transaction = STObject.fromValue(obj);
      bytestring.add(transaction.toBytes());
    }
    bytestring.add(_StArrayConst._arrayEndMarker);
    return STArray(bytestring.toBytes());
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
