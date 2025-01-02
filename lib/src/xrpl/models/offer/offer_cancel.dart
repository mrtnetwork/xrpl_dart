import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// import 'package:xrpl_dart/src/xrpl/utilities.dart';
/// Represents an [OfferCancel](https://xrpl.org/offercancel.html) transaction,
/// which removes an Offer object from the [decentralized exchange](https://xrpl.org/decentralized-exchange.html)
class OfferCancel extends XRPTransaction {
  /// [offerSequence] The Sequence number (or Ticket number) of a previous OfferCreate
  /// transaction. If specified, cancel any Offer object in the ledger that was
  /// created by that transaction. It is not considered an error if the Offer
  /// specified does not exist.
  final int offerSequence;

  OfferCancel({
    required super.account,
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
  }) : super(transactionType: XRPLTransactionType.offerCancel);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {'offer_sequence': offerSequence, ...super.toJson()};
  }

  OfferCancel.fromJson(super.json)
      : offerSequence = json['offer_sequence'],
        super.json();
}
