import 'package:xrpl_dart/src/xrpl/models/base/pseudo_transaction.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

class EnableAmendment extends PseudoTransaction {
  final String amendment;
  final int ledgerSequence;

  EnableAmendment({
    required super.account,
    required this.amendment,
    required this.ledgerSequence,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: PseudoTransactionType.enableAmendment);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'amendment': amendment,
      'ledger_sequence': ledgerSequence,
      ...super.toJson()
    }..removeWhere((_, v) => v == null);
  }

  EnableAmendment.fromJson(super.json)
      : amendment = json['amendment'],
        ledgerSequence = json['ledger_sequence'],
        super.json();
}
