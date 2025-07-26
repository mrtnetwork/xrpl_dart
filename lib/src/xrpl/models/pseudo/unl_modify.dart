import 'package:xrpl_dart/src/xrpl/models/base/pseudo_transaction.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

class UNLModify extends PseudoTransaction {
  final int ledgerSequence;
  final int unlModifyDisabling; // 0 or 1
  final String unlModifyValidator;

  UNLModify({
    required super.account,
    required this.ledgerSequence,
    required this.unlModifyDisabling,
    required this.unlModifyValidator,
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
  }) : super(transactionType: PseudoTransactionType.unlModify);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'ledger_sequence': ledgerSequence,
      'unl_modify_disabling': unlModifyDisabling,
      'unl_modify_validator': unlModifyValidator,
      ...super.toJson()
    }..removeWhere((_, v) => v == null);
  }

  UNLModify.fromJson(super.json)
      : ledgerSequence = json['ledger_sequence'],
        unlModifyDisabling = json['unl_modify_validator'],
        unlModifyValidator = json['unl_modify_validator'],
        super.json();
}
