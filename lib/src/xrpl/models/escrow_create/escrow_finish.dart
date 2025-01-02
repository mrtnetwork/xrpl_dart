import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents an [EscrowFinish](https://xrpl.org/escrowfinish.html)
/// transaction, delivers XRP from a held payment to the recipient.
class EscrowFinish extends XRPTransaction {
  /// [owner] The source account that funded the Escrow.
  final String owner;

  /// [offerSequence] Transaction sequence (or Ticket number) of the EscrowCreate transaction that created the Escrow.
  final int offerSequence;

  /// [condition] The previously-supplied [PREIMAGE-SHA-256 crypto-condition ](https://tools.ietf.org/html/draft-thomas-crypto-conditions-04#section-8.1.)
  /// of the Escrow, if any, as hexadecimal.
  final String? condition;

  /// [fulfillment] The previously-supplied [PREIMAGE-SHA-256 crypto-condition fulfillment](https://tools.ietf.org/html/draft-thomas-crypto-conditions-04#section-8.1.)
  /// of the Escrow, if any, as hexadecimal.
  final String? fulfillment;

  EscrowFinish({
    required super.account,
    required this.owner,
    required this.offerSequence,
    this.condition,
    this.fulfillment,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: XRPLTransactionType.escrowFinish);

  @override
  String? get validate {
    if ((condition == null && fulfillment != null) ||
        (condition != null && fulfillment == null)) {
      return 'condition and fulfillment must both be specified.';
    }
    return super.validate;
  }

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'owner': owner,
      'offer_sequence': offerSequence,
      'condition': condition,
      'fulfillment': fulfillment,
      ...super.toJson()
    };
  }

  EscrowFinish.fromJson(super.json)
      : owner = json['owner'],
        offerSequence = json['offer_sequence'],
        condition = json['condition'],
        fulfillment = json['fulfillment'],
        super.json();
}
