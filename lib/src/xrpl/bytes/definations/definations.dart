import 'package:xrpl_dart/src/xrpl/exception/exceptions.dart';
import 'field.dart';
part 'defination_types.dart';

/// Class containing XRPL definitions and mapping methods
class XRPLDefinitions {
  static const String _fieldKey = 'FIELDS';
  static const String _transactionTypesKey = 'TRANSACTION_TYPES';
  static const String _transactionResultKey = 'TRANSACTION_RESULTS';
  static const String _ledgerEnteryTypesKey = 'LEDGER_ENTRY_TYPES';
  static const String _typesKey = 'TYPES';
  static const String _typeKey = 'type';
  static const String _nthKey = 'nth';

  /// Map transaction type codes to strings
  static Map<int, String> get _transactionTypeCodeToStrMap => Map.fromEntries(
      (_definationsFields[_transactionTypesKey] as Map<String, dynamic>)
          .entries
          .map((entry) => MapEntry(entry.value, entry.key)));

  /// Map transaction result codes to strings
  static Map<int, String> get _transactionResultsCodeToStrMap =>
      Map.fromEntries(_definationsFields[_transactionResultKey]
          .entries
          .map((entry) => MapEntry(entry.value, entry.key)));

  /// Map ledger entry types codes to strings
  static Map<int, String> get _ledgerEntryTypesCodeToStrMap =>
      Map.fromEntries(_definationsFields[_ledgerEnteryTypesKey]
          .entries
          .map((entry) => MapEntry(entry.value, entry.key)));

  /// Map field types by field name
  static Map<String, int> get _typeOrdinalMap => _definationsFields[_typesKey];

  /// Get field type by field name
  static String getFieldTypeByName(String fieldName) {
    return _definationsFields[_fieldKey][fieldName][_typeKey];
  }

  /// Get the field type ID by field name
  static int getFieldTypeId(String fieldName) {
    final String fieldType = getFieldTypeByName(fieldName);
    final int? fieldTypeId = _typeOrdinalMap[fieldType];
    if (fieldTypeId == null) {
      throw const XRPLBinaryCodecException(
          'Field type codes in definitions.json must be ints.');
    }
    return fieldTypeId;
  }

  /// Get the field code by field name
  static int getFieldCode(String fieldName) {
    return _definationsFields[_fieldKey][fieldName][_nthKey];
  }

  /// Get field header from field name
  static FieldHeader getFieldHeaderFromName(String fieldName) {
    return FieldHeader(getFieldTypeId(fieldName), getFieldCode(fieldName));
  }

  /// Get field name from field header
  static String getFieldNameFromHeader(FieldHeader fieldHeader) {
    final findType = _typeOrdinalMap.keys.firstWhere(
        (element) => _typeOrdinalMap[element] == fieldHeader.typeCode);
    for (final i in (_definationsFields[_fieldKey] as Map).entries) {
      if (i.value[_nthKey] == fieldHeader.fieldCode &&
          i.value[_typeKey] == findType) {
        return i.key;
      }
    }
    throw const XRPLBinaryCodecException('fild does not exist.');
  }

  /// Get field instance by field name
  static FieldInstance getFieldInstance(String fieldName) {
    final FieldInfo info =
        FieldInfo.fromJson(_definationsFields[_fieldKey][fieldName]);

    final FieldHeader fieldHeader = getFieldHeaderFromName(fieldName);
    return FieldInstance(info, fieldName, fieldHeader);
  }

  /// Get transaction type code by transaction type name
  static int getTransactionTypeCode(String transactionType) {
    return _definationsFields[_transactionTypesKey][transactionType] as int;
  }

  /// Get transaction type name by transaction type code
  static String getTransactionTypeName(int transactionType) {
    return _transactionTypeCodeToStrMap[transactionType]!;
  }

  /// Get transaction result code by transaction result type name
  static int getTransactionResultCode(String transactionResultType) {
    return _definationsFields[_transactionResultKey][transactionResultType]
        as int;
  }

  /// Get transaction result name by transaction result type code
  static String getTransactionResultName(int transactionResultType) {
    return _transactionResultsCodeToStrMap[transactionResultType]!;
  }

  /// Get ledger entry type code by ledger entry type name
  static int getLedgerEntryTypeCode(String ledgerEntryType) {
    return _definationsFields[_ledgerEnteryTypesKey][ledgerEntryType] as int;
  }

  /// Get ledger entry type name by ledger entry type code
  static String getLedgerEntryTypeName(int ledgerEntryType) {
    return _ledgerEntryTypesCodeToStrMap[ledgerEntryType]!;
  }
}
