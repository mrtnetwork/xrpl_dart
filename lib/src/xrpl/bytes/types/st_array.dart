part of 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';

const List<int> _arrayEndMarker = [0xF1];
const String _arrayEndMarkerName = 'ArrayEndMarker';
const List<int> _objectEndMarker = [0xE1];

class STArray extends SerializedType {
  STArray([Uint8List? buffer]) : super(buffer);

  @override
  factory STArray.fromParser(BinaryParser parser, [int? lengthHint]) {
    final DynamicByteTracker bytestring = DynamicByteTracker();
    try {
      while (!parser.isEnd()) {
        var field = parser.readField();
        if (field.name == _arrayEndMarkerName) {
          break;
        }
        bytestring.add(field.header.toBytes());
        bytestring.add(parser.readFieldValue(field).buffer);
        bytestring.add(_objectEndMarker);
      }
      bytestring.add(_arrayEndMarker);
      return STArray(bytestring.toBytes());
    } finally {
      bytestring.close();
    }
  }

  @override
  factory STArray.fromValue(dynamic value) {
    if (value is! List) {
      throw XRPLBinaryCodecException('Invalid type to construct a STArray:'
          ' expected list, received ${value.runtimeType}.');
    }
    if (value.isNotEmpty && value[0] is! Map) {
      throw XRPLBinaryCodecException(
          'Cannot construct STArray from a list of non-map objects');
    }
    final DynamicByteTracker bytestring = DynamicByteTracker();
    try {
      for (var obj in value) {
        var transaction = STObject.fromValue(obj);
        bytestring.add(transaction.toBytes());
      }
      bytestring.add(_arrayEndMarker);
      return STArray(bytestring.toBytes());
    } finally {
      bytestring.close();
    }
  }

  @override
  List<dynamic> toJson() {
    List<dynamic> result = [];
    final BinaryParser parser = BinaryParser.fromBuffer(buffer);

    while (!parser.isEnd()) {
      var field = parser.readField();
      if (field.name == _arrayEndMarkerName) {
        break;
      }

      var outer = <String, dynamic>{};
      outer[field.name] = STObject.fromParser(parser).toJson();
      result.add(outer);
    }
    return result;
  }
}
