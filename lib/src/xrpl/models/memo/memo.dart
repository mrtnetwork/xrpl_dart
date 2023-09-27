import 'package:xrp_dart/src/xrpl/models/base/base.dart';

/// An arbitrary piece of data attached to a transaction. A transaction can
/// have multiple Memo objects as an array in the Memos field.
/// Must contain one or more of ``memo_data``, ``memo_format``, and
/// ``memo_type``.
class XRPLMemo extends XrplNestedModel {
  XRPLMemo.fromJson(Map<String, dynamic> json)
      : memoData = json["memo"]["memo_data"],
        memoFormat = json["memo"]["memo_format"],
        memoType = json["memo"]["memo_type"];

  /// [memoData] The data of the memo, as a hexadecimal string.
  /// [memoFormat] The format of the memo, as a hexadecimal string. Conventionally, this should be the `MIME type
  /// [memoType] The type of the memo, as a hexadecimal string. Conventionally, this should be an `RFC 5988 relation
  XRPLMemo({this.memoData, this.memoFormat, this.memoType});
  final String? memoData;
  final String? memoFormat;
  final String? memoType;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      "memo_data": memoData,
      "memo_format": memoFormat,
      "memo_type": memoType
    };
    return {"memo": json};
  }
}
