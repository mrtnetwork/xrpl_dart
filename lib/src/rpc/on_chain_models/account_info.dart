import 'package:blockchain_utils/utils/numbers/utils/int_utils.dart';

class AccountInfo {
  final AccountData accountData;
  final AccountFlags accountFlags;
  final int? ledgerCurrentIndex;
  final String? status;
  final bool validated;

  AccountInfo({
    required this.accountData,
    required this.accountFlags,
    required this.ledgerCurrentIndex,
    required this.status,
    required this.validated,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      accountData: AccountData.fromJson(json['account_data']),
      accountFlags: AccountFlags.fromJson(json['account_flags']),
      ledgerCurrentIndex: IntUtils.tryParse(json['ledger_current_index']),
      status: json['status'],
      validated: json['validated'],
    );
  }
}

class AccountData {
  final String account;
  final String balance;
  final int flags;
  final String ledgerEntryType;
  final int ownerCount;
  final String previousTxnID;
  final String? regularKey;
  final int previousTxnLgrSeq;
  final int sequence;
  final String index;

  AccountData({
    this.regularKey,
    required this.account,
    required this.balance,
    required this.flags,
    required this.ledgerEntryType,
    required this.ownerCount,
    required this.previousTxnID,
    required this.previousTxnLgrSeq,
    required this.sequence,
    required this.index,
  });

  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
        account: json['Account'],
        balance: json['Balance'],
        flags: IntUtils.tryParse(json['Flags'])!,
        ledgerEntryType: json['LedgerEntryType'],
        ownerCount: IntUtils.tryParse(json['OwnerCount'])!,
        previousTxnID: json['PreviousTxnID'],
        previousTxnLgrSeq: IntUtils.tryParse(json['PreviousTxnLgrSeq'])!,
        sequence: IntUtils.tryParse(json['Sequence'])!,
        index: json['index'],
        regularKey: json['RegularKey']);
  }
}

class AccountFlags {
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

  AccountFlags({
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

  factory AccountFlags.fromJson(Map<String, dynamic> json) {
    return AccountFlags(
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
}
