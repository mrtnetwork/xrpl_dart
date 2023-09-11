import 'package:xrp_dart/src/xrpl/exception/exceptions.dart';
import 'field.dart';
part 'defination_types.dart';

class XRPLDefinitions {
  static Map<int, String> get _transactionTypeCodeToStrMap => Map.fromEntries(
      (_definationsFields["TRANSACTION_TYPES"] as Map<String, dynamic>)
          .entries
          .map((entry) => MapEntry(entry.value, entry.key)));
  static Map<int, String> get _transactionResultsCodeToStrMap =>
      Map.fromEntries(_definationsFields["TRANSACTION_RESULTS"]
          .entries
          .map((entry) => MapEntry(entry.value, entry.key)));
  static Map<int, String> get _ledgerEntryTypesCodeToStrMap =>
      Map.fromEntries(_definationsFields["LEDGER_ENTRY_TYPES"]
          .entries
          .map((entry) => MapEntry(entry.value, entry.key)));

  static Map<String, int> get _typeOrdinalMap => _definationsFields["TYPES"];

  static String getFieldTypeByName(String fieldName) {
    return _definationsFields["FIELDS"][fieldName]["type"];
  }

  static int getFieldTypeId(String fieldName) {
    String fieldType = getFieldTypeByName(fieldName);
    int? fieldTypeId = _typeOrdinalMap[fieldType];
    if (fieldTypeId == null) {
      throw XRPLBinaryCodecException(
          "Field type codes in definitions.json must be ints.");
    }
    return fieldTypeId;
  }

  static int getFieldCode(String fieldName) {
    return _definationsFields["FIELDS"][fieldName]["nth"];
  }

  static FieldHeader getFieldHeaderFromName(String fieldName) {
    return FieldHeader(getFieldTypeId(fieldName), getFieldCode(fieldName));
  }

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

  static FieldInstance getFieldInstance(String fieldName) {
    FieldInfo info =
        FieldInfo.fromJson(_definationsFields["FIELDS"][fieldName]);
    FieldHeader fieldHeader = getFieldHeaderFromName(fieldName);
    return FieldInstance(
      info,
      fieldName,
      fieldHeader,
    );
  }

  static int getTransactionTypeCode(String transactionType) {
    return _definationsFields["TRANSACTION_TYPES"][transactionType] as int;
  }

  static String getTransactionTypeName(int transactionType) {
    return _transactionTypeCodeToStrMap[transactionType]!;
  }

  static int getTransactionResultCode(String transactionResultType) {
    return _definationsFields["TRANSACTION_RESULTS"][transactionResultType]
        as int;
  }

  static String getTransactionResultName(int transactionResultType) {
    return _transactionResultsCodeToStrMap[transactionResultType]!;
  }

  static int getLedgerEntryTypeCode(String ledgerEntryType) {
    return _definationsFields["LEDGER_ENTRY_TYPES"][ledgerEntryType] as int;
  }

  static String getLedgerEntryTypeName(int ledgerEntryType) {
    return _ledgerEntryTypesCodeToStrMap[ledgerEntryType]!;
  }
}
