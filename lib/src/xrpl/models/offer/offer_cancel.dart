import 'package:xrp_dart/src/xrpl/models/xrp_transactions.dart';

/// import 'package:xrp_dart/src/xrpl/utilities.dart';
/// Represents an [OfferCancel](https://xrpl.org/offercancel.html) transaction,
/// which removes an Offer object from the [decentralized exchange](https://xrpl.org/decentralized-exchange.html)
class OfferCancel extends XRPTransaction {
  /// [offerSequence] The Sequence number (or Ticket number) of a previous OfferCreate
  /// transaction. If specified, cancel any Offer object in the ledger that was
  /// created by that transaction. It is not considered an error if the Offer
  /// specified does not exist.
  final int offerSequence;

  OfferCancel(
      {required String account,
      required this.offerSequence,
      List<XRPLMemo>? memos = const [],
      String signingPubKey = "",
      int? ticketSequance,
      BigInt? fee,
      int? lastLedgerSequence,
      int? sequence,
      List<XRPLSigners>? signers,
      dynamic flags,
      int? sourceTag,
      List<String> multiSigSigners = const []})
      : super(
            account: account,
            fee: fee,
            lastLedgerSequence: lastLedgerSequence,
            memos: memos,
            sequence: sequence,
            signers: signers,
            sourceTag: sourceTag,
            flags: flags,
            ticketSequance: ticketSequance,
            signingPubKey: signingPubKey,
            multiSigSigners: multiSigSigners,
            transactionType: XRPLTransactionType.offerCancel);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {"offer_sequence": offerSequence, ...super.toJson()};
  }

  OfferCancel.fromJson(Map<String, dynamic> json)
      : offerSequence = json["offer_sequence"],
        super.json(json);
}
