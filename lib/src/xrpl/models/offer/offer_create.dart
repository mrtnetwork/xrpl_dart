// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:xrp_dart/src/xrpl/models/currencies/currencies.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// Transactions of the OfferCreate type support additional values in the Flags field.
/// This enum represents those options.

/// `See OfferCreate Flags [https://xrpl.org/offercreate.html#offercreate-flags](https://xrpl.org/offercreate.html#offercreate-flags)
enum OfferCreateFlag {
  TF_PASSIVE(0x00010000),
  TF_IMMEDIATE_OR_CANCEL(0x00020000),
  TF_FILL_OR_KILL(0x00040000),
  TF_SELL(0x00080000);

  final int value;
  const OfferCreateFlag(this.value);
}

class OfferCreateFlagInterface {
  OfferCreateFlagInterface(
      {required this.TF_PASSIVE,
      required this.TF_IMMEDIATE_OR_CANCEL,
      required this.TF_FILL_OR_KILL,
      required this.TF_SELL});
  final bool TF_PASSIVE;
  final bool TF_IMMEDIATE_OR_CANCEL;
  final bool TF_FILL_OR_KILL;
  final bool TF_SELL;
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
  }) : super(transactionType: XRPLTransactionType.OFFER_CREATE);
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "taker_gets", takerGets.toJson());
    addWhenNotNull(json, "taker_pays", takerPays.toJson());
    addWhenNotNull(json, "expiration", expiration);
    addWhenNotNull(json, "offer_sequence", offerSequence);
    return json;
  }

  OfferCreate.fromJson(Map<String, dynamic> json)
      : takerGets = CurrencyAmount.fromJson(json["taker_gets"]),
        takerPays = CurrencyAmount.fromJson(json["taker_pays"]),
        expiration = json["expiration"],
        offerSequence = json["offer_sequence"],
        super.json(json);
}
