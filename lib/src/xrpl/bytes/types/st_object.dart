part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class _StObjectUtils {
  static const List<int> _objectEndMarkerByte = [0xE1];
  static const String _objectEndMarkerName = 'ObjectEndMarker';
  static const String _stObject = 'STObject';
  static const String _destination = 'Destination';
  static const String _account = 'Account';
  static const String _sourceTag = 'SourceTag';
  static const String _destTag = 'DestinationTag';
  static const String _unlModifyTx = '0066';

  static Map<String, dynamic> _handleXAddress(String field, String xaddress) {
    final address = XRPAddress.fromXAddress(xaddress);
    String? tagFieldName;
    if (field == _destination) {
      tagFieldName = _destTag;
    } else if (field == _account) {
      tagFieldName = _sourceTag;
    } else if (address.tag != null) {
      throw XRPLBinaryCodecException('$field cannot have an associated tag');
    }
    if (address.tag != null) {
      return {field: address.address, tagFieldName!: address.tag};
    }
    return {field: address.address};
  }

  static dynamic _strToEnum(String field, dynamic value) {
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

  static dynamic _enumToStr(dynamic field, dynamic value) {
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
}

class STObject extends SerializedType {
  STObject(super.buffer);
  factory STObject.fromParser(BinaryParser parser, [int? lengthHint]) {
    final serializer = BinarySerializer();

    while (!parser.isEnd()) {
      final field = parser.readField();

      try {
        if (field.name == _StObjectUtils._objectEndMarkerName) {
          break;
        }

        final associatedValue = parser.readFieldValue(field);
        serializer.writeFieldAndValue(field, associatedValue.toHex());

        if (field.type == _StObjectUtils._stObject) {
          serializer.append(_StObjectUtils._objectEndMarkerByte);
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
      case 'XChainBridge':
        return XChainBridge.fromParser(value, lengthHint);
      default:
        throw UnimplementedError('type not found $typeName');
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
      case 'XChainBridge':
        return XChainBridge.fromValue(value).toHex();
      default:
        throw UnimplementedError('type not found $typeName');
    }
  }

  factory STObject.fromValue(Map<String, dynamic> value,
      [bool onlySigning = false]) {
    final serializer = BinarySerializer();
    final xaddressDecoded = <String, dynamic>{};

    for (final entry in value.entries) {
      final k = entry.key;
      final v = entry.value;

      if (v is String && XRPAddressUtils.isXAddress(v)) {
        final handled = _StObjectUtils._handleXAddress(k, v);
        if (handled.containsKey(_StObjectUtils._sourceTag) &&
            handled[_StObjectUtils._sourceTag] != null &&
            value.containsKey(_StObjectUtils._sourceTag) &&
            value[_StObjectUtils._sourceTag] != null &&
            handled[_StObjectUtils._sourceTag] !=
                value[_StObjectUtils._sourceTag]) {
          throw const XRPLBinaryCodecException(
              'Cannot have mismatched Account X-Address and SourceTag');
        }

        if (handled.containsKey(_StObjectUtils._destTag) &&
            handled[_StObjectUtils._destTag] != null &&
            value.containsKey(_StObjectUtils._destTag) &&
            value[_StObjectUtils._destTag] != null &&
            handled[_StObjectUtils._destTag] !=
                value[_StObjectUtils._destTag]) {
          throw const XRPLBinaryCodecException(
              'Cannot have mismatched Destination X-Address and DestinationTag');
        }
        xaddressDecoded.addAll(handled);
      } else {
        xaddressDecoded[k] = _StObjectUtils._strToEnum(k, v);
      }
    }
    final sortedKeys = <FieldInstance>[];
    for (final name in xaddressDecoded.keys) {
      final fieldInstance = XRPLDefinitions.getFieldInstance(name);
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
        if (field.type == 'STObject') {
          associatedValue =
              STObject.fromValue(xaddressDecoded[field.name]).toHex();
        } else {
          associatedValue =
              fildTypeDecode(field.type, xaddressDecoded[field.name]);
        }
      } on XRPLBinaryCodecException {
        rethrow;
      }
      if (field.name == 'TransactionType' &&
          associatedValue == _StObjectUtils._unlModifyTx) {
        isUnlModify = true;
      }

      final isUnlModifyWorkaround = field.name == 'Account' && isUnlModify;
      serializer.writeFieldAndValue(field, associatedValue,
          isUnlModifyWorkaround: isUnlModifyWorkaround);
      if (field.type == _StObjectUtils._stObject) {
        serializer.append(_StObjectUtils._objectEndMarkerByte);
      }
    }
    return STObject(serializer.toBytes());
  }

  @override
  Map<String, dynamic> toJson() {
    final parser = BinaryParser(toBytes());
    final accumulator = <String, dynamic>{};

    while (!parser.isEnd()) {
      final field = parser.readField();

      try {
        if (field.name == _StObjectUtils._objectEndMarkerName) {
          break;
        }

        final jsonValue = parser.readFieldValue(field).toJson();
        accumulator[field.name] =
            _StObjectUtils._enumToStr(field.name, jsonValue);
      } catch (e) {
        rethrow;
      }
    }

    return accumulator;
  }
}
