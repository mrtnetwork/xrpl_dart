import 'package:xrp_dart/src/xrpl/models/currencies/currencies.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// Transactions of the OfferCreate type support additional values in the Flags field.
/// This enum represents those options.

/// `See OfferCreate Flags [https://xrpl.org/offercreate.html#offercreate-flags](https://xrpl.org/offercreate.html#offercreate-flags)
enum OfferCreateFlag {
  tfPassive(0x00010000),
  tfImmediateOrCancel(0x00020000),
  tfFillOrKill(0x00040000),
  tfSell(0x00080000);

  final int value;

  const OfferCreateFlag(this.value);
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
/// which executes a limit order in the `decentralized exchange
/// [https://xrpl.org/decentralized-exchange.html](https://xrpl.org/decentralized-exchange.html) If the specified exchange
/// cannot be completely fulfilled, it creates an Offer object for the remainder.
/// Offers can be partially fulfilled.
class OfferCreate extends XRPTransaction {
  final CurrencyAmount takerGets;
  final CurrencyAmount takerPays;
  final int? expiration;
  final int? offerSequence;

  /// [takerGets] The amount and type of currency being provided by the sender of this transaction
  /// [takerPays] The amount and type of currency the sender of this transaction wants
  /// in exchange for the full ``taker_gets`` amount.
  /// [expiration] Time after which the offer is no longer active
  /// [offerSequence] The Sequence number (or Ticket number) of a previous OfferCreate to cancel when placing this Offer
  OfferCreate({
    required super.account,
    required this.takerGets,
    required this.takerPays,
    super.memos,
    super.ticketSequance,
    this.expiration,
    this.offerSequence,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  }) : super(transactionType: XRPLTransactionType.offerCreate);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "taker_gets", takerGets.toJson());
    addWhenNotNull(json, "taker_pays", takerPays.toJson());
    addWhenNotNull(json, "expiration", expiration);
    addWhenNotNull(json, "offer_sequence", offerSequence);
    return json;
  }

  OfferCreate.fromJson(super.json)
      : takerGets = CurrencyAmount.fromJson(json["taker_gets"]),
        takerPays = CurrencyAmount.fromJson(json["taker_pays"]),
        expiration = json["expiration"],
        offerSequence = json["offer_sequence"],
        super.json();
}
