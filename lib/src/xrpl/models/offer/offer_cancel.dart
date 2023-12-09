import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// import 'package:xrp_dart/src/xrpl/utilities.dart';
/// Represents an [OfferCancel](https://xrpl.org/offercancel.html) transaction,
/// which removes an Offer object from the [decentralized exchange](https://xrpl.org/decentralized-exchange.html)
class OfferCancel extends XRPTransaction {
  final int offerSequence;

  /// [offerSequence] The Sequence number (or Ticket number) of a previous OfferCreate
  /// transaction. If specified, cancel any Offer object in the ledger that was
  /// created by that transaction. It is not considered an error if the Offer
  /// specified does not exist.
  OfferCancel({
    required super.account,
    required this.offerSequence,
    super.memos,
    super.ticketSequance,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  }) : super(transactionType: XRPLTransactionType.offerCancel);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "offer_sequence", offerSequence);
    return json;
  }

  OfferCancel.fromJson(super.json)
      : offerSequence = json["offer_sequence"],
        super.json();
}
