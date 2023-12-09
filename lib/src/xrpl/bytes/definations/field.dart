import 'package:blockchain_utils/blockchain_utils.dart';

/// Represents information about a field
class FieldInfo {
  /// Constructor to initialize directly with values
  FieldInfo(this.nth, this.isVariableLengthEncoded, this.isSerialized,
      this.isSigningField, this.type);

  /// Constructor to initialize from a JSON map
  FieldInfo.fromJson(Map<String, dynamic> json)
      : nth = json["nth"],
        isVariableLengthEncoded = json["isVLEncoded"],
        isSerialized = json["isSerialized"],
        isSigningField = json["isSigningField"],
        type = json["type"];

  /// The ordinal number of the field
  final int nth;

  /// Indicates if the field is variable length encoded
  final bool isVariableLengthEncoded;

  /// Indicates if the field is serialized
  final bool isSerialized;

  /// Indicates if the field is a signing field
  final bool isSigningField;

  /// The type of the field
  final String type;
}

/// Represents the header of a field
class FieldHeader {
  /// Constructor to initialize directly with type and field codes
  FieldHeader(this.typeCode, this.fieldCode);

  /// Constructor to initialize from a JSON map
  FieldHeader.fromJson(Map<String, dynamic> json)
      : typeCode = json["type"],
        fieldCode = json["nth"];

  /// The type code of the field
  final int typeCode;

  /// The field code of the field
  final int fieldCode;

  @override
  operator ==(other) {
    if (other is! FieldHeader) {
      return false;
    }
    return other.typeCode == typeCode && other.fieldCode == fieldCode;
  }

  /// Convert the field header to bytes
  List<int> toBytes() {
    final header = DynamicByteTracker();
    if (typeCode < 16) {
      if (fieldCode < 16) {
        header.add([(typeCode << 4) | fieldCode]);
      } else {
        header.add([typeCode << 4]);
        header.add([fieldCode]);
      }
    } else if (fieldCode < 16) {
      header.add([fieldCode, typeCode]);
    } else {
      header.add([0, typeCode, fieldCode]);
    }

    return header.toBytes();
  }

  @override
  int get hashCode => Object.hash(fieldCode, typeCode);
}

/// Represents an instance of a field
class FieldInstance {
  final int nth;
  final bool isVariableLengthEncoded;
  final bool isSerialized;
  final bool isSigning;
  final String type;
  final String name;
  final FieldHeader header;
  final int ordinal;

  const FieldInstance._(
      this.nth,
      this.isVariableLengthEncoded,
      this.isSerialized,
      this.isSigning,
      this.type,
      this.name,
      this.header,
      this.ordinal);

  factory FieldInstance(
      FieldInfo fieldInfo, String fieldName, FieldHeader fieldHeader) {
    final int nth = fieldInfo.nth;
    final FieldHeader header = fieldHeader;
    final int ordinal = (header.typeCode << 16) | nth;
    return FieldInstance._(
        nth,
        fieldInfo.isVariableLengthEncoded,
        fieldInfo.isSerialized,
        fieldInfo.isSigningField,
        fieldInfo.type,
        fieldName,
        header,
        ordinal);
  }
}
