// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:xrp_dart/src/xrpl/models/currencies/currencies.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// Transaction Flags for an NFTokenCreateOffer Transaction.
enum NFTokenCreateOfferFlag {
  TF_SELL_NFTOKEN(0x00000001);

  final int value;
  const NFTokenCreateOfferFlag(this.value);
}

class NFTokenCreateOfferFlagInterface {
  NFTokenCreateOfferFlagInterface(this.TF_SELL_NFTOKEN);
  final bool TF_SELL_NFTOKEN;
}

/// The NFTokenCreateOffer transaction creates either an offer to buy an
/// NFT the submitting account does not own, or an offer to sell an NFT
/// the submitting account does own.
class NFTokenCreateOffer extends XRPTransaction {
  /// [nftokenId] Identifies the TokenID of the NFToken object that the offer references.
  /// [amount] The amount must be non-zero, except when this is a sell
  /// offer and the asset is XRP. This would indicate that the current
  /// owner of the token is giving it away free, either to anyone at all,
  /// or to the account identified by the Destination field
  ///
  /// [owner] Indicates the AccountID of the account that owns the
  /// corresponding NFToken.

  /// If the offer is to buy a token, this field must be present
  /// and it must be different than Account (since an offer to
  /// buy a token one already holds is meaningless).

  /// If the offer is to sell a token, this field must not be
  /// present, as the owner is, implicitly, the same as Account
  /// (since an offer to sell a token one doesn't already hold
  /// is meaningless).
  ///
  /// [expiration] Indicates the time after which the offer will no longer be valid.
  /// [destination] If present, indicates that this offer may only be
  /// accepted by the specified account. Attempts by other
  /// accounts to accept this offer MUST fail.
  NFTokenCreateOffer(
      {required this.nftokenId,
      required this.amount,
      required super.account,
      required super.flags,
      super.memos,
      super.ticketSequance,
      super.signingPubKey,
      super.sequence,
      super.fee,
      super.lastLedgerSequence,
      this.owner,
      this.expiration,
      this.destination})
      : assert(destination != account && owner != account,
            "Must not be equal to the account"),
        super(transactionType: XRPLTransactionType.NFTOKEN_CREATE_OFFER);
  final String nftokenId;
  final CurrencyAmount amount;
  final String? owner;
  final int? expiration;
  final String? destination;
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "nftoken_id", nftokenId);
    addWhenNotNull(json, "amount", amount.toJson());
    addWhenNotNull(json, "owner", owner);
    addWhenNotNull(json, "expiration", expiration);
    addWhenNotNull(json, "destination", destination);
    return json;
  }

  NFTokenCreateOffer.fromJson(Map<String, dynamic> json)
      : nftokenId = json["nftoken_id"],
        amount = CurrencyAmount.fromJson(json["amount"]),
        owner = json["owner"],
        expiration = json["expiration"],
        destination = json["destination"],
        super.json(json);
}
