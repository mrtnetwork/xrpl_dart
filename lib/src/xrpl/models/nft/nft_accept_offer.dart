import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// The NFTokenOfferAccept transaction is used to accept offers
/// to buy or sell an NFToken. It can either:
///
/// 1. Allow one offer to be accepted. This is called direct
///    mode.
/// 2. Allow two distinct offers, one offering to buy a
///    given NFToken and the other offering to sell the same
///    NFToken, to be accepted in an atomic fashion. This is
///    called brokered mode.
///
/// To indicate direct mode, use either the nftoken_sell_offer or
/// nftoken_buy_offer fields, but not both. To indicate brokered mode,
/// use both the nftoken_sell_offer and nftoken_buy_offer fields. If you use
/// neither nftoken_sell_offer nor nftoken_buy_offer, the transaction is invalid.
class NFTokenAcceptOffer extends XRPTransaction {
  /// [nfTokenSellOffer] Identifies the NFTokenOffer that offers to sell the NFToken.
  /// In direct mode this field is optional, but either NFTokenSellOffer or
  /// NFTokenBuyOffer must be specified. In brokered mode, both NFTokenSellOffer
  /// and NFTokenBuyOffer must be specified.
  final String? nfTokenSellOffer;

  /// [nfTokenBuyOffer] Identifies the NFTokenOffer that offers to buy the NFToken.
  /// In direct mode this field is optional, but either NFTokenSellOffer or
  /// NFTokenBuyOffer must be specified. In brokered mode, both NFTokenSellOffer
  /// and NFTokenBuyOffer must be specified.
  final String? nfTokenBuyOffer;

  /// [nfTokenBrokerFee] This field is only valid in brokered mode. It specifies the
  /// amount that the broker will keep as part of their fee for
  /// bringing the two offers together; the remaining amount will
  /// be sent to the seller of the NFToken being bought. If
  /// specified, the fee must be such that, prior to accounting
  /// for the transfer fee charged by the issuer, the amount that
  /// the seller would receive is at least as much as the amount
  /// indicated in the sell offer.
  ///
  /// This functionality is intended to allow the owner of an
  /// NFToken to offer their token for sale to a third party
  /// broker, who may then attempt to sell the NFToken on for a
  /// larger amount, without the broker having to own the NFToken
  /// or custody funds.
  ///
  /// Note: in brokered mode, the offers referenced by NFTokenBuyOffer
  /// and NFTokenSellOffer must both specify the same TokenID; that is,
  /// both must be for the same NFToken.
  final CurrencyAmount? nfTokenBrokerFee;
  NFTokenAcceptOffer({
    required super.account,
    this.nfTokenBrokerFee,
    this.nfTokenBuyOffer,
    this.nfTokenSellOffer,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: XRPLTransactionType.nftokenAcceptOffer);

  @override
  String? get validate {
    if (nfTokenBrokerFee != null && nfTokenSellOffer == null) {
      return 'nfTokenSellOffer Must be set if using brokered mode';
    }
    if (nfTokenSellOffer == null && nfTokenBuyOffer == null) {
      return 'Must set either nfTokenBuyOffer or nfTokenSellOffer';
    }
    if (nfTokenBrokerFee != null && nfTokenBuyOffer == null) {
      return 'nfTokenBuyOffer Must be set if using brokered mode';
    }

    if (nfTokenBrokerFee != null) {
      if (nfTokenBrokerFee!.isNegative || nfTokenBrokerFee!.isZero) {
        return 'nfTokenBrokerFee Must be greater than 0; omit if there is no broker fee';
      }
    }

    return super.validate;
  }

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'nftoken_broker_fee': nfTokenBrokerFee,
      'nftoken_buy_offer': nfTokenBuyOffer,
      'nftoken_sell_offer': nfTokenSellOffer,
      ...super.toJson()
    };
  }

  NFTokenAcceptOffer.fromJson(super.json)
      : nfTokenBrokerFee = json['nftoken_broker_fee'],
        nfTokenBuyOffer = json['nftoken_buy_offer'],
        nfTokenSellOffer = json['nftoken_sell_offer'],
        super.json();
}
