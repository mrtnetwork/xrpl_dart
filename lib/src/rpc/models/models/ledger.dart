import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/exception/exception.dart';
import 'package:xrpl_dart/src/rpc/models/models/metadata.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

enum LedgerEntryType {
  accountRoot('AccountRoot'),
  amendments('Amendments'),
  mpTokenIssuance('MPTokenIssuance'),
  mpToken('MPToken'),
  nfTokenOffer('NFTokenOffer'),
  nfTokenPage('NFTokenPage'),
  amm('AMM'),
  did('DID'),
  bridge('Bridge'),
  check('Check'),
  credential('Credential'),
  delegate('Delegate'),
  depositPreauth('DepositPreauth'),
  directoryNode('DirectoryNode'),
  escrow('Escrow'),
  feeSettings('FeeSettings'),
  ledgerHashes('LedgerHashes'),
  negativeUnl('NegativeUNL'),
  offer('Offer'),
  oracle('Oracle'),
  payChannel('PayChannel'),
  permissionedDomain('PermissionedDomain'),
  rippleState('RippleState'),
  signerList('SignerList'),
  ticket('Ticket'),
  xChainOwnedClaimId('XChainOwnedClaimID'),
  xChainOwnedCreateAccountClaimId('XChainOwnedCreateAccountClaimID');

  final String value;
  const LedgerEntryType(this.value);

  static LedgerEntryType fromValue(String? value) {
    return LedgerEntryType.values.firstWhere((e) => e.value == value,
        orElse: () =>
            throw XRPLPluginException('Invalid LedgerEntryType value: $value'));
  }
}

abstract class BaseLedgerEntry {
  final String index;

  const BaseLedgerEntry({required this.index});

  Map<String, dynamic> toJson();
}

abstract class HasPreviousTxnID {
  final String previousTxnID;
  final int previousTxnLgrSeq;

  const HasPreviousTxnID({
    required this.previousTxnID,
    required this.previousTxnLgrSeq,
  });

  Map<String, dynamic> toJson();
}

abstract class HasOptionalPreviousTxnID {
  final String? previousTxnID;
  final int? previousTxnLgrSeq;

  const HasOptionalPreviousTxnID({this.previousTxnID, this.previousTxnLgrSeq});

  Map<String, dynamic> toJson();
}

class LedgerEntryAccountRoot extends BaseLedgerEntry
    implements HasPreviousTxnID, LedgerEntry {
  @override
  final String previousTxnID;
  @override
  final int previousTxnLgrSeq;

  @override
  String get ledgerEntryType => type.value;
  final String account;
  final String balance;
  final int flags;
  final int ownerCount;
  final int sequence;
  final String? accountTxnID;
  final String? ammID;
  final String? domain;
  final String? emailHash;
  final String? messageKey;
  final String? regularKey;
  final int? ticketCount;
  final int? tickSize;
  final int? transferRate;
  final String? walletLocator;
  final int? burnedNFTokens;
  final int? firstNFTokenSequence;
  final int? mintedNFTokens;
  final String? nfTokenMinter;

  LedgerEntryAccountRoot({
    required super.index,
    required this.previousTxnID,
    required this.previousTxnLgrSeq,
    required this.account,
    required this.balance,
    required this.flags,
    required this.ownerCount,
    required this.sequence,
    this.accountTxnID,
    this.ammID,
    this.domain,
    this.emailHash,
    this.messageKey,
    this.regularKey,
    this.ticketCount,
    this.tickSize,
    this.transferRate,
    this.walletLocator,
    this.burnedNFTokens,
    this.firstNFTokenSequence,
    this.mintedNFTokens,
    this.nfTokenMinter,
  });

  factory LedgerEntryAccountRoot.fromJson(Map<String, dynamic> json) {
    return LedgerEntryAccountRoot(
      index: json['index'],
      previousTxnID: json['PreviousTxnID'],
      previousTxnLgrSeq: json['PreviousTxnLgrSeq'],
      account: json['Account'],
      balance: json['Balance'],
      flags: json['Flags'],
      ownerCount: json['OwnerCount'],
      sequence: json['Sequence'],
      accountTxnID: json['AccountTxnID'],
      ammID: json['AMMID'],
      domain: json['Domain'],
      emailHash: json['EmailHash'],
      messageKey: json['MessageKey'],
      regularKey: json['RegularKey'],
      ticketCount: json['TicketCount'],
      tickSize: json['TickSize'],
      transferRate: json['TransferRate'],
      walletLocator: json['WalletLocator'],
      burnedNFTokens: json['BurnedNFTokens'],
      firstNFTokenSequence: json['FirstNFTokenSequence'],
      mintedNFTokens: json['MintedNFTokens'],
      nfTokenMinter: json['NFTokenMinter'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'PreviousTxnID': previousTxnID,
      'PreviousTxnLgrSeq': previousTxnLgrSeq,
      'LedgerEntryType': ledgerEntryType,
      'Account': account,
      'Balance': balance,
      'Flags': flags,
      'OwnerCount': ownerCount,
      'Sequence': sequence,
      'AccountTxnID': accountTxnID,
      'AMMID': ammID,
      'Domain': domain,
      'EmailHash': emailHash,
      'MessageKey': messageKey,
      'RegularKey': regularKey,
      'TicketCount': ticketCount,
      'TickSize': tickSize,
      'TransferRate': transferRate,
      'WalletLocator': walletLocator,
      'BurnedNFTokens': burnedNFTokens,
      'FirstNFTokenSequence': firstNFTokenSequence,
      'MintedNFTokens': mintedNFTokens,
      'NFTokenMinter': nfTokenMinter,
    };
  }

  @override
  LedgerEntryType get type => LedgerEntryType.accountRoot;
}

class AccountRootFlagsInterface {
  final bool? lsfPasswordSpent;
  final bool? lsfRequireDestTag;
  final bool? lsfRequireAuth;
  final bool? lsfDisallowXRP;
  final bool? lsfDisableMaster;
  final bool? lsfNoFreeze;
  final bool? lsfGlobalFreeze;
  final bool? lsfDefaultRipple;
  final bool? lsfDepositAuth;
  final bool? lsfAMM;
  final bool? lsfDisallowIncomingNFTokenOffer;
  final bool? lsfDisallowIncomingCheck;
  final bool? lsfDisallowIncomingPayChan;
  final bool? lsfDisallowIncomingTrustline;
  final bool? lsfAllowTrustLineClawback;

  AccountRootFlagsInterface({
    this.lsfPasswordSpent,
    this.lsfRequireDestTag,
    this.lsfRequireAuth,
    this.lsfDisallowXRP,
    this.lsfDisableMaster,
    this.lsfNoFreeze,
    this.lsfGlobalFreeze,
    this.lsfDefaultRipple,
    this.lsfDepositAuth,
    this.lsfAMM,
    this.lsfDisallowIncomingNFTokenOffer,
    this.lsfDisallowIncomingCheck,
    this.lsfDisallowIncomingPayChan,
    this.lsfDisallowIncomingTrustline,
    this.lsfAllowTrustLineClawback,
  });

  factory AccountRootFlagsInterface.fromJson(Map<String, dynamic> json) {
    return AccountRootFlagsInterface(
      lsfPasswordSpent: json['lsfPasswordSpent'] as bool?,
      lsfRequireDestTag: json['lsfRequireDestTag'] as bool?,
      lsfRequireAuth: json['lsfRequireAuth'] as bool?,
      lsfDisallowXRP: json['lsfDisallowXRP'] as bool?,
      lsfDisableMaster: json['lsfDisableMaster'] as bool?,
      lsfNoFreeze: json['lsfNoFreeze'] as bool?,
      lsfGlobalFreeze: json['lsfGlobalFreeze'] as bool?,
      lsfDefaultRipple: json['lsfDefaultRipple'] as bool?,
      lsfDepositAuth: json['lsfDepositAuth'] as bool?,
      lsfAMM: json['lsfAMM'] as bool?,
      lsfDisallowIncomingNFTokenOffer:
          json['lsfDisallowIncomingNFTokenOffer'] as bool?,
      lsfDisallowIncomingCheck: json['lsfDisallowIncomingCheck'] as bool?,
      lsfDisallowIncomingPayChan: json['lsfDisallowIncomingPayChan'] as bool?,
      lsfDisallowIncomingTrustline:
          json['lsfDisallowIncomingTrustline'] as bool?,
      lsfAllowTrustLineClawback: json['lsfAllowTrustLineClawback'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lsfPasswordSpent': lsfPasswordSpent,
      'lsfRequireDestTag': lsfRequireDestTag,
      'lsfRequireAuth': lsfRequireAuth,
      'lsfDisallowXRP': lsfDisallowXRP,
      'lsfDisableMaster': lsfDisableMaster,
      'lsfNoFreeze': lsfNoFreeze,
      'lsfGlobalFreeze': lsfGlobalFreeze,
      'lsfDefaultRipple': lsfDefaultRipple,
      'lsfDepositAuth': lsfDepositAuth,
      'lsfAMM': lsfAMM,
      'lsfDisallowIncomingNFTokenOffer': lsfDisallowIncomingNFTokenOffer,
      'lsfDisallowIncomingCheck': lsfDisallowIncomingCheck,
      'lsfDisallowIncomingPayChan': lsfDisallowIncomingPayChan,
      'lsfDisallowIncomingTrustline': lsfDisallowIncomingTrustline,
      'lsfAllowTrustLineClawback': lsfAllowTrustLineClawback,
    };
  }
}

class AccountRootFlags {
  static const int lsfPasswordSpent = 0x00010000;
  static const int lsfRequireDestTag = 0x00020000;
  static const int lsfRequireAuth = 0x00040000;
  static const int lsfDisallowXRP = 0x00080000;
  static const int lsfDisableMaster = 0x00100000;
  static const int lsfNoFreeze = 0x00200000;
  static const int lsfGlobalFreeze = 0x00400000;
  static const int lsfDefaultRipple = 0x00800000;
  static const int lsfDepositAuth = 0x01000000;
  static const int lsfAMM = 0x02000000;
  static const int lsfDisallowIncomingNFTokenOffer = 0x04000000;
  static const int lsfDisallowIncomingCheck = 0x08000000;
  static const int lsfDisallowIncomingPayChan = 0x10000000;
  static const int lsfDisallowIncomingTrustline = 0x20000000;
  static const int lsfAllowTrustLineClawback = 0x80000000;
}

class Majority {
  final String amendment;
  final int closeTime;

  const Majority({required this.amendment, required this.closeTime});

  factory Majority.fromJson(Map<String, dynamic> json) {
    return Majority(
      amendment: json["Majority"]['Amendment'],
      closeTime: json["Majority"]['CloseTime'],
    );
  }

  Map<String, dynamic> toJson() => {
        "Majority": {
          'Amendment': amendment,
          'CloseTime': closeTime,
        }
      };
}

class LedgerEntryAmendments extends BaseLedgerEntry
    implements HasOptionalPreviousTxnID, LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final List<String>? amendments;
  final List<Majority>? majorities;
  final int flags;
  @override
  final String? previousTxnID;
  @override
  final int? previousTxnLgrSeq;

  LedgerEntryAmendments({
    required super.index,
    required this.flags,
    this.amendments,
    this.majorities,
    this.previousTxnID,
    this.previousTxnLgrSeq,
  });

  factory LedgerEntryAmendments.fromJson(Map<String, dynamic> json) {
    return LedgerEntryAmendments(
      index: json['index'],
      flags: json['Flags'],
      amendments: (json['LedgerEntryAmendments'] as List?)?.cast<String>(),
      majorities: (json['Majorities'] as List?)
          ?.map((e) => Majority.fromJson(e as Map<String, dynamic>))
          .toList(),
      previousTxnID: json['PreviousTxnID'],
      previousTxnLgrSeq: json['PreviousTxnLgrSeq'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'PreviousTxnID': previousTxnID,
      'PreviousTxnLgrSeq': previousTxnLgrSeq,
      'index': index,
      'LedgerEntryType': ledgerEntryType,
      'Flags': flags,
      'LedgerEntryAmendments': amendments,
      'Majorities': majorities?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  LedgerEntryType get type => LedgerEntryType.amendments;
}

class Balance {
  final String currency;
  final String? issuer;
  final String value;

  Balance({
    required this.currency,
    this.issuer,
    required this.value,
  });

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
        currency: json['currency'],
        issuer: json['issuer'],
        value: json['value'],
      );

  Map<String, dynamic> toJson() => {
        'currency': currency,
        'issuer': issuer,
        'value': value,
      };
}

class Signer {
  final String account;
  final String txnSignature;
  final String signingPubKey;

  Signer({
    required this.account,
    required this.txnSignature,
    required this.signingPubKey,
  });

  factory Signer.fromJson(Map<String, dynamic> json) => Signer(
        account: json["Signer"]['Account'],
        txnSignature: json["Signer"]['TxnSignature'],
        signingPubKey: json["Signer"]['SigningPubKey'],
      );

  Map<String, dynamic> toJson() => {
        "Signer": {
          'Account': account,
          'TxnSignature': txnSignature,
          'SigningPubKey': signingPubKey,
        }
      };
}

class Memo {
  final String? memoData;
  final String? memoType;
  final String? memoFormat;

  const Memo({this.memoData, this.memoType, this.memoFormat});

  factory Memo.fromJson(Map<String, dynamic> json) => Memo(
        memoData: json["Memo"]['MemoData'],
        memoType: json["Memo"]['MemoType'],
        memoFormat: json["Memo"]['MemoFormat'],
      );

  Map<String, dynamic> toJson() => {
        "Memo": {
          'MemoData': memoData,
          'MemoType': memoType,
          'MemoFormat': memoFormat,
        }
      };
}

class LedgerPathStep {
  final String? account;
  final String? currency;
  final String? issuer;

  LedgerPathStep({
    this.account,
    this.currency,
    this.issuer,
  });

  factory LedgerPathStep.fromJson(Map<String, dynamic> json) => LedgerPathStep(
        account: json['account'],
        currency: json['currency'],
        issuer: json['issuer'],
      );

  Map<String, dynamic> toJson() => {
        'account': account,
        'currency': currency,
        'issuer': issuer,
      };
}

class LedgerSignerEntry {
  final String account;
  final int signerWeight;
  final String? walletLocator;

  const LedgerSignerEntry(
      {required this.account, required this.signerWeight, this.walletLocator});

  factory LedgerSignerEntry.fromJson(Map<String, dynamic> json) {
    final entry = json['SignerEntry'] as Map<String, dynamic>;
    return LedgerSignerEntry(
      account: entry['Account'],
      signerWeight: entry['SignerWeight'],
      walletLocator: entry['WalletLocator'],
    );
  }

  Map<String, dynamic> toJson() => {
        'SignerEntry': {
          'Account': account,
          'SignerWeight': signerWeight,
          'WalletLocator': walletLocator,
        },
      };
}

class ResponseOnlyTxInfo {
  final int? date;
  final String? hash;
  final int? ledgerIndex;
  final String? ledgerHash;
  final int? inLedger;

  const ResponseOnlyTxInfo(
      {this.date, this.hash, this.ledgerIndex, this.ledgerHash, this.inLedger});
  ResponseOnlyTxInfo.fromJson(Map<String, dynamic> json)
      : date = json["date"],
        hash = json["hash"],
        ledgerIndex = json["ledger_index"],
        ledgerHash = json["ledger_hash"],
        inLedger = json["inLedger"];

  Map<String, dynamic> toJson() => {
        'date': date,
        'hash': hash,
        'ledger_index': ledgerIndex,
        'ledger_hash': ledgerHash,
        'inLedger': inLedger,
      };
}

class NFTOffer {
  final BaseAmount amount;
  final int flags;
  final String nftOfferIndex;
  final String owner;
  final String? destination;
  final int? expiration;

  const NFTOffer({
    required this.amount,
    required this.flags,
    required this.nftOfferIndex,
    required this.owner,
    this.destination,
    this.expiration,
  });

  factory NFTOffer.fromJson(Map<String, dynamic> json) => NFTOffer(
        amount: BaseAmount.fromJson(json['amount']),
        flags: json['flags'],
        nftOfferIndex: json['nft_offer_index'],
        owner: json['owner'],
        destination: json['destination'],
        expiration: json['expiration'],
      );

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'flags': flags,
        'nft_offer_index': nftOfferIndex,
        'owner': owner,
        'destination': destination,
        'expiration': expiration,
      };
}

class LedgerAuthAccount {
  final String account;

  const LedgerAuthAccount({required this.account});

  factory LedgerAuthAccount.fromJson(Map<String, dynamic> json) {
    final authAccount = json['LedgerAuthAccount'] as Map<String, dynamic>;
    return LedgerAuthAccount(account: authAccount['Account']);
  }

  Map<String, dynamic> toJson() => {
        'LedgerAuthAccount': {
          'Account': account,
        },
      };
}

class AuthorizeCredential {
  final String issuer;
  final String credentialType;

  const AuthorizeCredential(
      {required this.issuer, required this.credentialType});

  factory AuthorizeCredential.fromJson(Map<String, dynamic> json) {
    final credential = json['Credential'] as Map<String, dynamic>;
    return AuthorizeCredential(
      issuer: credential['Issuer'],
      credentialType: credential['CredentialType'],
    );
  }

  Map<String, dynamic> toJson() => {
        'Credential': {
          'Issuer': issuer,
          'CredentialType': credentialType,
        },
      };
}

class LedgerXChainBridge {
  final String lockingChainDoor;
  final BaseCurrency lockingChainIssue;
  final String issuingChainDoor;
  final BaseCurrency issuingChainIssue;

  const LedgerXChainBridge({
    required this.lockingChainDoor,
    required this.lockingChainIssue,
    required this.issuingChainDoor,
    required this.issuingChainIssue,
  });

  factory LedgerXChainBridge.fromJson(Map<String, dynamic> json) =>
      LedgerXChainBridge(
        lockingChainDoor: json['LockingChainDoor'],
        lockingChainIssue: BaseCurrency.fromJson(json['LockingChainIssue']),
        issuingChainDoor: json['IssuingChainDoor'],
        issuingChainIssue: BaseCurrency.fromJson(json['IssuingChainIssue']),
      );

  Map<String, dynamic> toJson() => {
        'LockingChainDoor': lockingChainDoor,
        'LockingChainIssue': lockingChainIssue.toJson(),
        'IssuingChainDoor': issuingChainDoor,
        'IssuingChainIssue': issuingChainIssue.toJson(),
      };
}

class LedgerPriceData {
  final String baseAsset;
  final String quoteAsset;
  final dynamic assetPrice; // can be num or String
  final int? scale;

  const LedgerPriceData({
    required this.baseAsset,
    required this.quoteAsset,
    this.assetPrice,
    this.scale,
  });

  factory LedgerPriceData.fromJson(Map<String, dynamic> json) {
    final pd = json['PriceData'] as Map<String, dynamic>;
    return LedgerPriceData(
      baseAsset: pd['BaseAsset'],
      quoteAsset: pd['QuoteAsset'],
      assetPrice: pd['AssetPrice'],
      scale: pd['Scale'],
    );
  }

  Map<String, dynamic> toJson() => {
        'PriceData': {
          'BaseAsset': baseAsset,
          'QuoteAsset': quoteAsset,
          'AssetPrice': assetPrice,
          'Scale': scale,
        },
      };
}

class VoteSlot {
  final String account;
  final int? tradingFee;
  final int voteWeight;

  const VoteSlot({
    required this.account,
    required this.tradingFee,
    required this.voteWeight,
  });

  factory VoteSlot.fromJson(Map<String, dynamic> json) {
    final entry = json['VoteEntry'] as Map<String, dynamic>;
    return VoteSlot(
      account: entry['Account'],
      tradingFee: entry['TradingFee'],
      voteWeight: entry['VoteWeight'],
    );
  }

  Map<String, dynamic> toJson() => {
        'VoteEntry': {
          'Account': account,
          'TradingFee': tradingFee,
          'VoteWeight': voteWeight,
        },
      };
}

class LedgerEntryAMM extends LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final String account;
  final BaseCurrency asset;
  final BaseCurrency asset2;
  final AuctionSlot? auctionSlot;
  final IssuedCurrencyAmount lpTokenBalance;
  final int? tradingFee;
  final List<VoteSlot>? voteSlots;
  final int flags;

  const LedgerEntryAMM({
    required this.account,
    required this.asset,
    required this.asset2,
    this.auctionSlot,
    required this.lpTokenBalance,
    required this.tradingFee,
    this.voteSlots,
    required this.flags,
  });

  factory LedgerEntryAMM.fromJson(Map<String, dynamic> json) {
    final auctionSlotJson = json['AuctionSlot'] as Map<String, dynamic>?;

    return LedgerEntryAMM(
      account: json['Account'],
      asset: BaseCurrency.fromJson(json['Asset'] as Map<String, dynamic>),
      asset2: BaseCurrency.fromJson(json['Asset2'] as Map<String, dynamic>),
      auctionSlot: auctionSlotJson == null
          ? null
          : AuctionSlot.fromJson(auctionSlotJson),
      lpTokenBalance: IssuedCurrencyAmount.fromJson(
          json['LPTokenBalance'] as Map<String, dynamic>),
      tradingFee: json['TradingFee'],
      voteSlots: json['VoteSlots'] == null
          ? null
          : (json['VoteSlots'] as List<dynamic>)
              .map((e) => VoteSlot.fromJson(e as Map<String, dynamic>))
              .toList(),
      flags: json['Flags'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'LedgerEntryType': ledgerEntryType,
        'Account': account,
        'Asset': asset.toJson(),
        'Asset2': asset2.toJson(),
        'AuctionSlot': auctionSlot?.toJson(),
        'LPTokenBalance': lpTokenBalance.toJson(),
        'TradingFee': tradingFee,
        'VoteSlots': voteSlots?.map((e) => e.toJson()).toList(),
        'Flags': flags,
      };

  @override
  LedgerEntryType get type => LedgerEntryType.amm;
}

class AuctionSlot {
  final String account;
  final List<LedgerAuthAccount>? authAccounts;
  final int? discountedFee;
  final int expiration;
  final IssuedCurrencyAmount price;

  const AuctionSlot({
    required this.account,
    this.authAccounts,
    required this.discountedFee,
    required this.expiration,
    required this.price,
  });

  factory AuctionSlot.fromJson(Map<String, dynamic> json) {
    return AuctionSlot(
      account: json['Account'],
      authAccounts: json['AuthAccounts'] == null
          ? null
          : (json['AuthAccounts'] as List<dynamic>)
              .map((e) => LedgerAuthAccount.fromJson(e as Map<String, dynamic>))
              .toList(),
      discountedFee: json['DiscountedFee'],
      expiration: json['Expiration'],
      price:
          IssuedCurrencyAmount.fromJson(json['Price'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'Account': account,
        'AuthAccounts': authAccounts?.map((e) => e.toJson()).toList(),
        'DiscountedFee': discountedFee,
        'Expiration': expiration,
        'Price': price.toJson(),
      };
}

class LedgerEnteryBridge extends LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final String account;
  final BaseAmount signatureReward;
  final LedgerXChainBridge xChainBridge;
  final String xChainClaimID;
  final String xChainAccountCreateCount;
  final String xChainAccountClaimCount;
  final String? minAccountCreateAmount;
  final int flags;
  final String ownerNode;

  const LedgerEnteryBridge({
    required this.account,
    required this.signatureReward,
    required this.xChainBridge,
    required this.xChainClaimID,
    required this.xChainAccountCreateCount,
    required this.xChainAccountClaimCount,
    this.minAccountCreateAmount,
    required this.flags,
    required this.ownerNode,
  });

  factory LedgerEnteryBridge.fromJson(Map<String, dynamic> json) =>
      LedgerEnteryBridge(
        account: json['Account'],
        signatureReward: BaseAmount.fromJson(
            json['SignatureReward'] as Map<String, dynamic>),
        xChainBridge: LedgerXChainBridge.fromJson(
            json['LedgerXChainBridge'] as Map<String, dynamic>),
        xChainClaimID: json['XChainClaimID'],
        xChainAccountCreateCount: json['XChainAccountCreateCount'],
        xChainAccountClaimCount: json['XChainAccountClaimCount'],
        minAccountCreateAmount: json['MinAccountCreateAmount'],
        flags: (json['Flags']) ?? 0,
        ownerNode: json['OwnerNode'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'LedgerEntryType': ledgerEntryType,
        'Account': account,
        'SignatureReward': signatureReward.toJson(),
        'LedgerXChainBridge': xChainBridge.toJson(),
        'XChainClaimID': xChainClaimID,
        'XChainAccountCreateCount': xChainAccountCreateCount,
        'XChainAccountClaimCount': xChainAccountClaimCount,
        'MinAccountCreateAmount': minAccountCreateAmount,
        'Flags': flags,
        'OwnerNode': ownerNode,
      };

  @override
  LedgerEntryType get type => LedgerEntryType.bridge;
}

class LedgerEnteryCheck extends BaseLedgerEntry
    implements HasPreviousTxnID, LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final String account;
  final String destination;
  final int flags;
  final String ownerNode;
  @override
  final String previousTxnID;
  @override
  final int previousTxnLgrSeq;
  final BaseAmount sendMax;
  final int sequence;
  final String? destinationNode;
  final int? destinationTag;
  final int? expiration;
  final String? invoiceID;
  final int? sourceTag;

  const LedgerEnteryCheck({
    required this.account,
    required this.destination,
    required this.flags,
    required this.ownerNode,
    required this.previousTxnID,
    required this.previousTxnLgrSeq,
    required this.sendMax,
    required this.sequence,
    required super.index,
    this.destinationNode,
    this.destinationTag,
    this.expiration,
    this.invoiceID,
    this.sourceTag,
  });

  factory LedgerEnteryCheck.fromJson(Map<String, dynamic> json) =>
      LedgerEnteryCheck(
          account: json['Account'],
          destination: json['Destination'],
          flags: json['Flags'],
          ownerNode: json['OwnerNode'],
          previousTxnID: json['PreviousTxnID'],
          previousTxnLgrSeq: json['PreviousTxnLgrSeq'],
          sendMax: BaseAmount.fromJson(json['SendMax'] as Map<String, dynamic>),
          sequence: json['Sequence'],
          destinationNode: json['DestinationNode'],
          destinationTag: json['DestinationTag'],
          expiration: json['Expiration'],
          invoiceID: json['InvoiceID'],
          sourceTag: json['SourceTag'],
          index: json["index"]);

  @override
  Map<String, dynamic> toJson() => {
        'LedgerEntryType': ledgerEntryType,
        'Account': account,
        'Destination': destination,
        'Flags': flags,
        'OwnerNode': ownerNode,
        'PreviousTxnID': previousTxnID,
        'PreviousTxnLgrSeq': previousTxnLgrSeq,
        'SendMax': sendMax.toJson(),
        'Sequence': sequence,
        'DestinationNode': destinationNode,
        'DestinationTag': destinationTag,
        'Expiration': expiration,
        'InvoiceID': invoiceID,
        'SourceTag': sourceTag,
      };

  @override
  LedgerEntryType get type => LedgerEntryType.check;
}

class CredentialFlags {
  final bool? lsfAccepted;

  const CredentialFlags({this.lsfAccepted});

  factory CredentialFlags.fromJson(Map<String, dynamic> json) =>
      CredentialFlags(
        lsfAccepted: json['lsfAccepted'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'lsfAccepted': lsfAccepted,
      };
}

class LedgerEnteryCredential extends LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final int? flags; // int or CredentialFlags
  final String subject;
  final String issuer;
  final String credentialType;
  final String subjectNode;
  final String issuerNode;
  final int? expiration;
  final String? uri;

  const LedgerEnteryCredential({
    required this.flags,
    required this.subject,
    required this.issuer,
    required this.credentialType,
    required this.subjectNode,
    required this.issuerNode,
    this.expiration,
    this.uri,
  });

  factory LedgerEnteryCredential.fromJson(Map<String, dynamic> json) {
    return LedgerEnteryCredential(
      flags: json['Flags'],
      subject: json['Subject'],
      issuer: json['Issuer'],
      credentialType: json['CredentialType'],
      subjectNode: json['SubjectNode'],
      issuerNode: json['IssuerNode'],
      expiration: json['Expiration'],
      uri: json['URI'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...toJson(),
      'LedgerEntryType': ledgerEntryType,
      'Flags': flags,
      'Subject': subject,
      'Issuer': issuer,
      'CredentialType': credentialType,
      'SubjectNode': subjectNode,
      'IssuerNode': issuerNode,
      'Expiration': expiration,
      'URI': uri,
    };
  }

  @override
  LedgerEntryType get type => LedgerEntryType.credential;
}

class LedgerEnteryDelegate extends BaseLedgerEntry
    implements HasPreviousTxnID, LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final String account;
  final String authorize;
  final List<Permission> permissions;
  final String ownerNode;
  final int flags;
  @override
  final String previousTxnID;

  @override
  final int previousTxnLgrSeq;

  LedgerEnteryDelegate({
    required this.account,
    required this.authorize,
    required this.permissions,
    required this.ownerNode,
    required this.previousTxnID,
    required this.previousTxnLgrSeq,
    required super.index,
    this.flags = 0,
  });

  factory LedgerEnteryDelegate.fromJson(Map<String, dynamic> json) {
    return LedgerEnteryDelegate(
        account: json['Account'],
        authorize: json['Authorize'],
        permissions: (json['Permissions'] as List<dynamic>)
            .map((e) => Permission.fromJson(e as Map<String, dynamic>))
            .toList(),
        ownerNode: json['OwnerNode'],
        flags: json['Flags'] ?? 0,
        previousTxnID: json["PreviousTxnID"],
        previousTxnLgrSeq: json["PreviousTxnLgrSeq"],
        index: json["index"]);
  }

  @override
  Map<String, dynamic> toJson() => {
        'PreviousTxnID': previousTxnID,
        'PreviousTxnLgrSeq': previousTxnLgrSeq,
        'LedgerEntryType': ledgerEntryType,
        'Account': account,
        'Authorize': authorize,
        'Permissions': permissions.map((p) => p.toJson()).toList(),
        'OwnerNode': ownerNode,
        'Flags': flags,
      };

  @override
  LedgerEntryType get type => LedgerEntryType.delegate;
}

class LedgerEnteryDepositPreauth extends BaseLedgerEntry
    implements HasPreviousTxnID, LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final String account;
  final int flags; // always 0 for LedgerEnteryDepositPreauth
  final String ownerNode;
  final String? authorize;
  final List<AuthorizeCredential>? authorizeCredentials;

  @override
  final String previousTxnID;

  @override
  final int previousTxnLgrSeq;
  LedgerEnteryDepositPreauth({
    required this.account,
    this.flags = 0,
    required this.ownerNode,
    required this.previousTxnID,
    required this.previousTxnLgrSeq,
    required super.index,
    this.authorize,
    this.authorizeCredentials,
  });

  factory LedgerEnteryDepositPreauth.fromJson(Map<String, dynamic> json) {
    return LedgerEnteryDepositPreauth(
        account: json['Account'],
        flags: json['Flags'] ?? 0,
        ownerNode: json['OwnerNode'],
        authorize: json['Authorize'],
        authorizeCredentials: (json['AuthorizeCredentials'] as List<dynamic>?)
            ?.map(
                (e) => AuthorizeCredential.fromJson(e as Map<String, dynamic>))
            .toList(),
        previousTxnID: json["PreviousTxnID"],
        previousTxnLgrSeq: json["PreviousTxnLgrSeq"],
        index: json["index"]);
  }

  @override
  Map<String, dynamic> toJson() => {
        'PreviousTxnID': previousTxnID,
        'PreviousTxnLgrSeq': previousTxnLgrSeq,
        'LedgerEntryType': ledgerEntryType,
        'Account': account,
        'Flags': flags,
        'OwnerNode': ownerNode,
        'Authorize': authorize,
        'AuthorizeCredentials':
            authorizeCredentials?.map((e) => e.toJson()).toList(),
      };

  @override
  LedgerEntryType get type => LedgerEntryType.depositPreauth;
}

class LedgerEntryDID extends BaseLedgerEntry
    implements HasPreviousTxnID, LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final String account;
  final String data;
  final String? didDocument;
  final String uri;
  final int flags; // always 0
  final String ownerNode;

  @override
  final String previousTxnID;

  @override
  final int previousTxnLgrSeq;

  const LedgerEntryDID({
    required this.account,
    required this.data,
    required this.didDocument,
    required this.uri,
    this.flags = 0,
    required this.ownerNode,
    required this.previousTxnID,
    required this.previousTxnLgrSeq,
    required super.index,
  });

  factory LedgerEntryDID.fromJson(Map<String, dynamic> json) {
    return LedgerEntryDID(
        account: json['Account'],
        data: json['Data'],
        didDocument: json['DIDDocument'],
        uri: json['URI'],
        flags: json['Flags'] ?? 0,
        ownerNode: json['OwnerNode'],
        previousTxnID: json["PreviousTxnID"],
        previousTxnLgrSeq: json["PreviousTxnLgrSeq"],
        index: json["index"]);
  }

  @override
  Map<String, dynamic> toJson() => {
        'index': index,
        'PreviousTxnID': previousTxnID,
        'PreviousTxnLgrSeq': previousTxnLgrSeq,
        'LedgerEntryType': ledgerEntryType,
        'Account': account,
        'Data': data,
        'DIDDocument': didDocument,
        'URI': uri,
        'Flags': flags,
        'OwnerNode': ownerNode,
      };

  @override
  LedgerEntryType get type => LedgerEntryType.did;
}

class LedgerEnteryDirectoryNode extends BaseLedgerEntry
    implements HasOptionalPreviousTxnID, LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final int flags;
  final String rootIndex;
  final List<String> indexes;
  final int? indexNext;
  final int? indexPrevious;
  final String? owner;
  final String? takerPaysCurrency;
  final String? takerPaysIssuer;
  final String? takerGetsCurrency;
  final String? takerGetsIssuer;
  @override
  final String? previousTxnID;

  @override
  final int? previousTxnLgrSeq;

  LedgerEnteryDirectoryNode({
    required this.flags,
    required this.rootIndex,
    required this.indexes,
    this.indexNext,
    this.indexPrevious,
    this.owner,
    this.takerPaysCurrency,
    this.takerPaysIssuer,
    this.takerGetsCurrency,
    this.takerGetsIssuer,
    required this.previousTxnID,
    required this.previousTxnLgrSeq,
    required super.index,
  });

  factory LedgerEnteryDirectoryNode.fromJson(Map<String, dynamic> json) {
    return LedgerEnteryDirectoryNode(
        flags: json['Flags'],
        rootIndex: json['RootIndex'],
        indexes: List<String>.from(json['Indexes'] as List<dynamic>),
        indexNext: IntUtils.tryParse(json['IndexNext']),
        indexPrevious: IntUtils.tryParse(json['IndexPrevious']),
        owner: json['Owner'],
        takerPaysCurrency: json['TakerPaysCurrency'],
        takerPaysIssuer: json['TakerPaysIssuer'],
        takerGetsCurrency: json['TakerGetsCurrency'],
        takerGetsIssuer: json['TakerGetsIssuer'],
        previousTxnID: json["PreviousTxnID"],
        previousTxnLgrSeq: json["PreviousTxnLgrSeq"],
        index: json["index"]);
  }

  @override
  Map<String, dynamic> toJson() => {
        'index': index,
        'PreviousTxnID': previousTxnID,
        'PreviousTxnLgrSeq': previousTxnLgrSeq,
        'LedgerEntryType': ledgerEntryType,
        'Flags': flags,
        'RootIndex': rootIndex,
        'Indexes': indexes,
        'IndexNext': indexNext,
        'IndexPrevious': indexPrevious,
        'Owner': owner,
        'TakerPaysCurrency': takerPaysCurrency,
        'TakerPaysIssuer': takerPaysIssuer,
        'TakerGetsCurrency': takerGetsCurrency,
        'TakerGetsIssuer': takerGetsIssuer,
      };

  @override
  LedgerEntryType get type => LedgerEntryType.directoryNode;
}

class LedgerEnteryEscrow extends BaseLedgerEntry
    implements HasPreviousTxnID, LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final String account;
  final String destination;
  final String amount;
  final String? condition;
  final int? cancelAfter;
  final int? finishAfter;
  final int flags;
  final int? sourceTag;
  final int? destinationTag;
  final String ownerNode;
  final String? destinationNode;

  @override
  final String previousTxnID;

  @override
  final int previousTxnLgrSeq;

  LedgerEnteryEscrow({
    required this.account,
    required this.destination,
    required this.amount,
    required this.previousTxnID,
    required this.previousTxnLgrSeq,
    required super.index,
    this.condition,
    this.cancelAfter,
    this.finishAfter,
    required this.flags,
    this.sourceTag,
    this.destinationTag,
    required this.ownerNode,
    this.destinationNode,
  });

  factory LedgerEnteryEscrow.fromJson(Map<String, dynamic> json) {
    return LedgerEnteryEscrow(
      previousTxnID: json["PreviousTxnID"],
      previousTxnLgrSeq: json["PreviousTxnLgrSeq"],
      index: json["index"],
      account: json['Account'],
      destination: json['Destination'],
      amount: json['Amount'],
      condition: json['Condition'],
      cancelAfter: json['CancelAfter'],
      finishAfter: json['FinishAfter'],
      flags: json['Flags'],
      sourceTag: json['SourceTag'],
      destinationTag: json['DestinationTag'],
      ownerNode: json['OwnerNode'],
      destinationNode: json['DestinationNode'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'index': index,
        'PreviousTxnID': previousTxnID,
        'PreviousTxnLgrSeq': previousTxnLgrSeq,
        'LedgerEntryType': ledgerEntryType,
        'Account': account,
        'Destination': destination,
        'BaseAmount': amount,
        'Condition': condition,
        'CancelAfter': cancelAfter,
        'FinishAfter': finishAfter,
        'Flags': flags,
        'SourceTag': sourceTag,
        'DestinationTag': destinationTag,
        'OwnerNode': ownerNode,
        'DestinationNode': destinationNode,
      };

  @override
  LedgerEntryType get type => LedgerEntryType.escrow;
}

class LedgerEntryFeeSettingsBase extends BaseLedgerEntry
    implements HasOptionalPreviousTxnID, LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final int flags = 0;
  @override
  final String? previousTxnID;

  @override
  final int? previousTxnLgrSeq;
  LedgerEntryFeeSettingsBase({
    this.previousTxnID,
    this.previousTxnLgrSeq,
    required super.index,
  });

  factory LedgerEntryFeeSettingsBase.fromJson(Map<String, dynamic> json) {
    return LedgerEntryFeeSettingsBase(
        previousTxnID: json['PreviousTxnID'],
        previousTxnLgrSeq: json['PreviousTxnLgrSeq'],
        index: json["index"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'PreviousTxnID': previousTxnID,
      'PreviousTxnLgrSeq': previousTxnLgrSeq,
      'LedgerEntryType': ledgerEntryType,
      'Flags': flags,
    };
  }

  @override
  LedgerEntryType get type => LedgerEntryType.feeSettings;
}

class FeeSettingsPreAmendmentFields extends LedgerEntryFeeSettingsBase {
  final String baseFee;
  final int referenceFeeUnits;
  final int reserveBase;
  final int reserveIncrement;

  FeeSettingsPreAmendmentFields({
    required this.baseFee,
    required this.referenceFeeUnits,
    required this.reserveBase,
    required this.reserveIncrement,
    super.previousTxnID,
    super.previousTxnLgrSeq,
    required super.index,
  });

  factory FeeSettingsPreAmendmentFields.fromJson(Map<String, dynamic> json) {
    return FeeSettingsPreAmendmentFields(
        baseFee: json['BaseFee'],
        referenceFeeUnits: json['ReferenceFeeUnits'],
        reserveBase: json['ReserveBase'],
        reserveIncrement: json['ReserveIncrement'],
        previousTxnID: json["PreviousTxnID"],
        previousTxnLgrSeq: json["PreviousTxnLgrSeq"],
        index: json["index"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'BaseFee': baseFee,
      'ReferenceFeeUnits': referenceFeeUnits,
      'ReserveBase': reserveBase,
      'ReserveIncrement': reserveIncrement,
    };
  }
}

class FeeSettingsPostAmendmentFields extends LedgerEntryFeeSettingsBase {
  final String baseFeeDrops;
  final String reserveBaseDrops;
  final String reserveIncrementDrops;

  FeeSettingsPostAmendmentFields({
    required this.baseFeeDrops,
    required this.reserveBaseDrops,
    required this.reserveIncrementDrops,
    super.previousTxnID,
    super.previousTxnLgrSeq,
    required super.index,
  });

  factory FeeSettingsPostAmendmentFields.fromJson(Map<String, dynamic> json) {
    return FeeSettingsPostAmendmentFields(
        baseFeeDrops: json['BaseFeeDrops'],
        reserveBaseDrops: json['ReserveBaseDrops'],
        reserveIncrementDrops: json['ReserveIncrementDrops'],
        previousTxnID: json['PreviousTxnID'],
        previousTxnLgrSeq: json['PreviousTxnLgrSeq'],
        index: json["index"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'BaseFeeDrops': baseFeeDrops,
      'ReserveBaseDrops': reserveBaseDrops,
      'ReserveIncrementDrops': reserveIncrementDrops,
    };
  }
}

class BaseLedger {
  final String accountHash;
  final List<LedgerEntry>? accountState;
  final List<String>? accountStateBinary;
  final List<String>? transactionsBinary;
  final List<TransactionWithHashAndMetaData>? transactions;
  final int closeFlags;
  final int closeTime;
  final String closeTimeHuman;
  final int closeTimeResolution;
  final String closeTimeIso;
  final bool closed;
  final String ledgerHash;
  final int parentCloseTime;
  final String parentHash;
  final String totalCoins;
  final String transactionHash;

  BaseLedger({
    required this.accountHash,
    this.accountStateBinary,
    this.transactionsBinary,
    this.accountState,
    required this.closeFlags,
    required this.closeTime,
    required this.closeTimeHuman,
    required this.closeTimeResolution,
    required this.closeTimeIso,
    required this.closed,
    required this.ledgerHash,
    required this.parentCloseTime,
    required this.parentHash,
    required this.totalCoins,
    required this.transactionHash,
    this.transactions,
  });

  factory BaseLedger.fromJson(Map<String, dynamic> json) {
    final txes = (json['transactions'] as List<dynamic>?)?.map((e) => e is Map
        ? TransactionWithHashAndMetaData.fromJson(e as Map<String, dynamic>)
        : e as String);
    final accounts = (json['accountState'] as List<dynamic>?)
        ?.map((e) =>
            e is String ? e : LedgerEntry.fromJson(e as Map<String, dynamic>))
        .toList();
    return BaseLedger(
      accountState: accounts?.whereType<LedgerEntry>().toList(),
      accountStateBinary: accounts?.whereType<String>().toList(),
      transactionsBinary: txes?.whereType<String>().toList(),
      transactions: txes?.whereType<TransactionWithHashAndMetaData>().toList(),
      accountHash: json['account_hash'],
      closeFlags: json['close_flags'],
      closeTime: json['close_time'],
      closeTimeHuman: json['close_time_human'],
      closeTimeResolution: json['close_time_resolution'],
      closeTimeIso: json['close_time_iso'],
      closed: json['closed'] as bool,
      ledgerHash: json['ledger_hash'],
      parentCloseTime: json['parent_close_time'],
      parentHash: json['parent_hash'],
      totalCoins: json['total_coins'],
      transactionHash: json['transaction_hash'],
    );
  }

  Map<String, dynamic> toJson() => {
        'account_hash': accountHash,
        'accountState':
            accountState?.map((e) => e.toJson()).toList() ?? accountStateBinary,
        'close_flags': closeFlags,
        'close_time': closeTime,
        'close_time_human': closeTimeHuman,
        'close_time_resolution': closeTimeResolution,
        'close_time_iso': closeTimeIso,
        'closed': closed,
        'ledger_hash': ledgerHash,
        'parent_close_time': parentCloseTime,
        'parent_hash': parentHash,
        'total_coins': totalCoins,
        'transaction_hash': transactionHash,
        'transactions':
            transactions?.map((e) => e.toJson()).toList() ?? transactionsBinary,
      };
}

class Ledger extends BaseLedger {
  final int ledgerIndex;

  Ledger({
    required this.ledgerIndex,
    required super.accountHash,
    super.accountState,
    required super.closeFlags,
    required super.closeTime,
    required super.closeTimeHuman,
    required super.closeTimeResolution,
    required super.closeTimeIso,
    required super.closed,
    required super.ledgerHash,
    required super.parentCloseTime,
    required super.parentHash,
    required super.totalCoins,
    required super.transactionHash,
    super.transactions,
    super.accountStateBinary,
    super.transactionsBinary,
  });

  factory Ledger.fromJson(Map<String, dynamic> json) {
    final txes = (json['transactions'] as List<dynamic>?)?.map((e) => e is Map
        ? TransactionWithHashAndMetaData.fromJson(e as Map<String, dynamic>)
        : e as String);
    final accounts = (json['accountState'] as List<dynamic>?)
        ?.map((e) =>
            e is String ? e : LedgerEntry.fromJson(e as Map<String, dynamic>))
        .toList();
    return Ledger(
      accountState: accounts?.whereType<LedgerEntry>().toList(),
      accountStateBinary: accounts?.whereType<String>().toList(),
      transactionsBinary: txes?.whereType<String>().toList(),
      transactions: txes?.whereType<TransactionWithHashAndMetaData>().toList(),
      ledgerIndex: IntUtils.parse(json["ledger_index"]),
      accountHash: json['account_hash'],
      closeFlags: json['close_flags'],
      closeTime: json['close_time'],
      closeTimeHuman: json['close_time_human'],
      closeTimeResolution: json['close_time_resolution'],
      closeTimeIso: json['close_time_iso'],
      closed: json['closed'] as bool,
      ledgerHash: json['ledger_hash'],
      parentCloseTime: json['parent_close_time'],
      parentHash: json['parent_hash'],
      totalCoins: json['total_coins'],
      transactionHash: json['transaction_hash'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'ledger_index': ledgerIndex,
    };
  }
}

class LedgerV1 extends BaseLedger {
  final String ledgerIndex;

  LedgerV1({
    required this.ledgerIndex,
    required super.accountHash,
    super.accountState,
    required super.closeFlags,
    required super.closeTime,
    required super.closeTimeHuman,
    required super.closeTimeResolution,
    required super.closeTimeIso,
    required super.closed,
    required super.ledgerHash,
    required super.parentCloseTime,
    required super.parentHash,
    required super.totalCoins,
    required super.transactionHash,
    super.transactions,
  });

  factory LedgerV1.fromJson(Map<String, dynamic> json) {
    return LedgerV1(
      ledgerIndex: json['ledger_index'],
      accountHash: json['account_hash'],
      accountState: (json['accountState'] as List<dynamic>?)
          ?.map((e) => LedgerEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      closeFlags: json['close_flags'],
      closeTime: json['close_time'],
      closeTimeHuman: json['close_time_human'],
      closeTimeResolution: json['close_time_resolution'],
      closeTimeIso: json['close_time_iso'],
      closed: json['closed'] as bool,
      ledgerHash: json['ledger_hash'],
      parentCloseTime: json['parent_close_time'],
      parentHash: json['parent_hash'],
      totalCoins: json['total_coins'],
      transactionHash: json['transaction_hash'],
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map((e) => TransactionWithHashAndMetaData.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), 'ledger_index': ledgerIndex};
  }
}

abstract class LedgerDataLedgerState {
  Map<String, dynamic> toJson();
}

abstract class LedgerDataLabeledLedgerEntry implements LedgerDataLedgerState {
  String get ledgerEntryType;
  const LedgerDataLabeledLedgerEntry();
  factory LedgerDataLabeledLedgerEntry.fromJson(Map<String, dynamic> json) {
    return LedgerEntry.fromJson(json);
  }
}

class LedgerDataBinaryLedgerEntry implements LedgerDataLedgerState {
  final String data;
  const LedgerDataBinaryLedgerEntry({required this.data});
  factory LedgerDataBinaryLedgerEntry.fromJson(Map<String, dynamic> json) {
    return LedgerDataBinaryLedgerEntry(data: json["data"]);
  }
  @override
  Map<String, dynamic> toJson() {
    return {"data": data};
  }
}

/// Dummy LedgerEntry stub - replace with your actual LedgerEntry class.
abstract class LedgerEntry extends LedgerDataLabeledLedgerEntry {
  LedgerEntryType get type;
  @override
  String get ledgerEntryType => type.value;
  const LedgerEntry();

  factory LedgerEntry.fromJson(Map<String, dynamic> json) {
    final type = LedgerEntryType.fromValue(json["LedgerEntryType"]);
    switch (type) {
      case LedgerEntryType.nfTokenPage:
        return LedgerEntryNFTokenPage.fromJson(json);
      case LedgerEntryType.nfTokenOffer:
        return LedgerEntryNFTokenOffer.fromJson(json);
      case LedgerEntryType.mpToken:
        return LedgerEntryMPToken.fromJson(json);
      case LedgerEntryType.mpTokenIssuance:
        return LedgerEntryMPTokenIssuance.fromJson(json);
      case LedgerEntryType.did:
        return LedgerEntryDID.fromJson(json);
      case LedgerEntryType.oracle:
        return LedgerEntryOracle.fromJson(json);
      case LedgerEntryType.xChainOwnedCreateAccountClaimId:
        return LedgerEntryXChainOwnedCreateAccountClaimID.fromJson(json);
      case LedgerEntryType.xChainOwnedClaimId:
        return LedgerEntryXChainOwnedClaimID.fromJson(json);
      case LedgerEntryType.ticket:
        return LedgerEntryTicket.fromJson(json);
      case LedgerEntryType.signerList:
        return LedgerEntrySignerList.fromJson(json);
      case LedgerEntryType.rippleState:
        return LedgerEntryRippleState.fromJson(json);
      case LedgerEntryType.permissionedDomain:
        return LedgerEntryPermissionedDomain.fromJson(json);
      case LedgerEntryType.payChannel:
        return LedgerEntryPayChannel.fromJson(json);
      case LedgerEntryType.offer:
        return LedgerEntryOffer.fromJson(json);
      case LedgerEntryType.negativeUnl:
        return LedgerEntryNegativeUNL.fromJson(json);
      case LedgerEntryType.ledgerHashes:
        return LedgerEntryLedgerHashes.fromJson(json);
      case LedgerEntryType.feeSettings:
        return LedgerEntryFeeSettingsBase.fromJson(json);
      case LedgerEntryType.accountRoot:
        return LedgerEntryAccountRoot.fromJson(json);
      case LedgerEntryType.amendments:
        return LedgerEntryAmendments.fromJson(json);
      case LedgerEntryType.amm:
        return LedgerEntryAMM.fromJson(json);
      case LedgerEntryType.bridge:
        return LedgerEnteryBridge.fromJson(json);
      case LedgerEntryType.check:
        return LedgerEnteryCheck.fromJson(json);
      case LedgerEntryType.credential:
        return LedgerEnteryCredential.fromJson(json);
      case LedgerEntryType.delegate:
        return LedgerEnteryDelegate.fromJson(json);
      case LedgerEntryType.depositPreauth:
        return LedgerEnteryDepositPreauth.fromJson(json);
      case LedgerEntryType.directoryNode:
        return LedgerEnteryDirectoryNode.fromJson(json);
      case LedgerEntryType.escrow:
        return LedgerEnteryEscrow.fromJson(json);
    }
  }

  @override
  Map<String, dynamic> toJson();
}

/// Dummy Transaction and metadata - replace with your actual classes.
class TransactionWithHashAndMetaData {
  final String hash;
  final BaseTransaction? transaction;
  final TransactionMetadataBase? metaData;

  const TransactionWithHashAndMetaData({
    required this.hash,
    this.transaction,
    this.metaData,
  });

  factory TransactionWithHashAndMetaData.fromJson(Map<String, dynamic> json) {
    final tx = json["transaction"] == null
        ? null
        : BaseTransaction.fromJson(json['transaction']);
    final metadata = json["metaData"] == null
        ? null
        : TransactionMetadataBase.fromJson(
            json['metaData'], tx?.transactionType);
    return TransactionWithHashAndMetaData(
      hash: json['hash'],
      transaction: tx,
      metaData: metadata,
    );
  }

  Map<String, dynamic> toJson() => {
        'hash': hash,
        'transaction': transaction?.toXrpl(),
        'metaData': metaData?.toJson(),
      };
}

class LedgerEntryLedgerHashes extends BaseLedgerEntry implements LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final int? lastLedgerSequence;
  final List<String> hashes;
  final int flags;

  LedgerEntryLedgerHashes({
    this.lastLedgerSequence,
    required this.hashes,
    required this.flags,
    required super.index,
  });

  factory LedgerEntryLedgerHashes.fromJson(Map<String, dynamic> json) {
    return LedgerEntryLedgerHashes(
        lastLedgerSequence: json['LastLedgerSequence'],
        hashes: List<String>.from(json['Hashes'] as List),
        flags: json['Flags'],
        index: json["index"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'LedgerEntryType': ledgerEntryType,
      'LastLedgerSequence': lastLedgerSequence,
      'Hashes': hashes,
      'Flags': flags,
    };
  }

  @override
  LedgerEntryType get type => LedgerEntryType.ledgerHashes;
}

class LedgerEntryMPToken extends BaseLedgerEntry
    implements HasPreviousTxnID, LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final String mpTokenIssuanceID;
  final String? mptAmount;
  final int flags;
  final String? ownerNode;

  @override
  final String previousTxnID;

  @override
  final int previousTxnLgrSeq;

  LedgerEntryMPToken({
    required this.mpTokenIssuanceID,
    required this.previousTxnID,
    required this.previousTxnLgrSeq,
    this.mptAmount,
    required this.flags,
    this.ownerNode,
    required super.index,
  });

  factory LedgerEntryMPToken.fromJson(Map<String, dynamic> json) {
    return LedgerEntryMPToken(
        mpTokenIssuanceID: json['MPTokenIssuanceID'],
        mptAmount: json['MPTAmount'],
        flags: json['Flags'],
        ownerNode: json['OwnerNode'],
        previousTxnID: json["PreviousTxnID"],
        previousTxnLgrSeq: json["PreviousTxnLgrSeq"],
        index: json["index"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'PreviousTxnID': previousTxnID,
      'PreviousTxnLgrSeq': previousTxnLgrSeq,
      'LedgerEntryType': ledgerEntryType,
      'MPTokenIssuanceID': mpTokenIssuanceID,
      'MPTAmount': mptAmount,
      'Flags': flags,
      'OwnerNode': ownerNode,
    };
  }

  @override
  LedgerEntryType get type => LedgerEntryType.mpToken;
}

class LedgerEntryMPTokenIssuance extends BaseLedgerEntry
    implements HasPreviousTxnID, LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final int flags;
  final String issuer;
  final int? assetScale;
  final String? maximumAmount;
  final String outstandingAmount;
  final int? transferFee;
  final String? mpTokenMetadata;
  final String? ownerNode;
  @override
  final String previousTxnID;

  @override
  final int previousTxnLgrSeq;

  LedgerEntryMPTokenIssuance({
    required this.flags,
    required this.issuer,
    required this.previousTxnID,
    required this.previousTxnLgrSeq,
    this.assetScale,
    this.maximumAmount,
    required this.outstandingAmount,
    this.transferFee,
    this.mpTokenMetadata,
    this.ownerNode,
    required super.index,
  });

  factory LedgerEntryMPTokenIssuance.fromJson(Map<String, dynamic> json) {
    return LedgerEntryMPTokenIssuance(
        flags: json['Flags'],
        issuer: json['Issuer'],
        assetScale: json['AssetScale'],
        maximumAmount: json['MaximumAmount'],
        outstandingAmount: json['OutstandingAmount'],
        transferFee: json['TransferFee'],
        mpTokenMetadata: json['MPTokenMetadata'],
        ownerNode: json['OwnerNode'],
        previousTxnID: json["PreviousTxnID"],
        previousTxnLgrSeq: json["PreviousTxnLgrSeq"],
        index: json["index"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'PreviousTxnID': previousTxnID,
      'PreviousTxnLgrSeq': previousTxnLgrSeq,
      'LedgerEntryType': ledgerEntryType,
      'Flags': flags,
      'Issuer': issuer,
      'AssetScale': assetScale,
      'MaximumAmount': maximumAmount,
      'OutstandingAmount': outstandingAmount,
      'TransferFee': transferFee,
      'MPTokenMetadata': mpTokenMetadata,
      'OwnerNode': ownerNode,
    };
  }

  @override
  LedgerEntryType get type => LedgerEntryType.mpTokenIssuance;
}

class LedgerEntryNegativeUNL extends BaseLedgerEntry
    implements HasOptionalPreviousTxnID, LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final List<DisabledValidator>? disabledValidators;
  final String? validatorToDisable;
  final String? validatorToReEnable;
  @override
  final String? previousTxnID;

  @override
  final int? previousTxnLgrSeq;

  LedgerEntryNegativeUNL({
    this.previousTxnID,
    this.previousTxnLgrSeq,
    this.disabledValidators,
    this.validatorToDisable,
    this.validatorToReEnable,
    required super.index,
  });

  factory LedgerEntryNegativeUNL.fromJson(Map<String, dynamic> json) {
    return LedgerEntryNegativeUNL(
        disabledValidators: json['DisabledValidators'] != null
            ? (json['DisabledValidators'] as List)
                .map((e) =>
                    DisabledValidator.fromJson(e as Map<String, dynamic>))
                .toList()
            : null,
        validatorToDisable: json['ValidatorToDisable'],
        validatorToReEnable: json['ValidatorToReEnable'],
        previousTxnID: json["PreviousTxnID"],
        previousTxnLgrSeq: json["PreviousTxnLgrSeq"],
        index: json["index"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'PreviousTxnID': previousTxnID,
      'PreviousTxnLgrSeq': previousTxnLgrSeq,
      'LedgerEntryType': ledgerEntryType,
      'DisabledValidators': disabledValidators?.map((e) => e.toJson()).toList(),
      'ValidatorToDisable': validatorToDisable,
      'ValidatorToReEnable': validatorToReEnable,
    };
  }

  @override
  LedgerEntryType get type => LedgerEntryType.negativeUnl;
}

class DisabledValidator {
  final int firstLedgerSequence;
  final String publicKey;

  DisabledValidator({
    required this.firstLedgerSequence,
    required this.publicKey,
  });

  factory DisabledValidator.fromJson(Map<String, dynamic> json) {
    return DisabledValidator(
      firstLedgerSequence: json['FirstLedgerSequence'],
      publicKey: json['PublicKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FirstLedgerSequence': firstLedgerSequence,
      'PublicKey': publicKey,
    };
  }
}

class LedgerEntryNFTokenOffer extends BaseLedgerEntry
    implements HasPreviousTxnID, LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final BaseAmount amount;
  final String? destination;
  final int? expiration;
  final int flags;
  final String? nfTokenOfferNode;
  final String owner;
  final String? ownerNode;

  @override
  final String previousTxnID;

  @override
  final int previousTxnLgrSeq;

  LedgerEntryNFTokenOffer(
      {required this.amount,
      this.destination,
      required this.expiration,
      required this.flags,
      this.nfTokenOfferNode,
      required this.owner,
      required this.previousTxnID,
      required this.previousTxnLgrSeq,
      required super.index,
      this.ownerNode});

  factory LedgerEntryNFTokenOffer.fromJson(Map<String, dynamic> json) {
    return LedgerEntryNFTokenOffer(
        amount: BaseAmount.fromJson(json['Amount']),
        destination: json['Destination'],
        expiration: json['Expiration'],
        flags: json['Flags'],
        nfTokenOfferNode: json['NFTokenOfferNode'],
        owner: json['Owner'],
        ownerNode: json['OwnerNode'],
        previousTxnID: json["PreviousTxnID"],
        previousTxnLgrSeq: json["PreviousTxnLgrSeq"],
        index: json["index"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'PreviousTxnID': previousTxnID,
      'PreviousTxnLgrSeq': previousTxnLgrSeq,
      'LedgerEntryType': ledgerEntryType,
      'BaseAmount': amount.toJson(),
      'Destination': destination,
      'Expiration': expiration,
      'Flags': flags,
      'NFTokenOfferNode': nfTokenOfferNode,
      'Owner': owner,
      'OwnerNode': ownerNode,
    };
  }

  @override
  LedgerEntryType get type => LedgerEntryType.nfTokenOffer;
}

class NFToken {
  final int? flags;
  final String? issuer;
  final String nfTokenID;
  final int? nfTokenTaxon;
  final String? uri;

  NFToken(
      {required this.flags,
      required this.issuer,
      required this.nfTokenID,
      required this.nfTokenTaxon,
      this.uri});

  factory NFToken.fromJson(Map<String, dynamic> json) {
    final nftoken = json["NFToken"];
    return NFToken(
      flags: nftoken['Flags'],
      issuer: nftoken['Issuer'],
      nfTokenID: nftoken['NFTokenID'],
      nfTokenTaxon: nftoken['NFTokenTaxon'],
      uri: nftoken['URI'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Flags': flags,
      'Issuer': issuer,
      'NFTokenID': nfTokenID,
      'NFTokenTaxon': nfTokenTaxon,
      'URI': uri,
    };
  }
}

class LedgerEntryNFTokenPage extends BaseLedgerEntry
    implements HasPreviousTxnID, LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final String? nextPageMin;
  final List<NFToken> nFTokens;
  final String? previousPageMin;
  @override
  final String previousTxnID;

  @override
  final int previousTxnLgrSeq;

  LedgerEntryNFTokenPage({
    this.nextPageMin,
    required this.nFTokens,
    this.previousPageMin,
    required this.previousTxnID,
    required this.previousTxnLgrSeq,
    required super.index,
  });

  factory LedgerEntryNFTokenPage.fromJson(Map<String, dynamic> json) {
    return LedgerEntryNFTokenPage(
        nextPageMin: json['NextPageMin'],
        nFTokens: (json['NFTokens'] as List)
            .map((e) => NFToken.fromJson(e as Map<String, dynamic>))
            .toList(),
        previousPageMin: json['PreviousPageMin'],
        previousTxnID: json["PreviousTxnID"],
        previousTxnLgrSeq: json["PreviousTxnLgrSeq"],
        index: json["index"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'PreviousTxnID': previousTxnID,
      'PreviousTxnLgrSeq': previousTxnLgrSeq,
      'LedgerEntryType': ledgerEntryType,
      'NextPageMin': nextPageMin,
      'NFTokens': nFTokens.map((e) => e.toJson()).toList(),
      'PreviousPageMin': previousPageMin,
    };
  }

  @override
  LedgerEntryType get type => LedgerEntryType.nfTokenPage;
}

class OfferFlags {
  static const int lsfPassive = 0x00010000;
  static const int lsfSell = 0x00020000;
}

class LedgerEntryOffer extends BaseLedgerEntry
    implements HasPreviousTxnID, LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final int flags;
  final String account;
  final int sequence;
  final BaseAmount takerPays;
  final BaseAmount takerGets;
  final String bookDirectory;
  final String bookNode;
  final String ownerNode;
  final int? expiration;
  @override
  final String previousTxnID;

  @override
  final int previousTxnLgrSeq;

  LedgerEntryOffer({
    required this.flags,
    required this.account,
    required this.sequence,
    required this.takerPays,
    required this.takerGets,
    required this.bookDirectory,
    required this.bookNode,
    required this.ownerNode,
    required this.previousTxnID,
    required this.previousTxnLgrSeq,
    required super.index,
    this.expiration,
  });
// LedgerEntryOffer.fromJson(Map<String,dynamic> json):

  factory LedgerEntryOffer.fromJson(Map<String, dynamic> json) {
    return LedgerEntryOffer(
        flags: json['Flags'],
        account: json['Account'],
        sequence: json['Sequence'],
        takerPays: BaseAmount.fromJson(json['TakerPays']),
        takerGets: BaseAmount.fromJson(json['TakerGets']),
        bookDirectory: json['BookDirectory'],
        bookNode: json['BookNode'],
        ownerNode: json['OwnerNode'],
        expiration: json['Expiration'],
        previousTxnID: json["PreviousTxnID"],
        previousTxnLgrSeq: json["PreviousTxnLgrSeq"],
        index: json["index"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'PreviousTxnID': previousTxnID,
      'PreviousTxnLgrSeq': previousTxnLgrSeq,
      'LedgerEntryType': ledgerEntryType,
      'Flags': flags,
      'Account': account,
      'Sequence': sequence,
      'TakerPays': takerPays.toJson(),
      'TakerGets': takerGets.toJson(),
      'BookDirectory': bookDirectory,
      'BookNode': bookNode,
      'OwnerNode': ownerNode,
      'Expiration': expiration,
    };
  }

  @override
  LedgerEntryType get type => LedgerEntryType.offer;
}

class LedgerEntryPayChannel extends BaseLedgerEntry
    implements HasPreviousTxnID, LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final String account;
  final String destination;
  final String amount;
  final String balance;
  final String publicKey;
  final int settleDelay;
  final String ownerNode;
  final int flags;
  final int? expiration;
  final int? cancelAfter;
  final int? sourceTag;
  final int? destinationTag;
  final String? destinationNode;

  @override
  final String previousTxnID;

  @override
  final int previousTxnLgrSeq;

  LedgerEntryPayChannel({
    required this.account,
    required this.destination,
    required this.amount,
    required this.balance,
    required this.publicKey,
    required this.settleDelay,
    required this.ownerNode,
    required this.flags,
    required this.previousTxnID,
    required this.previousTxnLgrSeq,
    required super.index,
    this.expiration,
    this.cancelAfter,
    this.sourceTag,
    this.destinationTag,
    this.destinationNode,
  });

  factory LedgerEntryPayChannel.fromJson(Map<String, dynamic> json) {
    return LedgerEntryPayChannel(
        account: json['Account'],
        destination: json['Destination'],
        amount: json['Amount'],
        balance: json['Balance'],
        publicKey: json['PublicKey'],
        settleDelay: json['SettleDelay'],
        ownerNode: json['OwnerNode'],
        flags: json['Flags'],
        expiration: json['Expiration'],
        cancelAfter: json['CancelAfter'],
        sourceTag: json['SourceTag'],
        destinationTag: json['DestinationTag'],
        destinationNode: json['DestinationNode'],
        previousTxnID: json["PreviousTxnID"],
        previousTxnLgrSeq: json["PreviousTxnLgrSeq"],
        index: json["index"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'PreviousTxnID': previousTxnID,
      'PreviousTxnLgrSeq': previousTxnLgrSeq,
      'LedgerEntryType': ledgerEntryType,
      'Account': account,
      'Destination': destination,
      'BaseAmount': amount,
      'Balance': balance,
      'PublicKey': publicKey,
      'SettleDelay': settleDelay,
      'OwnerNode': ownerNode,
      'Flags': flags,
      'Expiration': expiration,
      'CancelAfter': cancelAfter,
      'SourceTag': sourceTag,
      'DestinationTag': destinationTag,
      'DestinationNode': destinationNode,
    };
  }

  @override
  LedgerEntryType get type => LedgerEntryType.payChannel;
}

class LedgerEntryPermissionedDomain extends BaseLedgerEntry
    implements HasPreviousTxnID, LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final String owner;
  final List<AuthorizeCredential> acceptedCredentials;
  final int flags;
  final String ownerNode;
  final int sequence;
  @override
  final String previousTxnID;

  @override
  final int previousTxnLgrSeq;

  LedgerEntryPermissionedDomain({
    required this.owner,
    required this.acceptedCredentials,
    this.flags = 0,
    required this.ownerNode,
    required this.sequence,
    required this.previousTxnID,
    required this.previousTxnLgrSeq,
    required super.index,
  });

  factory LedgerEntryPermissionedDomain.fromJson(Map<String, dynamic> json) {
    return LedgerEntryPermissionedDomain(
        owner: json['Owner'],
        acceptedCredentials: (json['AcceptedCredentials'] as List<dynamic>)
            .map((e) => AuthorizeCredential.fromJson(e as Map<String, dynamic>))
            .toList(),
        flags: json['Flags'] ?? 0,
        ownerNode: json['OwnerNode'],
        sequence: json['Sequence'],
        previousTxnID: json["PreviousTxnID"],
        previousTxnLgrSeq: json["PreviousTxnLgrSeq"],
        index: json["index"]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'PreviousTxnID': previousTxnID,
      'PreviousTxnLgrSeq': previousTxnLgrSeq,
      'LedgerEntryType': ledgerEntryType,
      'Owner': owner,
      'AcceptedCredentials':
          acceptedCredentials.map((e) => e.toJson()).toList(),
      'Flags': flags,
      'OwnerNode': ownerNode,
      'Sequence': sequence,
    };
  }

  @override
  LedgerEntryType get type => LedgerEntryType.permissionedDomain;
}

class LedgerEntryRippleState extends BaseLedgerEntry
    implements HasPreviousTxnID, LedgerEntry {
  @override
  final String previousTxnID;

  @override
  final int previousTxnLgrSeq;
  @override
  String get ledgerEntryType => type.value;
  final int flags;
  final IssuedCurrencyAmount balance;
  final IssuedCurrencyAmount lowLimit;
  final IssuedCurrencyAmount highLimit;
  final String? lowNode;
  final String? highNode;
  final int? lowQualityIn;
  final int? lowQualityOut;
  final int? highQualityIn;
  final int? highQualityOut;

  LedgerEntryRippleState({
    required this.flags,
    required this.balance,
    required this.lowLimit,
    required this.highLimit,
    required this.previousTxnID,
    required this.previousTxnLgrSeq,
    required super.index,
    this.lowNode,
    this.highNode,
    this.lowQualityIn,
    this.lowQualityOut,
    this.highQualityIn,
    this.highQualityOut,
  });

  factory LedgerEntryRippleState.fromJson(Map<String, dynamic> json) =>
      LedgerEntryRippleState(
          flags: json['Flags'],
          balance: IssuedCurrencyAmount.fromJson(json['Balance']),
          lowLimit: IssuedCurrencyAmount.fromJson(json['LowLimit']),
          highLimit: IssuedCurrencyAmount.fromJson(json['HighLimit']),
          lowNode: json['LowNode'],
          highNode: json['HighNode'],
          lowQualityIn: json['LowQualityIn'],
          lowQualityOut: json['LowQualityOut'],
          highQualityIn: json['HighQualityIn'],
          highQualityOut: json['HighQualityOut'],
          previousTxnID: json["PreviousTxnID"],
          previousTxnLgrSeq: json["PreviousTxnLgrSeq"],
          index: json["index"]);

  @override
  Map<String, dynamic> toJson() => {
        'index': index,
        'PreviousTxnID': previousTxnID,
        'PreviousTxnLgrSeq': previousTxnLgrSeq,
        'LedgerEntryType': ledgerEntryType,
        'Flags': flags,
        'Balance': balance.toJson(),
        'LowLimit': lowLimit.toJson(),
        'HighLimit': highLimit.toJson(),
        'LowNode': lowNode,
        'HighNode': highNode,
        'LowQualityIn': lowQualityIn,
        'LowQualityOut': lowQualityOut,
        'HighQualityIn': highQualityIn,
        'HighQualityOut': highQualityOut,
      };

  @override
  LedgerEntryType get type => LedgerEntryType.rippleState;
}

enum RippleStateFlags {
  lsfLowReserve(0x00010000),
  lsfHighReserve(0x00020000),
  lsfLowAuth(0x00040000),
  lsfHighAuth(0x00080000),
  lsfLowNoRipple(0x00100000),
  lsfHighNoRipple(0x00200000),
  lsfLowFreeze(0x00400000),
  lsfHighFreeze(0x00800000),
  lsfAMMNode(0x01000000),
  lsfLowDeepFreeze(0x02000000),
  lsfHighDeepFreeze(0x04000000);

  final int value;
  const RippleStateFlags(this.value);
}

class LedgerEntrySignerList extends BaseLedgerEntry
    implements HasPreviousTxnID, LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final int flags;
  final String ownerNode;
  final List<LedgerSignerEntry> signerEntries;
  final int signerListID;
  final int signerQuorum;
  @override
  final String previousTxnID;

  @override
  final int previousTxnLgrSeq;

  LedgerEntrySignerList({
    required this.flags,
    required this.ownerNode,
    required this.signerEntries,
    required this.signerListID,
    required this.signerQuorum,
    required this.previousTxnID,
    required this.previousTxnLgrSeq,
    required super.index,
  });

  factory LedgerEntrySignerList.fromJson(Map<String, dynamic> json) =>
      LedgerEntrySignerList(
          flags: json['Flags'],
          ownerNode: json['OwnerNode'],
          signerEntries: (json['SignerEntries'] as List)
              .map((e) => LedgerSignerEntry.fromJson(e))
              .toList(),
          signerListID: json['SignerListID'],
          signerQuorum: json['SignerQuorum'],
          previousTxnID: json["PreviousTxnID"],
          previousTxnLgrSeq: json["PreviousTxnLgrSeq"],
          index: json["index"]);

  @override
  Map<String, dynamic> toJson() => {
        'index': index,
        'PreviousTxnID': previousTxnID,
        'PreviousTxnLgrSeq': previousTxnLgrSeq,
        'LedgerEntryType': ledgerEntryType,
        'Flags': flags,
        'OwnerNode': ownerNode,
        'SignerEntries': signerEntries.map((e) => e.toJson()).toList(),
        'SignerListID': signerListID,
        'SignerQuorum': signerQuorum,
      };

  @override
  LedgerEntryType get type => LedgerEntryType.signerList;
}

enum SignerListFlags {
  lsfOneOwnerCount(0x00010000);

  final int value;
  const SignerListFlags(this.value);
}

class LedgerEntryTicket extends BaseLedgerEntry
    implements HasPreviousTxnID, LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final String account;
  final int flags;
  final String ownerNode;
  final int ticketSequence;
  @override
  final String previousTxnID;

  @override
  final int previousTxnLgrSeq;

  LedgerEntryTicket({
    required this.account,
    required this.flags,
    required this.ownerNode,
    required this.ticketSequence,
    required this.previousTxnID,
    required this.previousTxnLgrSeq,
    required super.index,
  });

  factory LedgerEntryTicket.fromJson(Map<String, dynamic> json) =>
      LedgerEntryTicket(
          account: json['Account'],
          flags: json['Flags'],
          ownerNode: json['OwnerNode'],
          ticketSequence: json['TicketSequence'],
          previousTxnID: json["PreviousTxnID"],
          previousTxnLgrSeq: json["PreviousTxnLgrSeq"],
          index: json["index"]);

  @override
  Map<String, dynamic> toJson() => {
        'index': index,
        'PreviousTxnID': previousTxnID,
        'PreviousTxnLgrSeq': previousTxnLgrSeq,
        'LedgerEntryType': ledgerEntryType,
        'Account': account,
        'Flags': flags,
        'OwnerNode': ownerNode,
        'TicketSequence': ticketSequence,
      };

  @override
  LedgerEntryType get type => LedgerEntryType.ticket;
}

class LedgerEntryXChainOwnedClaimID extends LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final String account;
  final LedgerXChainBridge xChainBridge;
  final String xChainClaimID;
  final String otherChainSource;
  final List<XChainClaimAttestation> xChainClaimAttestations;
  final String signatureReward;
  final int flags; // always 0
  final String ownerNode;

  LedgerEntryXChainOwnedClaimID({
    required this.account,
    required this.xChainBridge,
    required this.xChainClaimID,
    required this.otherChainSource,
    required this.xChainClaimAttestations,
    required this.signatureReward,
    required this.flags,
    required this.ownerNode,
  });

  factory LedgerEntryXChainOwnedClaimID.fromJson(Map<String, dynamic> json) {
    return LedgerEntryXChainOwnedClaimID(
      account: json['Account'],
      xChainBridge: LedgerXChainBridge.fromJson(
          json['LedgerXChainBridge'] as Map<String, dynamic>),
      xChainClaimID: json['XChainClaimID'],
      otherChainSource: json['OtherChainSource'],
      xChainClaimAttestations: (json['XChainClaimAttestations']
              as List<dynamic>)
          .map(
              (e) => XChainClaimAttestation.fromJson(e as Map<String, dynamic>))
          .toList(),
      signatureReward: json['SignatureReward'],
      flags: json['Flags'],
      ownerNode: json['OwnerNode'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'LedgerEntryType': ledgerEntryType,
      'Account': account,
      'LedgerXChainBridge': xChainBridge.toJson(),
      'XChainClaimID': xChainClaimID,
      'OtherChainSource': otherChainSource,
      'XChainClaimAttestations':
          xChainClaimAttestations.map((e) => e.toJson()).toList(),
      'SignatureReward': signatureReward,
      'Flags': flags,
      'OwnerNode': ownerNode,
    };
  }

  @override
  LedgerEntryType get type => LedgerEntryType.xChainOwnedClaimId;
}

class XChainClaimAttestation {
  final XChainClaimProofSig xChainClaimProofSig;

  XChainClaimAttestation({required this.xChainClaimProofSig});

  factory XChainClaimAttestation.fromJson(Map<String, dynamic> json) {
    return XChainClaimAttestation(
      xChainClaimProofSig: XChainClaimProofSig.fromJson(
          json['XChainClaimProofSig'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'XChainClaimProofSig': xChainClaimProofSig.toJson(),
    };
  }
}

class XChainClaimProofSig {
  final BaseAmount amount;
  final String attestationRewardAccount;
  final String attestationSignerAccount;
  final String? destination;
  final String publicKey;
  final int wasLockingChainSend; // 0 or 1

  XChainClaimProofSig({
    required this.amount,
    required this.attestationRewardAccount,
    required this.attestationSignerAccount,
    this.destination,
    required this.publicKey,
    required this.wasLockingChainSend,
  });

  factory XChainClaimProofSig.fromJson(Map<String, dynamic> json) {
    return XChainClaimProofSig(
      amount: BaseAmount.fromJson(json['Amount']),
      attestationRewardAccount: json['AttestationRewardAccount'],
      attestationSignerAccount: json['AttestationSignerAccount'],
      destination: json['Destination'],
      publicKey: json['PublicKey'],
      wasLockingChainSend: json['WasLockingChainSend'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BaseAmount': amount.toJson(),
      'AttestationRewardAccount': attestationRewardAccount,
      'AttestationSignerAccount': attestationSignerAccount,
      'PublicKey': publicKey,
      'WasLockingChainSend': wasLockingChainSend,
      'Destination': destination,
    };
  }
}

class LedgerEntryXChainOwnedCreateAccountClaimID extends LedgerEntry {
  @override
  String get ledgerEntryType => type.value;
  final String account;
  final LedgerXChainBridge xChainBridge;
  final int xChainAccountCreateCount;
  final List<XChainCreateAccountAttestation> xChainCreateAccountAttestations;
  final int flags; // always 0
  final String ownerNode;

  LedgerEntryXChainOwnedCreateAccountClaimID({
    required this.account,
    required this.xChainBridge,
    required this.xChainAccountCreateCount,
    required this.xChainCreateAccountAttestations,
    required this.flags,
    required this.ownerNode,
  });

  factory LedgerEntryXChainOwnedCreateAccountClaimID.fromJson(
      Map<String, dynamic> json) {
    return LedgerEntryXChainOwnedCreateAccountClaimID(
      account: json['Account'],
      xChainBridge: LedgerXChainBridge.fromJson(
          json['LedgerXChainBridge'] as Map<String, dynamic>),
      xChainAccountCreateCount: json['XChainAccountCreateCount'],
      xChainCreateAccountAttestations:
          (json['XChainCreateAccountAttestations'] as List<dynamic>)
              .map((e) => XChainCreateAccountAttestation.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
      flags: json['Flags'],
      ownerNode: json['OwnerNode'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'LedgerEntryType': ledgerEntryType,
      'Account': account,
      'LedgerXChainBridge': xChainBridge.toJson(),
      'XChainAccountCreateCount': xChainAccountCreateCount,
      'XChainCreateAccountAttestations':
          xChainCreateAccountAttestations.map((e) => e.toJson()).toList(),
      'Flags': flags,
      'OwnerNode': ownerNode,
    };
  }

  @override
  LedgerEntryType get type => LedgerEntryType.xChainOwnedCreateAccountClaimId;
}

class XChainCreateAccountAttestation {
  final XChainCreateAccountProofSig xChainCreateAccountProofSig;

  XChainCreateAccountAttestation({required this.xChainCreateAccountProofSig});

  factory XChainCreateAccountAttestation.fromJson(Map<String, dynamic> json) {
    return XChainCreateAccountAttestation(
      xChainCreateAccountProofSig: XChainCreateAccountProofSig.fromJson(
          json['XChainCreateAccountProofSig'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'XChainCreateAccountProofSig': xChainCreateAccountProofSig.toJson(),
    };
  }
}

class XChainCreateAccountProofSig {
  final String amount;
  final String attestationRewardAccount;
  final String attestationSignerAccount;
  final String destination;
  final String publicKey;
  final int wasLockingChainSend; // 0 or 1

  XChainCreateAccountProofSig({
    required this.amount,
    required this.attestationRewardAccount,
    required this.attestationSignerAccount,
    required this.destination,
    required this.publicKey,
    required this.wasLockingChainSend,
  });

  factory XChainCreateAccountProofSig.fromJson(Map<String, dynamic> json) {
    return XChainCreateAccountProofSig(
      amount: json['Amount'],
      attestationRewardAccount: json['AttestationRewardAccount'],
      attestationSignerAccount: json['AttestationSignerAccount'],
      destination: json['Destination'],
      publicKey: json['PublicKey'],
      wasLockingChainSend: json['WasLockingChainSend'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BaseAmount': amount,
      'AttestationRewardAccount': attestationRewardAccount,
      'AttestationSignerAccount': attestationSignerAccount,
      'Destination': destination,
      'PublicKey': publicKey,
      'WasLockingChainSend': wasLockingChainSend,
    };
  }
}

class LedgerEntryOracle extends BaseLedgerEntry
    implements HasPreviousTxnID, LedgerEntry {
  @override
  String get ledgerEntryType => type.value;

  /// The time the data was last updated, represented as a unix timestamp in seconds.
  final int lastUpdateTime;

  /// The XRPL account with update and delete privileges for the oracle.
  final String owner;

  /// Describes the type of asset, such as "currency", "commodity", or "index".
  final String assetClass;

  /// The oracle provider, such as Chainlink, Band, or DIA.
  final String provider;

  /// An array of up to 10 LedgerPriceData objects.
  final List<LedgerPriceData> priceDataSeries;

  /// A bit-map of boolean flags. No flags are defined for the LedgerEntryOracle object type, so this value is always 0.
  final int flags;

  LedgerEntryOracle({
    required this.lastUpdateTime,
    required this.owner,
    required this.assetClass,
    required this.provider,
    required this.priceDataSeries,
    required this.previousTxnID,
    required this.previousTxnLgrSeq,
    required super.index,
    required this.flags,
  });
  factory LedgerEntryOracle.fromJson(Map<String, dynamic> json) {
    return LedgerEntryOracle(
        lastUpdateTime: json['LastUpdateTime'],
        owner: json['Owner'],
        assetClass: json['AssetClass'],
        provider: json['Provider'],
        priceDataSeries: (json['PriceDataSeries'] as List<dynamic>)
            .map((e) => LedgerPriceData.fromJson(e as Map<String, dynamic>))
            .toList(),
        flags: json['Flags'],
        previousTxnID: json["PreviousTxnID"],
        previousTxnLgrSeq: json["PreviousTxnLgrSeq"],
        index: json["index"]);
  }
  @override
  final String previousTxnID;

  @override
  final int previousTxnLgrSeq;

  @override
  LedgerEntryType get type => LedgerEntryType.oracle;

  @override
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'PreviousTxnID': previousTxnID,
      'PreviousTxnLgrSeq': previousTxnLgrSeq,
      'LedgerEntryType': ledgerEntryType,
      'LastUpdateTime': lastUpdateTime,
      'Owner': owner,
      'AssetClass': assetClass,
      'Provider': provider,
      'PriceDataSeries': priceDataSeries.map((e) => e.toJson()).toList(),
      'Flags': flags,
    };
  }
}
