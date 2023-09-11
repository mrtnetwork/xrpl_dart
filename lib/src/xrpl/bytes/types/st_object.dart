// ignore_for_file: constant_identifier_names, non_constant_identifier_names
part of 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';

final Uint8List _objectEndMarkerByte = Uint8List.fromList([0xE1]);
const String _objectEndMarkerName = 'ObjectEndMarker';
const String _stObject = 'STObject';
const String _destination = 'Destination';
const String _account = 'Account';
const String _sourceTag = 'SourceTag';
const String _destTag = 'DestinationTag';
const String _unlModifyTx = '0066';

Map<String, dynamic> _handleXAddress(String field, String xaddress) {
  final classicAddressTag =
      XRPAddressUtilities.xAddressToClassicAddress(xaddress);
  final classicAddress = classicAddressTag.$1;
  final tag = classicAddressTag.$2;
  String? tagFieldName;
  if (field == _destination) {
    tagFieldName = _destTag;
  } else if (field == _account) {
    tagFieldName = _sourceTag;
  } else if (tag != null) {
    throw XRPLBinaryCodecException('$field cannot have an associated tag');
  }

  if (tag != null) {
    return {field: classicAddress, tagFieldName!: tag};
  }
  return {field: classicAddress};
}

dynamic _strToEnum(String field, dynamic value) {
  if (field == 'TransactionType') {
    return XRPLDefinitions.getTransactionTypeCode(value);
  }
  if (field == 'TransactionResult') {
    return XRPLDefinitions.getTransactionResultCode(value);
  }
  if (field == 'LedgerEntryType') {
    return XRPLDefinitions.getLedgerEntryTypeCode(value);
  }
  return value;
}

dynamic _enumToStr(String field, dynamic value) {
  if (field == 'TransactionType') {
    return XRPLDefinitions.getTransactionTypeName(value);
  }
  if (field == 'TransactionResult') {
    return XRPLDefinitions.getTransactionResultName(value);
  }
  if (field == 'LedgerEntryType') {
    return XRPLDefinitions.getLedgerEntryTypeName(value);
  }
  return value;
}

class STObject extends SerializedType {
  STObject([super.buffer]);
  factory STObject.fromParser(BinaryParser parser, [int? lengthHint]) {
    final serializer = BinarySerializer();

    while (!parser.isEnd()) {
      final field = parser.readField();

      try {
        if (field.name == _objectEndMarkerName) {
          break;
        }

        final associatedValue = parser.readFieldValue(field);
        serializer.writeFieldAndValue(field, associatedValue.toHex());

        if (field.type == _stObject) {
          serializer.append(_objectEndMarkerByte);
        }
      } catch (e) {
        rethrow;
      }
    }

    return STObject(serializer.toBytes());
  }
  static SerializedType readData(String typeName, BinaryParser value,
      [int? lengthHint]) {
    switch (typeName) {
      case 'AccountID':
        return AccountID.fromParser(value, lengthHint);
      case 'Amount':
        return Amount.fromParser(value, lengthHint);
      case 'Blob':
        return Blob.fromParser(value, lengthHint);
      case 'Currency':
        return Currency.fromParser(value, lengthHint);
      case 'Hash128':
        return Hash128.fromParser(value, lengthHint);
      case 'Hash160':
        return Hash160.fromParser(value, lengthHint);
      case 'Hash256':
        return Hash256.fromParser(value, lengthHint);
      case 'Issue':
        return Issue.fromParser(value, lengthHint);
      case 'PathSet':
        return PathSet.fromParser(value, lengthHint);
      case 'STObject':
        return STObject.fromParser(value, lengthHint);
      case 'STArray':
        return STArray.fromParser(value, lengthHint);
      case 'UInt8':
        return UInt8.fromParser(value, lengthHint);
      case 'UInt16':
        return UInt16.fromParser(value, lengthHint);
      case 'UInt32':
        return UInt32.fromParser(value, lengthHint);
      case 'UInt64':
        return UInt64.fromParser(value, lengthHint);
      case 'Vector256':
        return Vector256.fromParser(value, lengthHint);
      default:
        throw UnimplementedError("type not found $typeName"); // Type not found
    }
  }

  static String fildTypeDecode(String typeName, dynamic value) {
    switch (typeName) {
      case 'AccountID':
        return AccountID.fromValue(value).toHex();
      case 'Amount':
        return Amount.fromValue(value).toHex();
      case 'Blob':
        return Blob.fromValue(value).toHex();
      case 'Currency':
        return Currency.fromValue(value).toHex();
      case 'Hash128':
        return Hash128.fromValue(value).toHex();
      case 'Hash160':
        return Hash160.fromValue(value).toHex();
      case 'Hash256':
        return Hash256.fromValue(value).toHex();
      case 'Issue':
        return Issue.fromValue(value).toHex();
      case 'PathSet':
        return PathSet.fromValue(value).toHex();
      case 'STObject':
        return STObject.fromValue(value).toHex();
      case 'STArray':
        return STArray.fromValue(value).toHex();
      case 'UInt8':
        return UInt8.fromValue(value).toHex();
      case 'UInt16':
        return UInt16.fromValue(value).toHex();
      case 'UInt32':
        return UInt32.fromValue(value).toHex();
      case 'UInt64':
        return UInt64.fromValue(value).toHex();
      case 'Vector256':
        return Vector256.fromValue(value).toHex();
      default:
        throw UnimplementedError("type not found $typeName"); // Type not found
    }
  }

  factory STObject.fromValue(Map<String, dynamic> value,
      [bool onlySigning = false]) {
    final serializer = BinarySerializer();
    final xaddressDecoded = <String, dynamic>{};

    for (final entry in value.entries) {
      final k = entry.key;
      final v = entry.value;

      if (v is String && XRPAddressUtilities.isValidXAddress(v)) {
        final handled = _handleXAddress(k, v);

        if (handled.containsKey(_sourceTag) &&
            handled[_sourceTag] != null &&
            value.containsKey(_sourceTag) &&
            value[_sourceTag] != null &&
            handled[_sourceTag] != value[_sourceTag]) {
          throw XRPLBinaryCodecException(
              'Cannot have mismatched Account X-Address and SourceTag');
        }

        if (handled.containsKey(_destTag) &&
            handled[_destTag] != null &&
            value.containsKey(value) &&
            value[_destTag] != null &&
            handled[_destTag] != value[_destTag]) {
          throw XRPLBinaryCodecException(
              'Cannot have mismatched Destination X-Address and DestinationTag');
        }

        xaddressDecoded.addAll(handled);
      } else {
        xaddressDecoded[k] = _strToEnum(k, v);
      }
    }
    final sortedKeys = <FieldInstance>[];
    for (final field_name in xaddressDecoded.keys) {
      final fieldInstance = XRPLDefinitions.getFieldInstance(field_name);
      if (xaddressDecoded[fieldInstance.name] != null &&
          fieldInstance.isSerialized) {
        sortedKeys.add(fieldInstance);
      }
    }

    sortedKeys.sort((x, y) => x.ordinal.compareTo(y.ordinal));

    if (onlySigning) {
      sortedKeys.retainWhere((x) => x.isSigning);
    }

    bool isUnlModify = false;
    for (final field in sortedKeys) {
      String associatedValue;
      try {
        if (field.type == "STObject") {
          associatedValue =
              STObject.fromValue(xaddressDecoded[field.name]).toHex();
        } else {
          associatedValue =
              fildTypeDecode(field.type, xaddressDecoded[field.name]);
        }
      } on XRPLBinaryCodecException {
        rethrow;
      }
      if (field.name == 'TransactionType' && associatedValue == _unlModifyTx) {
        isUnlModify = true;
      }

      final isUnlModifyWorkaround = field.name == 'Account' && isUnlModify;
      serializer.writeFieldAndValue(field, associatedValue,
          isUnlModifyWorkaround: isUnlModifyWorkaround);
      if (field.type == _stObject) {
        serializer.append(_objectEndMarkerByte);
      }
    }
    return STObject(serializer.toBytes());
  }

  @override
  Map<String, dynamic> toJson() {
    final parser = BinaryParser(toString());
    final accumulator = <String, dynamic>{};

    while (!parser.isEnd()) {
      final field = parser.readField();

      try {
        if (field.name == _objectEndMarkerName) {
          break;
        }

        final jsonValue = parser.readFieldValue(field).toJson();
        accumulator[field.name] = _enumToStr(field.name, jsonValue);
      } catch (e) {
        rethrow;
      }
    }

    return accumulator;
  }
}
