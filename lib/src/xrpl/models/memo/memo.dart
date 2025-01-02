import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// An arbitrary piece of data attached to a transaction. A transaction can
/// have multiple Memo objects as an array in the Memos field.
/// Must contain one or more of memo_data, memo_format, and
/// memo_type.
class XRPLMemo extends XRPLBase {
  XRPLMemo.fromJson(Map<String, dynamic> json)
      : memoData = json['memo']['memo_data'],
        memoFormat = json['memo']['memo_format'],
        memoType = json['memo']['memo_type'];

  XRPLMemo({this.memoData, this.memoFormat, this.memoType});

  /// [memoData] The data of the memo, as a hexadecimal string.
  final String? memoData;

  /// [memoFormat] The format of the memo, as a hexadecimal string. Conventionally, this should be the MIME type
  final String? memoFormat;

  /// [memoType] The type of the memo, as a hexadecimal string. Conventionally, this should be an RFC 5988 relation
  final String? memoType;

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'memo_data': memoData,
      'memo_format': memoFormat,
      'memo_type': memoType
    };
    return {'memo': json..removeWhere((key, value) => value == null)};
  }

  @override
  String? get validate {
    if (memoData == null && memoFormat == null && memoType == null) {
      return 'Memo must contain at least one field';
    }
    return super.validate;
  }
}
