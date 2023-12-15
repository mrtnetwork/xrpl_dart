import 'package:xrp_dart/src/xrpl/exception/exceptions.dart';
import 'field.dart';
part 'defination_types.dart';

/// Class containing XRPL definitions and mapping methods
class XRPLDefinitions {
  static Map<String, dynamic> get fexx => _definationsFields;

  /// Map transaction type codes to strings
  static Map<int, String> get _transactionTypeCodeToStrMap => Map.fromEntries(
      (_definationsFields["TRANSACTION_TYPES"] as Map<String, dynamic>)
          .entries
          .map((entry) => MapEntry(entry.value, entry.key)));

  /// Map transaction result codes to strings
  static Map<int, String> get _transactionResultsCodeToStrMap =>
      Map.fromEntries(_definationsFields["TRANSACTION_RESULTS"]
          .entries
          .map((entry) => MapEntry(entry.value, entry.key)));

  /// Map ledger entry types codes to strings
  static Map<int, String> get _ledgerEntryTypesCodeToStrMap =>
      Map.fromEntries(_definationsFields["LEDGER_ENTRY_TYPES"]
          .entries
          .map((entry) => MapEntry(entry.value, entry.key)));

  /// Map field types by field name
  static Map<String, int> get _typeOrdinalMap => _definationsFields["TYPES"];

  /// Get field type by field name
  static String getFieldTypeByName(String fieldName) {
    return _definationsFields["FIELDS"][fieldName]["type"];
  }

  /// Get the field type ID by field name
  static int getFieldTypeId(String fieldName) {
    String fieldType = getFieldTypeByName(fieldName);
    int? fieldTypeId = _typeOrdinalMap[fieldType];
    if (fieldTypeId == null) {
      throw const XRPLBinaryCodecException(
          "Field type codes in definitions.json must be ints.");
    }
    return fieldTypeId;
  }

  /// Get the field code by field name
  static int getFieldCode(String fieldName) {
    return _definationsFields["FIELDS"][fieldName]["nth"];
  }

  /// Get field header from field name
  static FieldHeader getFieldHeaderFromName(String fieldName) {
    return FieldHeader(getFieldTypeId(fieldName), getFieldCode(fieldName));
  }

  /// Get field name from field header
  static String getFieldNameFromHeader(FieldHeader fieldHeader) {
    final findType = _typeOrdinalMap.keys.firstWhere(
        (element) => _typeOrdinalMap[element] == fieldHeader.typeCode);
    for (final i in (_definationsFields["FIELDS"] as Map).entries) {
      if (i.value["nth"] == fieldHeader.fieldCode &&
          i.value["type"] == findType) {
        return i.key;
      }
    }
    throw StateError("Cannot find fild name");
  }

  /// Get field instance by field name
  static FieldInstance getFieldInstance(String fieldName) {
    FieldInfo info =
        FieldInfo.fromJson(_definationsFields["FIELDS"][fieldName]);

    FieldHeader fieldHeader = getFieldHeaderFromName(fieldName);
    return FieldInstance(info, fieldName, fieldHeader);
  }

  /// Get transaction type code by transaction type name
  static int getTransactionTypeCode(String transactionType) {
    return _definationsFields["TRANSACTION_TYPES"][transactionType] as int;
  }

  /// Get transaction type name by transaction type code
  static String getTransactionTypeName(int transactionType) {
    return _transactionTypeCodeToStrMap[transactionType]!;
  }

  /// Get transaction result code by transaction result type name
  static int getTransactionResultCode(String transactionResultType) {
    return _definationsFields["TRANSACTION_RESULTS"][transactionResultType]
        as int;
  }

  /// Get transaction result name by transaction result type code
  static String getTransactionResultName(int transactionResultType) {
    return _transactionResultsCodeToStrMap[transactionResultType]!;
  }

  /// Get ledger entry type code by ledger entry type name
  static int getLedgerEntryTypeCode(String ledgerEntryType) {
    return _definationsFields["LEDGER_ENTRY_TYPES"][ledgerEntryType] as int;
  }

  /// Get ledger entry type name by ledger entry type code
  static String getLedgerEntryTypeName(int ledgerEntryType) {
    return _ledgerEntryTypesCodeToStrMap[ledgerEntryType]!;
  }
}
