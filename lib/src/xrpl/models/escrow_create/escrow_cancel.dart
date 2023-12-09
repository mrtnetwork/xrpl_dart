import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';

import '../../utilities.dart';

/// Represents an [EscrowCancel](https://xrpl.org/escrowcancel.html)
/// transaction, which returns escrowed XRP to the sender after the Escrow has
/// expired.
class EscrowCancel extends XRPTransaction {
  /// [owner] The address of the account that funded the Escrow.
  /// [offerSequence] Transaction sequence (or Ticket number) of the EscrowCreate transaction that created the Escrow.
  EscrowCancel({
    required super.account,
    required this.owner,
    required this.offerSequence,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
    super.memos,
    super.ticketSequance,
  }) : super(transactionType: XRPLTransactionType.escrowCancel);
  final String owner;
  final int offerSequence;

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "owner", owner);
    addWhenNotNull(json, "offer_sequence", offerSequence);
    return json;
  }

  EscrowCancel.fromJson(super.json)
      : owner = json["owner"],
        offerSequence = json["offer_sequence"],
        super.json();
}
