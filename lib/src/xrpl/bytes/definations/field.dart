import 'package:flutter/foundation.dart';

class FieldInfo {
  FieldInfo.fromJson(Map<String, dynamic> json)
      : nth = json["nth"],
        isVariableLengthEncoded = json["isVLEncoded"],
        isSerialized = json["isSerialized"],
        isSigningField = json["isSigningField"],
        type = json["type"];

  final int nth;
  final bool isVariableLengthEncoded;
  final bool isSerialized;
  final bool isSigningField;
  final String type;

  FieldInfo(this.nth, this.isVariableLengthEncoded, this.isSerialized,
      this.isSigningField, this.type);
}

class FieldHeader {
  FieldHeader.fromJson(Map<String, dynamic> json)
      : typeCode = json["type"],
        fieldCode = json["nth"];
  final int typeCode;
  final int fieldCode;
  FieldHeader(this.typeCode, this.fieldCode);
  @override
  operator ==(other) {
    if (other is! FieldHeader) {
      return false;
    }
    return other.typeCode == typeCode && other.fieldCode == fieldCode;
  }

  Uint8List toBytes() {
    final header = <int>[];
    if (typeCode < 16) {
      if (fieldCode < 16) {
        header.add((typeCode << 4) | fieldCode);
      } else {
        header.add(typeCode << 4);
        header.add(fieldCode);
      }
    } else if (fieldCode < 16) {
      header.addAll([fieldCode, typeCode]);
    } else {
      header.addAll([0, typeCode, fieldCode]);
    }

    return Uint8List.fromList(header);
  }

  @override
  int get hashCode => Object.hash(fieldCode, typeCode);
}

class FieldInstance {
  late int nth;
  late bool isVariableLengthEncoded;
  late bool isSerialized;
  late bool isSigning;
  late String type;
  late String name;
  late FieldHeader header;
  late int ordinal;
  FieldInstance(
      FieldInfo fieldInfo, String fieldName, FieldHeader fieldHeader) {
    nth = fieldInfo.nth;
    isVariableLengthEncoded = fieldInfo.isVariableLengthEncoded;
    isSerialized = fieldInfo.isSerialized;
    isSigning = fieldInfo.isSigningField;
    type = fieldInfo.type;
    name = fieldName;
    header = fieldHeader;
    ordinal = (header.typeCode << 16) | nth;
  }
}
