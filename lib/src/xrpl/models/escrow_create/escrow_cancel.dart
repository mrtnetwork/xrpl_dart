import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents an [EscrowCancel](https://xrpl.org/escrowcancel.html)
/// transaction, which returns escrowed XRP to the sender after the Escrow has
/// expired.
class EscrowCancel extends XRPTransaction {
  /// [owner] The address of the account that funded the Escrow.
  final String owner;

  /// [offerSequence] Transaction sequence (or Ticket number) of the EscrowCreate transaction that created the Escrow.
  final int offerSequence;

  EscrowCancel({
    required super.account,
    required this.owner,
    required this.offerSequence,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: XRPLTransactionType.escrowCancel);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {'owner': owner, 'offer_sequence': offerSequence, ...super.toJson()};
  }

  EscrowCancel.fromJson(super.json)
      : owner = json['owner'],
        offerSequence = json['offer_sequence'],
        super.json();
}
