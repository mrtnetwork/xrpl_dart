import 'package:xrp_dart/src/xrpl/models/xrp_transactions.dart';

/// Transactions of the OfferCreate type support additional values in the Flags field.
/// This enum represents those options.

/// See OfferCreate Flags [https://xrpl.org/offercreate.html#offercreate-flags](https://xrpl.org/offercreate.html#offercreate-flags)
class OfferCreateFlag implements FlagsInterface {
  // Indicates that the offer is passive.
  static const OfferCreateFlag tfPassive = OfferCreateFlag(0x00010000);

  // Indicates that the offer is Immediate or Cancel.
  static const OfferCreateFlag tfImmediateOrCancel =
      OfferCreateFlag(0x00020000);

  // Indicates that the offer is Fill or Kill.
  static const OfferCreateFlag tfFillOrKill = OfferCreateFlag(0x00040000);

  // Indicates that the offer is a sell offer.
  static const OfferCreateFlag tfSell = OfferCreateFlag(0x00080000);

  // The integer value associated with each flag.
  final int value;

  // Constructor for OfferCreateFlag.
  const OfferCreateFlag(this.value);

  @override
  int get id => value;
}

class OfferCreateFlagInterface {
  OfferCreateFlagInterface({
    required this.tfPassive,
    required this.tfImmediateOrCancel,
    required this.tfFillOrKill,
    required this.tfSell,
  });

  final bool tfPassive;
  final bool tfImmediateOrCancel;
  final bool tfFillOrKill;
  final bool tfSell;
}

/// Represents an  [OfferCreate](https://xrpl.org/offercreate.htm) transaction,
/// which executes a limit order in the decentralized exchange
/// [https://xrpl.org/decentralized-exchange.html](https://xrpl.org/decentralized-exchange.html) If the specified exchange
/// cannot be completely fulfilled, it creates an Offer object for the remainder.
/// Offers can be partially fulfilled.
class OfferCreate extends XRPTransaction {
  /// [takerGets] The amount and type of currency being provided by the sender of this transaction
  final CurrencyAmount takerGets;

  /// [takerPays] The amount and type of currency the sender of this transaction wants
  /// in exchange for the full taker_gets amount.
  final CurrencyAmount takerPays;

  /// [expiration] Time after which the offer is no longer active
  final int? expiration;

  /// [offerSequence] The Sequence number (or Ticket number) of a previous OfferCreate to cancel when placing this Offer
  final int? offerSequence;

  OfferCreate(
      {required String account,
      required this.takerGets,
      required this.takerPays,
      this.expiration,
      this.offerSequence,
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
            transactionType: XRPLTransactionType.offerCreate);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      "taker_gets": takerGets.toJson(),
      "taker_pays": takerPays.toJson(),
      "expiration": expiration,
      "offer_sequence": offerSequence,
      ...super.toJson()
    };
  }

  OfferCreate.fromJson(Map<String, dynamic> json)
      : takerGets = CurrencyAmount.fromJson(json["taker_gets"]),
        takerPays = CurrencyAmount.fromJson(json["taker_pays"]),
        expiration = json["expiration"],
        offerSequence = json["offer_sequence"],
        super.json(json);
}
