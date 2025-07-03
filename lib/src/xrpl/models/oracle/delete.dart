import 'package:blockchain_utils/utils/numbers/utils/int_utils.dart';
import 'package:xrpl_dart/src/xrpl/models/base/submittable_transaction.dart';
import 'package:xrpl_dart/src/xrpl/models/base/transaction_types.dart';

/// Delete an Oracle ledger entry.
class OracleDelete extends SubmittableTransaction {
  /// A unique identifier of the price oracle for the Account.
  final int oracleDocumentId;

  OracleDelete({
    required this.oracleDocumentId,
    required super.account,
  }) : super(transactionType: SubmittableTransactionType.oracleDelete);

  OracleDelete.fromJson(super.json)
      : oracleDocumentId = IntUtils.parse(json["oracle_document_id"]),
        super.json();

  @override
  Map<String, dynamic> toJson() {
    return {
      "oracle_document_id": oracleDocumentId,
      ...super.toJson(),
    }..removeWhere((_, v) => v == null);
  }
}
