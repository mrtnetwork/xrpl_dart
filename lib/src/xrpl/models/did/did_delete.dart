import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents a DIDDelete transaction.
class DIDDelete extends XRPTransaction {
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
  }) : super(transactionType: XRPLTransactionType.didDelete);

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    return json;
  }
}
