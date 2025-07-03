import 'package:blockchain_utils/utils/numbers/utils/int_utils.dart';
import 'dart:math' as math;

import 'package:xrpl_dart/xrpl_dart.dart';

class AccountChannelsResult {
  final String account;
  final List<Channel> channels;
  final String ledgerHash;
  final int ledgerIndex;
  final bool? validated;
  final int? limit;
  final dynamic marker;

  AccountChannelsResult({
    required this.account,
    required this.channels,
    required this.ledgerHash,
    required this.ledgerIndex,
    this.validated,
    this.limit,
    this.marker,
  });

  factory AccountChannelsResult.fromJson(Map<String, dynamic> json) {
    return AccountChannelsResult(
      account: json['account'],
      channels:
          (json['channels'] as List).map((e) => Channel.fromJson(e)).toList(),
      ledgerHash: json['ledger_hash'],
      ledgerIndex: json['ledger_index'],
      validated: json['validated'],
      limit: json['limit'],
      marker: json['marker'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'channels': channels.map((e) => e.toJson()).toList(),
      'ledger_hash': ledgerHash,
      'ledger_index': ledgerIndex,
      'validated': validated,
      'limit': limit,
      'marker': marker,
    };
  }
}

class Channel {
  final String account;
  final String amount;
  final String balance;
  final String channelId;
  final String destinationAccount;
  final int settleDelay;
  final String? publicKey;
  final String? publicKeyHex;
  final int? expiration;
  final int? cancelAfter;
  final int? sourceTag;
  final int? destinationTag;

  const Channel({
    required this.account,
    required this.amount,
    required this.balance,
    required this.channelId,
    required this.destinationAccount,
    required this.settleDelay,
    this.publicKey,
    this.publicKeyHex,
    this.expiration,
    this.cancelAfter,
    this.sourceTag,
    this.destinationTag,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      account: json['account'],
      amount: json['amount'],
      balance: json['balance'],
      channelId: json['channel_id'],
      destinationAccount: json['destination_account'],
      settleDelay: json['settle_delay'],
      publicKey: json['public_key'],
      publicKeyHex: json['public_key_hex'],
      expiration: json['expiration'],
      cancelAfter: json['cancel_after'],
      sourceTag: json['source_tag'],
      destinationTag: json['destination_tag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'amount': amount,
      'balance': balance,
      'channel_id': channelId,
      'destination_account': destinationAccount,
      'settle_delay': settleDelay,
      'public_key': publicKey,
      'public_key_hex': publicKeyHex,
      'expiration': expiration,
      'cancel_after': cancelAfter,
      'source_tag': sourceTag,
      'destination_tag': destinationTag,
    };
  }
}

class AccountCurrenciesResponse {
  final AccountCurrenciesResult result;

  AccountCurrenciesResponse({required this.result});

  factory AccountCurrenciesResponse.fromJson(Map<String, dynamic> json) {
    return AccountCurrenciesResponse(
      result: AccountCurrenciesResult.fromJson(json['result']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result.toJson(),
    };
  }
}

class AccountCurrenciesResult {
  final String? ledgerHash;
  final int ledgerIndex;
  final List<String> receiveCurrencies;
  final List<String> sendCurrencies;
  final bool validated;

  AccountCurrenciesResult({
    this.ledgerHash,
    required this.ledgerIndex,
    required this.receiveCurrencies,
    required this.sendCurrencies,
    required this.validated,
  });

  factory AccountCurrenciesResult.fromJson(Map<String, dynamic> json) {
    return AccountCurrenciesResult(
      ledgerHash: json['ledger_hash'],
      ledgerIndex: json['ledger_index'],
      receiveCurrencies: List<String>.from(json['receive_currencies']),
      sendCurrencies: List<String>.from(json['send_currencies']),
      validated: json['validated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ledger_hash': ledgerHash,
      'ledger_index': ledgerIndex,
      'receive_currencies': receiveCurrencies,
      'send_currencies': sendCurrencies,
      'validated': validated,
    };
  }
}

class AccountLinesTrustline {
  final String account;
  final String balance;
  final String currency;
  final String limit;
  final String limitPeer;
  final int qualityIn;
  final int qualityOut;
  final bool? noRipple;
  final bool? noRipplePeer;
  final bool? authorized;
  final bool? peerAuthorized;
  final bool? freeze;
  final bool? freezePeer;

  const AccountLinesTrustline({
    required this.account,
    required this.balance,
    required this.currency,
    required this.limit,
    required this.limitPeer,
    required this.qualityIn,
    required this.qualityOut,
    this.noRipple,
    this.noRipplePeer,
    this.authorized,
    this.peerAuthorized,
    this.freeze,
    this.freezePeer,
  });

  factory AccountLinesTrustline.fromJson(Map<String, dynamic> json) {
    return AccountLinesTrustline(
      account: json['account'],
      balance: json['balance'],
      currency: json['currency'],
      limit: json['limit'],
      limitPeer: json['limit_peer'],
      qualityIn: json['quality_in'],
      qualityOut: json['quality_out'],
      noRipple: json['no_ripple'],
      noRipplePeer: json['no_ripple_peer'],
      authorized: json['authorized'],
      peerAuthorized: json['peer_authorized'],
      freeze: json['freeze'],
      freezePeer: json['freeze_peer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'balance': balance,
      'currency': currency,
      'limit': limit,
      'limit_peer': limitPeer,
      'quality_in': qualityIn,
      'quality_out': qualityOut,
      'no_ripple': noRipple,
      'no_ripple_peer': noRipplePeer,
      'authorized': authorized,
      'peer_authorized': peerAuthorized,
      'freeze': freeze,
      'freeze_peer': freezePeer,
    };
  }
}

class AccountLinesResult {
  final String account;
  final List<AccountLinesTrustline> lines;
  final int? ledgerCurrentIndex;
  final int? ledgerIndex;
  final String? ledgerHash;
  final dynamic marker;

  const AccountLinesResult(
      {required this.account,
      required this.lines,
      this.ledgerCurrentIndex,
      this.ledgerIndex,
      this.ledgerHash,
      this.marker});

  factory AccountLinesResult.fromJson(Map<String, dynamic> json) {
    return AccountLinesResult(
      account: json['account'],
      lines: (json['lines'] as List)
          .map((e) => AccountLinesTrustline.fromJson(e))
          .toList(),
      ledgerCurrentIndex: json['ledger_current_index'],
      ledgerIndex: json['ledger_index'],
      ledgerHash: json['ledger_hash'],
      marker: json['marker'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'lines': lines.map((e) => e.toJson()).toList(),
      'ledger_current_index': ledgerCurrentIndex,
      'ledger_index': ledgerIndex,
      'ledger_hash': ledgerHash,
      'marker': marker,
    };
  }
}

class AccountNFToken {
  final int flags;
  final String issuer;
  final String nfTokenId;
  final int nfTokenTaxon;
  final String? uri;
  final int nftSerial;

  AccountNFToken({
    required this.flags,
    required this.issuer,
    required this.nfTokenId,
    required this.nfTokenTaxon,
    this.uri,
    required this.nftSerial,
  });

  factory AccountNFToken.fromJson(Map<String, dynamic> json) {
    return AccountNFToken(
      flags: json['Flags'],
      issuer: json['Issuer'],
      nfTokenId: json['NFTokenID'],
      nfTokenTaxon: json['NFTokenTaxon'],
      uri: json['URI'],
      nftSerial: json['nft_serial'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Flags': flags,
      'Issuer': issuer,
      'NFTokenID': nfTokenId,
      'NFTokenTaxon': nfTokenTaxon,
      'URI': uri,
      'nft_serial': nftSerial,
    };
  }
}

class AccountNFTsResult {
  final String? account;
  final List<AccountNFToken> accountNfts;
  final String? ledgerHash;
  final int? ledgerIndex;
  final int? limit;
  final String? marker;
  final bool? validated;

  AccountNFTsResult({
    required this.account,
    required this.accountNfts,
    required this.validated,
    this.ledgerHash,
    this.ledgerIndex,
    this.limit,
    this.marker,
  });

  factory AccountNFTsResult.fromJson(Map<String, dynamic> json) {
    return AccountNFTsResult(
      account: json['account'],
      accountNfts: (json['account_nfts'] as List)
          .map((e) => AccountNFToken.fromJson(e))
          .toList(),
      validated: json['validated'],
      marker: json['marker'],
      limit: json['limit'],
      ledgerHash: json['ledger_hash'] as String?,
      ledgerIndex: json['ledger_index'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'account_nfts': accountNfts.map((e) => e.toJson()).toList(),
      'validated': validated,
      'marker': marker,
      'limit': limit,
      'ledger_index': ledgerIndex,
      'ledger_hash': ledgerHash,
    };
  }
}

class AccountObjectsResult {
  final String account;
  final List<LedgerEntry> accountObjects;
  final String? ledgerHash;
  final int? ledgerIndex;
  final int? ledgerCurrentIndex;
  final int? limit;
  final String? marker;
  final bool? validated;

  const AccountObjectsResult({
    required this.account,
    required this.accountObjects,
    this.ledgerHash,
    this.ledgerIndex,
    this.ledgerCurrentIndex,
    this.limit,
    this.marker,
    this.validated,
  });

  factory AccountObjectsResult.fromJson(Map<String, dynamic> json) {
    return AccountObjectsResult(
      account: json['account'] as String,
      accountObjects: (json['account_objects'] as List<dynamic>)
          .map((e) => LedgerEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      ledgerHash: json['ledger_hash'] as String?,
      ledgerIndex: json['ledger_index'] as int?,
      ledgerCurrentIndex: json['ledger_current_index'] as int?,
      limit: json['limit'] as int?,
      marker: json['marker'] as String?,
      validated: json['validated'] as bool?,
    );
  }
}

class AccountOffer {
  final int flags;
  final int seq;
  final BaseAmount takerGets;
  final BaseAmount takerPays;
  final String quality;
  final int? expiration;

  AccountOffer({
    required this.flags,
    required this.seq,
    required this.takerGets,
    required this.takerPays,
    required this.quality,
    this.expiration,
  });

  factory AccountOffer.fromJson(Map<String, dynamic> json) {
    return AccountOffer(
        flags: json['flags'] as int,
        seq: json['seq'] as int,
        takerGets: BaseAmount.fromJson(json['taker_gets']),
        takerPays: BaseAmount.fromJson(json['taker_pays']),
        quality: json['quality'] as String,
        expiration: json['expiration'] as int?);
  }
}

class AccountOffersResult {
  final String account;
  final List<AccountOffer>? offers;
  final int? ledgerCurrentIndex;
  final int? ledgerIndex;
  final String? ledgerHash;
  final dynamic marker;

  AccountOffersResult({
    required this.account,
    this.offers,
    this.ledgerCurrentIndex,
    this.ledgerIndex,
    this.ledgerHash,
    this.marker,
  });

  factory AccountOffersResult.fromJson(Map<String, dynamic> json) {
    return AccountOffersResult(
      account: json['account'] as String,
      offers: (json['offers'] as List?)
          ?.map((e) => AccountOffer.fromJson(e as Map<String, dynamic>))
          .toList(),
      ledgerCurrentIndex: json['ledger_current_index'] as int?,
      ledgerIndex: json['ledger_index'] as int?,
      ledgerHash: json['ledger_hash'] as String?,
      marker: json['marker'],
    );
  }
}

class AMMInfoResult {
  final AMMResult amm;
  final String? ledgerHash;
  final int? ledgerIndex;
  final bool? validated;

  AMMInfoResult({
    required this.amm,
    this.ledgerHash,
    this.ledgerIndex,
    this.validated,
  });

  factory AMMInfoResult.fromJson(Map<String, dynamic> json) {
    return AMMInfoResult(
      amm: AMMResult.fromJson(json['amm'] as Map<String, dynamic>),
      ledgerHash: json['ledger_hash'] as String?,
      ledgerIndex: json['ledger_index'] as int?,
      validated: json['validated'] as bool?,
    );
  }
}

class AMMResult {
  final String account;
  final BaseAmount amount;
  final BaseAmount amount2;
  final bool? assetFrozen;
  final bool? asset2Frozen;
  final AuctionSlotResult? auctionSlot;
  final IssuedCurrencyAmount lpToken;
  final int tradingFee;
  final List<VoteSlotResult>? voteSlots;

  AMMResult({
    required this.account,
    required this.amount,
    required this.amount2,
    this.assetFrozen,
    this.asset2Frozen,
    this.auctionSlot,
    required this.lpToken,
    required this.tradingFee,
    this.voteSlots,
  });

  factory AMMResult.fromJson(Map<String, dynamic> json) {
    return AMMResult(
      account: json['account'] as String,
      amount: BaseAmount.fromJson(json['amount']),
      amount2: BaseAmount.fromJson(json['amount2']),
      assetFrozen: json['asset_frozen'] as bool?,
      asset2Frozen: json['asset2_frozen'] as bool?,
      auctionSlot: json['auction_slot'] != null
          ? AuctionSlotResult.fromJson(json['auction_slot'])
          : null,
      lpToken: IssuedCurrencyAmount.fromJson(json['lp_token']),
      tradingFee: json['trading_fee'] as int,
      voteSlots: (json['vote_slots'] as List?)
          ?.map((e) => VoteSlotResult.fromJson(e))
          .toList(),
    );
  }
}

class AuctionSlotResult {
  final String account;
  final List<String> authAccounts;
  final int discountedFee;
  final String expiration;
  final IssuedCurrencyAmount price;
  final int timeInterval;

  AuctionSlotResult({
    required this.account,
    required this.authAccounts,
    required this.discountedFee,
    required this.expiration,
    required this.price,
    required this.timeInterval,
  });

  factory AuctionSlotResult.fromJson(Map<String, dynamic> json) {
    return AuctionSlotResult(
      account: json['account'] as String,
      authAccounts: (json['auth_accounts'] as List)
          .map((e) => e['account'] as String)
          .toList(),
      discountedFee: json['discounted_fee'] as int,
      expiration: json['expiration'] as String,
      price: IssuedCurrencyAmount.fromJson(json['price']),
      timeInterval: json['time_interval'] as int,
    );
  }
}

class VoteSlotResult {
  final String account;
  final int tradingFee;
  final int voteWeight;

  VoteSlotResult({
    required this.account,
    required this.tradingFee,
    required this.voteWeight,
  });

  factory VoteSlotResult.fromJson(Map<String, dynamic> json) {
    return VoteSlotResult(
      account: json['account'] as String,
      tradingFee: json['trading_fee'] as int,
      voteWeight: json['vote_weight'] as int,
    );
  }
}

class BookOffersResult {
  final int? ledgerCurrentIndex;
  final int? ledgerIndex;
  final String? ledgerHash;
  final List<BookOfferResult> offers;
  final bool? validated;

  BookOffersResult({
    this.ledgerCurrentIndex,
    this.ledgerIndex,
    this.ledgerHash,
    required this.offers,
    this.validated,
  });

  factory BookOffersResult.fromJson(Map<String, dynamic> json) {
    return BookOffersResult(
      ledgerCurrentIndex: json['ledger_current_index'] as int?,
      ledgerIndex: json['ledger_index'] as int?,
      ledgerHash: json['ledger_hash'] as String?,
      offers: (json['offers'] as List)
          .map((e) => BookOfferResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      validated: json['validated'] as bool?,
    );
  }
}

class BookOfferResult extends LedgerEntryOffer {
  final String? ownerFunds;
  final BaseAmount? takerGetsFunded;
  final BaseAmount? takerPaysFunded;
  final String? quality;

  BookOfferResult({
    this.quality,
    this.ownerFunds,
    this.takerGetsFunded,
    this.takerPaysFunded,
    required super.account,
    required super.bookDirectory,
    required super.bookNode,
    required super.expiration,
    required super.flags,
    required super.index,
    required super.ownerNode,
    required super.previousTxnID,
    required super.previousTxnLgrSeq,
    required super.sequence,
    required super.takerGets,
    required super.takerPays,
  });

  factory BookOfferResult.fromJson(Map<String, dynamic> json) {
    return BookOfferResult(
        flags: json['flags'] as int,
        takerGets: BaseAmount.fromJson(json['taker_gets']),
        takerPays: BaseAmount.fromJson(json['taker_pays']),
        account: json['Account'] as String,
        quality: json['quality'] as String?,
        ownerFunds: json['owner_funds'] as String?,
        takerGetsFunded: json['taker_gets_funded'] != null
            ? BaseAmount.fromJson(json['taker_gets_funded'])
            : null,
        takerPaysFunded: json['taker_pays_funded'] != null
            ? BaseAmount.fromJson(json['taker_pays_funded'])
            : null,
        sequence: json['Sequence'] as int,
        bookDirectory: json['BookDirectory'] as String,
        bookNode: json['BookNode'] as String,
        ownerNode: json['OwnerNode'] as String,
        expiration: json['Expiration'] as int?,
        previousTxnID: json["PreviousTxnID"],
        previousTxnLgrSeq: json["PreviousTxnLgrSeq"],
        index: json["index"]);
  }
}

class DepositAuthorizedResult {
  final bool depositAuthorized;
  final String destinationAccount;
  final String sourceAccount;
  final String? ledgerHash;
  final int? ledgerIndex;
  final int? ledgerCurrentIndex;
  final bool? validated;
  final List<String>? credentials;

  const DepositAuthorizedResult({
    required this.depositAuthorized,
    required this.destinationAccount,
    required this.sourceAccount,
    this.ledgerHash,
    this.ledgerIndex,
    this.ledgerCurrentIndex,
    this.validated,
    this.credentials,
  });

  factory DepositAuthorizedResult.fromJson(Map<String, dynamic> json) {
    return DepositAuthorizedResult(
      depositAuthorized: json['deposit_authorized'] as bool,
      destinationAccount: json['destination_account'] as String,
      sourceAccount: json['source_account'] as String,
      ledgerHash: json['ledger_hash'] as String?,
      ledgerIndex: json['ledger_index'] as int?,
      ledgerCurrentIndex: json['ledger_current_index'] as int?,
      validated: json['validated'] as bool?,
      credentials: (json['credentials'] as List?)?.cast<String>(),
    );
  }
}

enum XrplFeeType { open, minimum, dynamic }

class FeeResult {
  final int currentLedgerSize;
  final int currentQueueSize;
  final DropsResult drops;
  final int expectedLedgerSize;
  final int ledgerCurrentIndex;
  final LevelsResult levels;
  final int maxQueueSize;

  int getFeeType({XrplFeeType type = XrplFeeType.open}) {
    switch (type) {
      case XrplFeeType.open:
        return drops.openLedgerFee;
      case XrplFeeType.dynamic:
        return calculateFeeDynamically();
      case XrplFeeType.minimum:
        return drops.minimumFee;
    }
  }

  int calculateFeeDynamically() {
    final double queuePct = currentQueueSize / maxQueueSize;
    final int feeLow =
        (drops.minimumFee * 1.5).round().clamp(drops.minimumFee * 10, 1000);

    int possibleFeeMedium;
    if (queuePct > 0.1) {
      possibleFeeMedium =
          ((drops.minimumFee + drops.medianFee + drops.openLedgerFee) / 3)
              .round();
    } else if (queuePct == 0) {
      possibleFeeMedium = math.max(10 * drops.minimumFee, drops.openLedgerFee);
    } else {
      possibleFeeMedium = math.max(10 * drops.minimumFee,
          ((drops.minimumFee + drops.medianFee) / 2).round());
    }

    final int feeMedium =
        (possibleFeeMedium * 15).round().clamp(possibleFeeMedium, 10000);

    final int feeHigh = (math
            .max(10 * drops.minimumFee,
                (math.max(drops.medianFee, drops.openLedgerFee) * 1.1))
            .round())
        .clamp(10 * drops.minimumFee, 100000);

    int fee;
    if (queuePct == 0) {
      fee = feeLow;
    } else if (queuePct > 0 && queuePct < 1) {
      fee = feeMedium;
    } else {
      fee = feeHigh;
    }

    return fee;
  }

  const FeeResult({
    required this.currentLedgerSize,
    required this.currentQueueSize,
    required this.drops,
    required this.expectedLedgerSize,
    required this.ledgerCurrentIndex,
    required this.levels,
    required this.maxQueueSize,
  });

  factory FeeResult.fromJson(Map<String, dynamic> json) {
    return FeeResult(
      currentLedgerSize: IntUtils.parse(json['current_ledger_size']),
      currentQueueSize: IntUtils.parse(json['current_queue_size']),
      drops: DropsResult.fromJson(json['drops'] ?? {}),
      expectedLedgerSize: IntUtils.parse(json['expected_ledger_size']),
      ledgerCurrentIndex: IntUtils.parse(json['ledger_current_index']),
      levels: LevelsResult.fromJson(json['levels'] ?? {}),
      maxQueueSize: IntUtils.parse(json['max_queue_size']),
    );
  }
}

class DropsResult {
  final int baseFee;
  final int medianFee;
  final int minimumFee;
  final int openLedgerFee;

  const DropsResult({
    required this.baseFee,
    required this.medianFee,
    required this.minimumFee,
    required this.openLedgerFee,
  });

  factory DropsResult.fromJson(Map<String, dynamic> json) {
    return DropsResult(
      baseFee: IntUtils.parse(json['base_fee']),
      medianFee: IntUtils.parse(json['median_fee']),
      minimumFee: IntUtils.parse(json['minimum_fee']),
      openLedgerFee: IntUtils.parse(json['open_ledger_fee']),
    );
  }
}

class LevelsResult {
  final int medianLevel;
  final int minimumLevel;
  final int openLedgerLevel;
  final int referenceLevel;

  const LevelsResult({
    required this.medianLevel,
    required this.minimumLevel,
    required this.openLedgerLevel,
    required this.referenceLevel,
  });

  factory LevelsResult.fromJson(Map<String, dynamic> json) {
    return LevelsResult(
      medianLevel: IntUtils.parse(json['median_level']),
      minimumLevel: IntUtils.parse(json['minimum_level']),
      openLedgerLevel: IntUtils.parse(json['open_ledger_level']),
      referenceLevel: IntUtils.parse(json['reference_level']),
    );
  }
}

class GatewayBalanceResult {
  final String currency;
  final String value;

  const GatewayBalanceResult({
    required this.currency,
    required this.value,
  });

  factory GatewayBalanceResult.fromJson(Map<String, dynamic> json) {
    return GatewayBalanceResult(
        currency: json['currency'], value: json['value']);
  }
}

class GatewayBalancesResult {
  final String account;
  final Map<String, String>? obligations;
  final Map<String, List<GatewayBalanceResult>>? balances;
  final Map<String, List<GatewayBalanceResult>>? assets;
  final String? ledgerHash;
  final int? ledgerCurrentIndex;
  final int? ledgerIndex;

  GatewayBalancesResult({
    required this.account,
    this.obligations,
    this.balances,
    this.assets,
    this.ledgerHash,
    this.ledgerCurrentIndex,
    this.ledgerIndex,
  });

  factory GatewayBalancesResult.fromJson(Map<String, dynamic> json) {
    return GatewayBalancesResult(
      account: json['account'],
      obligations: (json['obligations'] as Map?)?.cast(),
      balances: (json['balances'] as Map<String, dynamic>?)?.map((k, v) =>
          MapEntry(
              k,
              (v as List)
                  .map((e) => GatewayBalanceResult.fromJson(e))
                  .toList())),
      assets: (json['assets'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(
          k,
          (v as List).map((e) => GatewayBalanceResult.fromJson(e)).toList())),
      ledgerHash: json['ledger_hash'],
      ledgerCurrentIndex: json['ledger_current_index'],
      ledgerIndex: json['ledger_index'],
    );
  }
}

class LedgerClosedResult {
  final String ledgerHash;
  final int ledgerIndex;

  LedgerClosedResult({required this.ledgerHash, required this.ledgerIndex});

  factory LedgerClosedResult.fromJson(Map<String, dynamic> json) {
    return LedgerClosedResult(
        ledgerHash: json['ledger_hash'], ledgerIndex: json['ledger_index']);
  }
  Map<String, dynamic> toJson() {
    return {"ledger_hash": ledgerHash, "ledger_index": ledgerIndex};
  }
}

class LedgerDataResult {
  final int ledgerIndex;
  final String ledgerHash;
  final List<LedgerDataLedgerState> state;
  final dynamic marker;
  final bool? validated;

  const LedgerDataResult({
    required this.ledgerIndex,
    required this.ledgerHash,
    required this.state,
    this.marker,
    this.validated,
  });

  factory LedgerDataResult.fromJson(Map<String, dynamic> json,
      {bool binary = false}) {
    return LedgerDataResult(
      ledgerIndex: json['ledger_index'],
      ledgerHash: json['ledger_hash'],
      state: (json['state'] as List<dynamic>)
          .map((e) => binary
              ? LedgerDataBinaryLedgerEntry.fromJson(json)
              : LedgerDataLabeledLedgerEntry.fromJson(e))
          .toList(),
      marker: json['marker'],
      validated: json['validated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ledger_index': ledgerIndex,
      'ledger_hash': ledgerHash,
      'state': state.map((e) => e.toJson()).toList(),
      'marker': marker,
      'validated': validated,
    };
  }
}

class LedgerEntryResult<T extends LedgerEntry> {
  final String index;
  final int ledgerCurrentIndex;
  final T? node;
  final String? nodeBinary;
  final bool? validated;
  final int? deletedLedgerIndex;

  LedgerEntryResult({
    required this.index,
    required this.ledgerCurrentIndex,
    this.node,
    this.nodeBinary,
    this.validated,
    this.deletedLedgerIndex,
  });

  factory LedgerEntryResult.fromJson(Map<String, dynamic> json) {
    return LedgerEntryResult<T>(
      index: json['index'],
      ledgerCurrentIndex: json['ledger_current_index'],
      node: json["node"] == null
          ? null
          : LedgerEntry.fromJson(json["node"]) as T?,
      nodeBinary: json['node_binary'],
      validated: json['validated'],
      deletedLedgerIndex: json['deleted_ledger_index'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'ledger_current_index': ledgerCurrentIndex,
      'node': node?.toJson(),
      'node_binary': nodeBinary,
      'validated': validated,
      'deleted_ledger_index': deletedLedgerIndex,
    };
  }
}

class ManifestResult {
  final ManifestDetailsResult? details;
  final String? manifest;
  final String requested;

  const ManifestResult({
    this.details,
    this.manifest,
    required this.requested,
  });

  factory ManifestResult.fromJson(Map<String, dynamic> json) {
    return ManifestResult(
      details: json['details'] != null
          ? ManifestDetailsResult.fromJson(json['details'])
          : null,
      manifest: json['manifest'],
      requested: json['requested'],
    );
  }

  Map<String, dynamic> toJson() => {
        'details': details?.toJson(),
        'manifest': manifest,
        'requested': requested,
      };
}

class ManifestDetailsResult {
  final String domain;
  final String ephemeralKey;
  final String masterKey;
  final int seq;

  ManifestDetailsResult({
    required this.domain,
    required this.ephemeralKey,
    required this.masterKey,
    required this.seq,
  });

  factory ManifestDetailsResult.fromJson(Map<String, dynamic> json) {
    return ManifestDetailsResult(
      domain: json['domain'],
      ephemeralKey: json['ephemeral_key'],
      masterKey: json['master_key'],
      seq: json['seq'],
    );
  }

  Map<String, dynamic> toJson() => {
        'domain': domain,
        'ephemeral_key': ephemeralKey,
        'master_key': masterKey,
        'seq': seq,
      };
}

class NFTBuyOffersResult {
  final List<NFTOffer> offers;
  final String nftId;

  NFTBuyOffersResult({
    required this.offers,
    required this.nftId,
  });

  factory NFTBuyOffersResult.fromJson(Map<String, dynamic> json) {
    return NFTBuyOffersResult(
      offers:
          (json['offers'] as List).map((e) => NFTOffer.fromJson(e)).toList(),
      nftId: json['nft_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'offers': offers.map((e) => e.toJson()).toList(),
        'nft_id': nftId,
      };
}

class BaseTransactionWithInfoResult extends ResponseOnlyTxInfo {
  final BaseTransaction transaction;

  BaseTransactionWithInfoResult.fromJson(super.json)
      : transaction = BaseTransaction.fromXrpl(json),
        super.fromJson();
  const BaseTransactionWithInfoResult(
      {required super.date,
      required super.hash,
      required super.ledgerIndex,
      required super.ledgerHash,
      required super.inLedger,
      required this.transaction});
}

class BaseTransactionWithHash {
  final BaseTransaction transaction;
  final String? hash;

  BaseTransactionWithHash.fromJson(Map<String, dynamic> json)
      : transaction = BaseTransaction.fromXrpl(json),
        hash = json["hash"];
  const BaseTransactionWithHash(
      {required this.hash, required this.transaction});
  Map<String, dynamic> toJson() {
    return {...transaction.toXrpl(), "hash": hash};
  }
}

class NFTHistoryTransactionResult {
  final int ledgerIndex;
  final String? metaBinary;
  final TransactionMetadataBase? meta;

  final BaseTransactionWithInfoResult? tx;
  final String? txBlob;
  final bool validated;

  const NFTHistoryTransactionResult({
    required this.ledgerIndex,
    required this.meta,
    this.metaBinary,
    this.tx,
    this.txBlob,
    required this.validated,
  });

  factory NFTHistoryTransactionResult.fromJson(Map<String, dynamic> json) {
    final tx = json['tx'] != null
        ? BaseTransactionWithInfoResult.fromJson(json['tx'])
        : null;
    return NFTHistoryTransactionResult(
        ledgerIndex: json['ledger_index'],
        meta: (json["meta"] is Map)
            ? TransactionMetadataBase.fromJson(
                json, tx?.transaction.transactionType)
            : null,
        metaBinary: (json["meta"] is String) ? json["meta"] : null,
        tx: json['tx'] != null
            ? BaseTransactionWithInfoResult.fromJson(json['tx'])
            : null,
        txBlob: json['tx_blob'],
        validated: json['validated']);
  }

  Map<String, dynamic> toJson() {
    return {
      'ledger_index': ledgerIndex,
      'meta': meta?.toJson() ?? metaBinary,
      'tx': tx?.toJson(),
      'tx_blob': txBlob,
      'validated': validated
    };
  }
}

class NFTHistoryResult {
  final String nftId;
  final int ledgerIndexMin;
  final int ledgerIndexMax;
  final int? limit;
  final dynamic marker;
  final List<NFTHistoryTransactionResult> transactions;
  final bool? validated;

  const NFTHistoryResult({
    required this.nftId,
    required this.ledgerIndexMin,
    required this.ledgerIndexMax,
    this.limit,
    this.marker,
    required this.transactions,
    this.validated,
  });

  factory NFTHistoryResult.fromJson(Map<String, dynamic> json) {
    final result = json['result'] as Map<String, dynamic>;
    return NFTHistoryResult(
      nftId: result['nft_id'],
      ledgerIndexMin: result['ledger_index_min'],
      ledgerIndexMax: result['ledger_index_max'],
      limit: result['limit'],
      marker: result['marker'],
      transactions: (result['transactions'] as List)
          .map((e) => NFTHistoryTransactionResult.fromJson(e))
          .toList(),
      validated: result['validated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': {
        'nft_id': nftId,
        'ledger_index_min': ledgerIndexMin,
        'ledger_index_max': ledgerIndexMax,
        'limit': limit,
        'marker': marker,
        'transactions': transactions.map((e) => e.toJson()).toList(),
        'validated': validated,
      }
    };
  }
}

class NFTSellOffersResult {
  final List<NFTOffer> offers;
  final String nftId;

  const NFTSellOffersResult({required this.offers, required this.nftId});

  factory NFTSellOffersResult.fromJson(Map<String, dynamic> json) {
    return NFTSellOffersResult(
      offers:
          (json['offers'] as List).map((e) => NFTOffer.fromJson(e)).toList(),
      nftId: json['nft_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offers': offers.map((e) => e.toJson()).toList(),
      'nft_id': nftId,
    };
  }
}

class NoRippleCheckResponse {
  final NoRippleCheckResult result;

  NoRippleCheckResponse({required this.result});

  factory NoRippleCheckResponse.fromJson(Map<String, dynamic> json) {
    return NoRippleCheckResponse(
      result: NoRippleCheckResult.fromJson(json['result']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result.toJson(),
    };
  }
}

class NoRippleCheckResult {
  final int ledgerCurrentIndex;
  final List<String> problems;
  final List<BaseTransactionWithInfoResult> transactions;

  NoRippleCheckResult({
    required this.ledgerCurrentIndex,
    required this.problems,
    required this.transactions,
  });

  factory NoRippleCheckResult.fromJson(Map<String, dynamic> json) {
    return NoRippleCheckResult(
      ledgerCurrentIndex: json['ledger_current_index'],
      problems: List<String>.from(json['problems']),
      transactions: (json['transactions'] as List)
          .map((e) => BaseTransactionWithInfoResult.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ledger_current_index': ledgerCurrentIndex,
      'problems': problems,
      'transactions': transactions.map((e) => e.toJson()).toList(),
    };
  }
}

class PathFindPathOption {
  final List<List<LedgerPathStep>> pathsComputed;
  final BaseAmount sourceAmount;
  final BaseAmount? destinationAmount;

  PathFindPathOption({
    required this.pathsComputed,
    required this.sourceAmount,
    this.destinationAmount,
  });

  factory PathFindPathOption.fromJson(Map<String, dynamic> json) {
    return PathFindPathOption(
      pathsComputed: (json['paths_computed'] as List)
          .map((e) =>
              (e as List).map((e) => LedgerPathStep.fromJson(e)).toList())
          .toList(),
      sourceAmount: BaseAmount.fromJson(json['source_amount']),
      destinationAmount: json['destination_amount'] != null
          ? BaseAmount.fromJson(json['destination_amount'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paths_computed':
          pathsComputed.map((e) => e.map((e) => e.toJson()).toList()).toList(),
      'source_amount': sourceAmount.toJson(),
      'destination_amount': destinationAmount?.toJson(),
    };
  }
}

class RipplePathFindPathOption {
  final List<List<LedgerPathStep>> pathsComputed;
  final BaseAmount sourceAmount;

  RipplePathFindPathOption({
    required this.pathsComputed,
    required this.sourceAmount,
  });

  factory RipplePathFindPathOption.fromJson(Map<String, dynamic> json) {
    return RipplePathFindPathOption(
      pathsComputed: (json['paths_computed'] as List)
          .map((e) =>
              (e as List).map((e) => LedgerPathStep.fromJson(e)).toList())
          .toList(),
      sourceAmount: BaseAmount.fromJson(json['source_amount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paths_computed':
          pathsComputed.map((e) => e.map((e) => e.toJson()).toList()).toList(),
      'source_amount': sourceAmount.toJson()
    };
  }
}

class PathFindResult {
  final List<PathFindPathOption> alternatives;
  final String destinationAccount;
  final BaseAmount destinationAmount;
  final String sourceAccount;
  final bool fullReply;
  final Object? id; // can be int or String
  final bool? closed;
  final bool? status;

  const PathFindResult({
    required this.alternatives,
    required this.destinationAccount,
    required this.destinationAmount,
    required this.sourceAccount,
    required this.fullReply,
    this.id,
    this.closed,
    this.status,
  });

  factory PathFindResult.fromJson(Map<String, dynamic> json) {
    return PathFindResult(
      alternatives: (json['alternatives'] as List)
          .map((e) => PathFindPathOption.fromJson(e))
          .toList(),
      destinationAccount: json['destination_account'],
      destinationAmount: BaseAmount.fromJson(json['destination_amount']),
      sourceAccount: json['source_account'],
      fullReply: json['full_reply'],
      id: json['id'],
      closed: json['closed'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alternatives': alternatives.map((e) => e.toJson()).toList(),
      'destination_account': destinationAccount,
      'destination_amount': destinationAmount.toJson(),
      'source_account': sourceAccount,
      'full_reply': fullReply,
      'id': id,
      'closed': closed,
      'status': status,
    };
  }
}

class PingResult {
  final String? role;
  final bool? unlimited;

  PingResult({this.role, this.unlimited});

  factory PingResult.fromJson(Map<String, dynamic> json) {
    return PingResult(
      role: json['role'],
      unlimited: json['unlimited'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'unlimited': unlimited,
    };
  }
}

class RipplePathFindResult {
  final List<RipplePathFindPathOption> alternatives;
  final String destinationAccount;
  final List<String> destinationCurrencies;
  final BaseAmount destinationAmount;
  final bool? fullReply;
  final dynamic id;
  final int? ledgerCurrentIndex;
  final String sourceAccount;
  final bool validated;

  RipplePathFindResult({
    required this.alternatives,
    required this.destinationAccount,
    required this.destinationCurrencies,
    required this.destinationAmount,
    this.fullReply,
    this.id,
    this.ledgerCurrentIndex,
    required this.sourceAccount,
    required this.validated,
  });

  factory RipplePathFindResult.fromJson(Map<String, dynamic> json) {
    return RipplePathFindResult(
      alternatives: (json['alternatives'] as List)
          .map((e) => RipplePathFindPathOption.fromJson(e))
          .toList(),
      destinationAccount: json['destination_account'],
      destinationCurrencies:
          (json['destination_currencies'] as List).cast<String>(),
      destinationAmount: BaseAmount.fromJson(json['destination_amount']),
      fullReply: json['full_reply'],
      id: json['id'],
      ledgerCurrentIndex: json['ledger_current_index'],
      sourceAccount: json['source_account'],
      validated: json['validated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alternatives': alternatives.map((e) => e.toJson()).toList(),
      'destination_account': destinationAccount,
      'destination_currencies': destinationCurrencies,
      'destination_amount': destinationAmount.toJson(),
      'full_reply': fullReply,
      'id': id,
      'ledger_current_index': ledgerCurrentIndex,
      'source_account': sourceAccount,
      'validated': validated,
    };
  }
}

class ServerDefinitionsResult {
  final String hash;
  final List<ServerFieldResult>? fields;
  final Map<String, int>? ledgerEntryTypes;
  final Map<String, int>? transactionResults;
  final Map<String, int>? transactionTypes;
  final Map<String, int>? types;

  ServerDefinitionsResult({
    required this.hash,
    this.fields,
    this.ledgerEntryTypes,
    this.transactionResults,
    this.transactionTypes,
    this.types,
  });

  factory ServerDefinitionsResult.fromJson(Map<String, dynamic> json) {
    return ServerDefinitionsResult(
      hash: json['hash'],
      fields: json['FIELDS'] != null
          ? (json['FIELDS'] as List)
              .map((e) => ServerFieldResult.fromJson(e))
              .toList()
          : null,
      ledgerEntryTypes: (json['LEDGER_ENTRY_TYPES'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v as int),
      ),
      transactionResults: (json['TRANSACTION_RESULTS'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v as int),
      ),
      transactionTypes: (json['TRANSACTION_TYPES'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v as int),
      ),
      types: (json['TYPES'] as Map?)?.map(
        (k, v) => MapEntry(k as String, v as int),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hash': hash,
      'FIELDS': fields?.map((e) => e.toJson()).toList(),
      'LEDGER_ENTRY_TYPES': ledgerEntryTypes,
      'TRANSACTION_RESULTS': transactionResults,
      'TRANSACTION_TYPES': transactionTypes,
      'TYPES': types,
    };
  }
}

class ServerFieldResult {
  final String name;
  final int nth;
  final bool isVLEncoded;
  final bool isSerialized;
  final bool isSigningField;
  final String type;

  ServerFieldResult({
    required this.name,
    required this.nth,
    required this.isVLEncoded,
    required this.isSerialized,
    required this.isSigningField,
    required this.type,
  });

  factory ServerFieldResult.fromJson(List<dynamic> json) {
    return ServerFieldResult(
      name: json[0],
      nth: json[1]['nth'],
      isVLEncoded: json[1]['isVLEncoded'],
      isSerialized: json[1]['isSerialized'],
      isSigningField: json[1]['isSigningField'],
      type: json[1]['type'],
    );
  }

  List<dynamic> toJson() {
    return [
      name,
      {
        'nth': nth,
        'isVLEncoded': isVLEncoded,
        'isSerialized': isSerialized,
        'isSigningField': isSigningField,
        'type': type,
      }
    ];
  }
}

class SubmitResult {
  bool get isSuccess => engineResult == 'tesSUCCESS';
  final String engineResult;
  final int engineResultCode;
  final String engineResultMessage;
  final String txBlob;
  final BaseTransactionWithHash txJson;
  final bool accepted;
  final int accountSequenceAvailable;
  final int accountSequenceNext;
  final bool applied;
  final bool broadcast;
  final bool kept;
  final bool queued;
  final String openLedgerCost;
  final int validatedLedgerIndex;

  SubmitResult({
    required this.engineResult,
    required this.engineResultCode,
    required this.engineResultMessage,
    required this.txBlob,
    required this.txJson,
    required this.accepted,
    required this.accountSequenceAvailable,
    required this.accountSequenceNext,
    required this.applied,
    required this.broadcast,
    required this.kept,
    required this.queued,
    required this.openLedgerCost,
    required this.validatedLedgerIndex,
  });

  factory SubmitResult.fromJson(Map<String, dynamic> json) {
    return SubmitResult(
      engineResult: json['engine_result'],
      engineResultCode: json['engine_result_code'],
      engineResultMessage: json['engine_result_message'],
      txBlob: json['tx_blob'],
      txJson: BaseTransactionWithHash.fromJson(json['tx_json']),
      accepted: json['accepted'],
      accountSequenceAvailable: json['account_sequence_available'],
      accountSequenceNext: json['account_sequence_next'],
      applied: json['applied'],
      broadcast: json['broadcast'],
      kept: json['kept'],
      queued: json['queued'],
      openLedgerCost: json['open_ledger_cost'],
      validatedLedgerIndex: json['validated_ledger_index'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'engine_result': engineResult,
      'engine_result_code': engineResultCode,
      'engine_result_message': engineResultMessage,
      'tx_blob': txBlob,
      'tx_json': txJson.toJson(),
      'accepted': accepted,
      'account_sequence_available': accountSequenceAvailable,
      'account_sequence_next': accountSequenceNext,
      'applied': applied,
      'broadcast': broadcast,
      'kept': kept,
      'queued': queued,
      'open_ledger_cost': openLedgerCost,
      'validated_ledger_index': validatedLedgerIndex,
    };
  }
}

class BaseSubmitMultisignedResult {
  final String engineResult;
  final int engineResultCode;
  final String engineResultMessage;
  final String txBlob;
  final String? hash;
  final BaseTransactionWithHash txJson;

  BaseSubmitMultisignedResult({
    required this.engineResult,
    required this.engineResultCode,
    required this.engineResultMessage,
    required this.txBlob,
    required this.txJson,
    this.hash,
  });

  factory BaseSubmitMultisignedResult.fromJson(Map<String, dynamic> json) {
    return BaseSubmitMultisignedResult(
        engineResult: json['engine_result'],
        engineResultCode: json['engine_result_code'],
        engineResultMessage: json['engine_result_message'],
        txBlob: json['tx_blob'],
        txJson: BaseTransactionWithHash.fromJson(json['tx_json']),
        hash: json["hash"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'engine_result': engineResult,
      'engine_result_code': engineResultCode,
      'engine_result_message': engineResultMessage,
      'tx_blob': txBlob,
      'tx_json': txJson.toJson(),
    };
  }
}

class TxResult {
  final String hash;
  final String? ctid;
  final int? ledgerIndex;
  final TransactionMetadataBase? metaBlob;
  final String? metaBlobBinary;
  final TransactionMetadataBase? meta;
  final String? metaBinary;
  final bool? validated;
  final String? closeTimeIso;
  final int? date;
  final BaseTransaction txJson;

  TxResult({
    required this.hash,
    this.ctid,
    this.ledgerIndex,
    this.metaBlob,
    this.meta,
    this.validated,
    this.closeTimeIso,
    this.date,
    this.metaBlobBinary,
    this.metaBinary,
    required this.txJson,
  });

  factory TxResult.fromJson(Map<String, dynamic> json) {
    final BaseTransaction txJson = json["tx_json"] != null
        ? BaseTransaction.fromXrpl(json["tx_json"])
        : BaseTransaction.fromXrpl(json);
    return TxResult(
        hash: json['hash'],
        ctid: json['ctid'],
        ledgerIndex: json['ledger_index'],
        metaBlob: json['meta_blob'] == null
            ? null
            : (json["meta_blob"] is Map)
                ? TransactionMetadataBase.fromJson(
                    json["meta_blob"], txJson.transactionType)
                : null,
        meta: json['meta'] == null
            ? null
            : (json["meta"] is Map)
                ? TransactionMetadataBase.fromJson(
                    json["meta"], txJson.transactionType)
                : null,
        metaBinary: (json["meta"] is String) ? json["meta"] : null,
        metaBlobBinary:
            (json["meta_blob"] is String) ? json["meta_blob"] : null,
        validated: json['validated'],
        closeTimeIso: json['close_time_iso'],
        date: json['date'],
        txJson: txJson);
  }

  Map<String, dynamic> toJson() {
    return {
      'hash': hash,
      'ctid': ctid,
      'ledger_index': ledgerIndex,
      'meta_blob': metaBlob?.toJson() ?? metaBlobBinary,
      'meta': meta?.toJson() ?? metaBinary,
      'validated': validated,
      'close_time_iso': closeTimeIso,
      'date': date,
      "tx_json": txJson.toJson()
    };
  }
}

class TransactionEntryResult {
  final String ledgerHash;
  final int ledgerIndex;
  final TransactionMetadata metadata;
  final BaseTransactionWithInfoResult txJson;

  TransactionEntryResult({
    required this.ledgerHash,
    required this.ledgerIndex,
    required this.metadata,
    required this.txJson,
  });

  factory TransactionEntryResult.fromJson(Map<String, dynamic> json) {
    final result = json['result'] as Map<String, dynamic>;
    return TransactionEntryResult(
      ledgerHash: result['ledger_hash'],
      ledgerIndex: result['ledger_index'],
      metadata: TransactionMetadata.fromJson(result['metadata']),
      txJson: BaseTransactionWithInfoResult.fromJson(result['tx_json']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': {
        'ledger_hash': ledgerHash,
        'ledger_index': ledgerIndex,
        'metadata': metadata.toJson(),
        'tx_json': txJson.toJson(),
      },
    };
  }
}

class NFTokenResult {
  final String nftId;
  final int ledgerIndex;
  final String owner;
  final bool isBurned;
  final int flags;
  final int transferFee;
  final String issuer;
  final int nftTaxon;
  final int nftSerial;
  final String uri;

  const NFTokenResult({
    required this.nftId,
    required this.ledgerIndex,
    required this.owner,
    required this.isBurned,
    required this.flags,
    required this.transferFee,
    required this.issuer,
    required this.nftTaxon,
    required this.nftSerial,
    required this.uri,
  });

  factory NFTokenResult.fromJson(Map<String, dynamic> json) => NFTokenResult(
        nftId: json['nft_id'],
        ledgerIndex: json['ledger_index'],
        owner: json['owner'],
        isBurned: json['is_burned'] as bool,
        flags: json['flags'],
        transferFee: json['transfer_fee'],
        issuer: json['issuer'],
        nftTaxon: json['nft_taxon'],
        nftSerial: json['nft_serial'],
        uri: json['uri'],
      );

  Map<String, dynamic> toJson() => {
        'nft_id': nftId,
        'ledger_index': ledgerIndex,
        'owner': owner,
        'is_burned': isBurned,
        'flags': flags,
        'transfer_fee': transferFee,
        'issuer': issuer,
        'nft_taxon': nftTaxon,
        'nft_serial': nftSerial,
        'uri': uri,
      };
}

class AccountTxTransactionResult {
  final String? hash;
  final int? ledgerIndex;
  final TransactionMetadataBase? meta;
  final String? metaBinary;
  final String? txBlob;
  final bool? validated;
  final BaseTransactionWithInfoResult? txJson;

  AccountTxTransactionResult({
    required this.hash,
    this.ledgerIndex,
    this.meta,
    this.validated,
    this.metaBinary,
    required this.txJson,
    required this.txBlob,
  });

  factory AccountTxTransactionResult.fromJson(Map<String, dynamic> json) {
    final BaseTransactionWithInfoResult? txJson = json["tx_json"] != null
        ? BaseTransactionWithInfoResult.fromJson(json["tx_json"])
        : json["tx"] == null
            ? null
            : BaseTransactionWithInfoResult.fromJson(json["tx"]);
    return AccountTxTransactionResult(
        hash: json['hash'],
        ledgerIndex: json['ledger_index'],
        meta: json['meta'] == null
            ? null
            : (json["meta"] is Map)
                ? TransactionMetadataBase.fromJson(
                    json["meta"], txJson?.transaction.transactionType)
                : null,
        metaBinary: (json["meta"] is String) ? json["meta"] : null,
        validated: json['validated'],
        txJson: txJson,
        txBlob: json["tx_blob"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'hash': hash,
      'tx_blob': txBlob,
      'ledger_index': ledgerIndex,
      'tx_json': txJson?.toJson(),
      'meta': meta?.toJson() ?? metaBinary,
      'validated': validated,
    };
  }
}

class AccountTxResult {
  /// Unique Address identifying the related account.
  final String account;

  /// The ledger index of the earliest ledger actually searched for transactions.
  final int ledgerIndexMin;

  /// The ledger index of the most recent ledger actually searched for transactions.
  final int ledgerIndexMax;

  /// The limit value used in the request.
  final int limit;

  /// Server-defined value indicating the response is paginated. Pass this to the next call to resume where this call left off.
  final dynamic marker;

  /// Array of transactions matching the request's criteria.
  final List<AccountTxTransactionResult> transactions;

  /// If true, the information in this response comes from a validated ledger version. Otherwise, the information is subject to change.
  final bool? validated;

  AccountTxResult({
    required this.account,
    required this.ledgerIndexMin,
    required this.ledgerIndexMax,
    required this.limit,
    required this.marker,
    required this.transactions,
    this.validated,
  });

  factory AccountTxResult.fromJson(Map<String, dynamic> json) {
    return AccountTxResult(
      account: json['account'],
      ledgerIndexMin: json['ledger_index_min'],
      ledgerIndexMax: json['ledger_index_max'],
      limit: json['limit'],
      marker: json['marker'],
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) =>
              AccountTxTransactionResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      validated: json['validated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'ledger_index_min': ledgerIndexMin,
      'ledger_index_max': ledgerIndexMax,
      'limit': limit,
      'marker': marker,
      'transactions': transactions.map((e) => e.toJson()).toList(),
      'validated': validated,
    };
  }
}

class AccountQueueTransaction {
  final bool authChange;
  final String fee;
  final String feeLevel;
  final String maxSpendDrops;
  final int seq;

  AccountQueueTransaction({
    required this.authChange,
    required this.fee,
    required this.feeLevel,
    required this.maxSpendDrops,
    required this.seq,
  });

  factory AccountQueueTransaction.fromJson(Map<String, dynamic> json) {
    return AccountQueueTransaction(
      authChange: json['auth_change'],
      fee: json['fee'],
      feeLevel: json['fee_level'],
      maxSpendDrops: json['max_spend_drops'],
      seq: json['seq'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'auth_change': authChange,
      'fee': fee,
      'fee_level': feeLevel,
      'max_spend_drops': maxSpendDrops,
      'seq': seq,
    };
  }
}

class AccountQueueData {
  final int txnCount;
  final bool? authChangeQueued;
  final int? lowestSequence;
  final int? highestSequence;
  final String? maxSpendDropsTotal;
  final List<AccountQueueTransaction>? transactions;

  AccountQueueData({
    required this.txnCount,
    this.authChangeQueued,
    this.lowestSequence,
    this.highestSequence,
    this.maxSpendDropsTotal,
    this.transactions,
  });

  factory AccountQueueData.fromJson(Map<String, dynamic> json) {
    return AccountQueueData(
      txnCount: json['txn_count'],
      authChangeQueued: json['auth_change_queued'],
      lowestSequence: json['lowest_sequence'],
      highestSequence: json['highest_sequence'],
      maxSpendDropsTotal: json['max_spend_drops_total'],
      transactions: json['transactions'] != null
          ? (json['transactions'] as List)
              .map((e) => AccountQueueTransaction.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'txn_count': txnCount,
      'auth_change_queued': authChangeQueued,
      'lowest_sequence': lowestSequence,
      'highest_sequence': highestSequence,
      'max_spend_drops_total': maxSpendDropsTotal,
      'transactions': transactions?.map((e) => e.toJson()).toList(),
    };
  }
}

class AccountInfoAccountFlags {
  final bool defaultRipple;
  final bool depositAuth;
  final bool disableMasterKey;
  final bool disallowIncomingCheck;
  final bool disallowIncomingNFTokenOffer;
  final bool disallowIncomingPayChan;
  final bool disallowIncomingTrustline;
  final bool disallowIncomingXRP;
  final bool globalFreeze;
  final bool noFreeze;
  final bool passwordSpent;
  final bool requireAuthorization;
  final bool requireDestinationTag;

  AccountInfoAccountFlags({
    required this.defaultRipple,
    required this.depositAuth,
    required this.disableMasterKey,
    required this.disallowIncomingCheck,
    required this.disallowIncomingNFTokenOffer,
    required this.disallowIncomingPayChan,
    required this.disallowIncomingTrustline,
    required this.disallowIncomingXRP,
    required this.globalFreeze,
    required this.noFreeze,
    required this.passwordSpent,
    required this.requireAuthorization,
    required this.requireDestinationTag,
  });

  factory AccountInfoAccountFlags.fromJson(Map<String, dynamic> json) {
    return AccountInfoAccountFlags(
      defaultRipple: json['defaultRipple'],
      depositAuth: json['depositAuth'],
      disableMasterKey: json['disableMasterKey'],
      disallowIncomingCheck: json['disallowIncomingCheck'],
      disallowIncomingNFTokenOffer: json['disallowIncomingNFTokenOffer'],
      disallowIncomingPayChan: json['disallowIncomingPayChan'],
      disallowIncomingTrustline: json['disallowIncomingTrustline'],
      disallowIncomingXRP: json['disallowIncomingXRP'],
      globalFreeze: json['globalFreeze'],
      noFreeze: json['noFreeze'],
      passwordSpent: json['passwordSpent'],
      requireAuthorization: json['requireAuthorization'],
      requireDestinationTag: json['requireDestinationTag'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'defaultRipple': defaultRipple,
      'depositAuth': depositAuth,
      'disableMasterKey': disableMasterKey,
      'disallowIncomingCheck': disallowIncomingCheck,
      'disallowIncomingNFTokenOffer': disallowIncomingNFTokenOffer,
      'disallowIncomingPayChan': disallowIncomingPayChan,
      'disallowIncomingTrustline': disallowIncomingTrustline,
      'disallowIncomingXRP': disallowIncomingXRP,
      'globalFreeze': globalFreeze,
      'noFreeze': noFreeze,
      'passwordSpent': passwordSpent,
      'requireAuthorization': requireAuthorization,
      'requireDestinationTag': requireDestinationTag,
    };
  }
}

class BaseAccountInfoResponse {
  final LedgerEntryAccountRoot accountData;
  final AccountInfoAccountFlags? accountFlags;
  final int? ledgerCurrentIndex;
  final int? ledgerIndex;
  final AccountQueueData? queueData;
  final bool? validated;
  final List<LedgerEntrySignerList>? signerList;

  const BaseAccountInfoResponse({
    required this.accountData,
    this.signerList,
    this.accountFlags,
    this.ledgerCurrentIndex,
    this.ledgerIndex,
    this.queueData,
    this.validated,
  });

  factory BaseAccountInfoResponse.fromJson(Map<String, dynamic> json) {
    return BaseAccountInfoResponse(
      accountData: LedgerEntryAccountRoot.fromJson(json['account_data']),
      accountFlags: json['account_flags'] != null
          ? AccountInfoAccountFlags.fromJson(json['account_flags'])
          : null,
      ledgerCurrentIndex: json['ledger_current_index'],
      ledgerIndex: json['ledger_index'],
      signerList: (json['signer_lists'] as List?)
          ?.map((e) => LedgerEntrySignerList.fromJson(e))
          .toList(),
      queueData: json['queue_data'] != null
          ? AccountQueueData.fromJson(json['queue_data'])
          : null,
      validated: json['validated'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_data': accountData.toJson(),
      'account_flags': accountFlags?.toJson(),
      'ledger_current_index': ledgerCurrentIndex,
      'ledger_index': ledgerIndex,
      'queue_data': queueData?.toJson(),
      'validated': validated,
      'signer_lists': signerList?.map((e) => e.toJson()).toList()
    };
  }
}
