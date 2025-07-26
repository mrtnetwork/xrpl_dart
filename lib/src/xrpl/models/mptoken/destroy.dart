import 'package:xrpl_dart/src/xrpl/models/base/submittable_transaction.dart';
import 'package:xrpl_dart/src/xrpl/models/base/transaction_types.dart';

/// The MPTokenIssuanceDestroy transaction is used to remove an MPTokenIssuance object
/// from the directory node in which it is being held, effectively removing the token
/// from the ledger. If this operation succeeds, the corresponding
/// MPTokenIssuance is removed and the owner’s reserve requirement is reduced by one.
/// This operation must fail if there are any holders who have non-zero balances.
class MPTokenIssuanceDestroy extends SubmittableTransaction {
  /// Identifies the MPTokenIssuance object to be removed by the transaction.
  final String mptokenIssuanceId;
  MPTokenIssuanceDestroy({
    required this.mptokenIssuanceId,
    required super.account,
    super.lastLedgerSequence,
    super.flags,
    super.fee,
    super.accountTxId,
    super.delegate,
    super.memos,
    super.multisigSigners,
    super.networkId,
    super.sequence,
    super.signer,
    super.sourceTag,
    super.ticketSequance,
  }) : super(
            transactionType: SubmittableTransactionType.mpTokenIssuanceDestroy);

  MPTokenIssuanceDestroy.fromJson(super.json)
      : mptokenIssuanceId = json["mptoken_issuance_id"],
        super.json();

  @override
  Map<String, dynamic> toJson() {
    return {
      "mptoken_issuance_id": mptokenIssuanceId,
      ...super.toJson(),
    }..removeWhere((_, v) => v == null);
  }
}
