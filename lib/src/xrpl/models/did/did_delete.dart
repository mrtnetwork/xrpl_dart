import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents a DIDDelete transaction.
class DIDDelete extends SubmittableTransaction {
  DIDDelete.fromJson(super.json) : super.json();

  DIDDelete({
    required super.account,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
    super.accountTxId,
    super.delegate,
    super.networkId,
  }) : super(transactionType: SubmittableTransactionType.didDelete);

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    return json..removeWhere((_, v) => v == null);
  }
}
