import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

class AccountSetConst {
  static const int maxTransferRate = 2000000000;
  static const int minTransferRate = 1000000000;
  static const int specialCaseTransferRate = 0;

  static const int minTickSize = 3;
  static const int maxTickSize = 15;
  static const int disableTickSize = 0;

  static const int maxDomainLength = 256;
}

/// Enum for AccountSet Flags.
///
/// There are several options which can be either enabled or disabled for an account.
/// Account options are represented by different types of flags depending on the
/// situation. The AccountSet transaction type has several "AccountSet Flags" (prefixed
/// asf) that can enable an option when passed as the SetFlag parameter, or disable
/// an option when passed as the ClearFlag parameter. This enum represents those
/// options.
///
/// [See AccountSet asf Flags](https://xrpl.org/accountset.html#accountset-flags)
class AccountSetAsfFlag implements FlagsInterface {
  /// Track the ID of this account's most recent transaction. Required for
  /// [AccountTxnID](https://xrpl.org/transaction-common-fields.html#accounttxnid)
  static const AccountSetAsfFlag asfAccountTxnId =
      AccountSetAsfFlag('AccountTxnId', 5);

  /// Enable [rippling](https://xrpl.org/rippling.html) on this account's trust lines by default.
  static const AccountSetAsfFlag asfDefaultRipple =
      AccountSetAsfFlag('DefaultRipple', 8);

  /// Enable [Deposit Authorization](https://xrpl.org/depositauth.html) on this account.
  static const AccountSetAsfFlag asfDepositAuth =
      AccountSetAsfFlag('DepositAuth', 9);

  /// Disallow use of the master key pair. Can only be enabled if the account has
  /// configured another way to sign transactions, such as a [Regular Key](https://xrpl.org/cryptographic-keys.html)
  /// or a [Signer List](https://xrpl.org/multi-signing.html)
  static const AccountSetAsfFlag asfDisableMaster =
      AccountSetAsfFlag('DisableMaster', 4);

  /// XRP should not be sent to this account. (Enforced by client applications)
  static const AccountSetAsfFlag asfDisallowXrp =
      AccountSetAsfFlag('DisallowXrp', 3);

  /// [Freeze](https://xrpl.org/freezes.html) all assets issued by this account.
  static const AccountSetAsfFlag asfGlobalFreeze =
      AccountSetAsfFlag('GlobalFreeze', 7);

  /// Permanently give up the ability to freeze individual trust lines or disable
  /// [Global Freeze](https://xrpl.org/freezes.html). This flag can never be disabled
  /// after being enabled.
  static const AccountSetAsfFlag asfNoFreeze = AccountSetAsfFlag('NoFreeze', 6);

  /// Require authorization for users to hold balances issued by this address. Can
  /// only be enabled if the address has no trust lines connected to it.
  static const AccountSetAsfFlag asfRequireAuth =
      AccountSetAsfFlag('RequireAuth', 2);

  /// Require a destination tag to send transactions to this account.
  static const AccountSetAsfFlag asfRequireDest =
      AccountSetAsfFlag('RequireDest', 1);

  /// Allow another account to mint and burn tokens on behalf of this account.
  static const AccountSetAsfFlag asfAuthorizedNftokenMinter =
      AccountSetAsfFlag('AuthorizedNftokenMinter', 10);

  /// Disallow other accounts from creating NFTokenOffers directed at this account.
  static const AccountSetAsfFlag asfDisableIncomingNftokenOffer =
      AccountSetAsfFlag('DisableIncomingNftokenOffer', 12);

  /// Disallow other accounts from creating Checks directed at this account.
  static const AccountSetAsfFlag asfDisableIncomingCheck =
      AccountSetAsfFlag('DisableIncomingCheck', 13);

  /// Disallow other accounts from creating PayChannels directed at this account.
  static const AccountSetAsfFlag asfDisableIncomingPaychan =
      AccountSetAsfFlag('DisableIncomingPaychan', 14);

  /// Disallow other accounts from creating Trustlines directed at this account.
  static const AccountSetAsfFlag asfDisableIncomingTrustline =
      AccountSetAsfFlag('DisableIncomingTrustline', 15);

  /// Allow trustline clawback feature
  static const AccountSetAsfFlag asfAllowTrustlineClawback =
      AccountSetAsfFlag('AllowTrustlineClawback', 16);

  /// human-readable name
  final String name;

  /// flag id
  final int value;

  // Constructor for AccountSetAsfFlag.
  const AccountSetAsfFlag(this.name, this.value);
  @override
  int get id => value;

  static const List<AccountSetAsfFlag> values = [
    asfAccountTxnId,
    asfDefaultRipple,
    asfDepositAuth,
    asfDisableMaster,
    asfDisallowXrp,
    asfGlobalFreeze,
    asfNoFreeze,
    asfRequireAuth,
    asfRequireDest,
    asfAuthorizedNftokenMinter,
    asfDisableIncomingNftokenOffer,
    asfDisableIncomingCheck,
    asfDisableIncomingPaychan,
    asfDisableIncomingTrustline,
    asfAllowTrustlineClawback
  ];

  // Method to get the enum instance from its value.
  static AccountSetAsfFlag? fromValue(int? value) {
    if (value == null) return null;
    try {
      return values.firstWhere((element) => element.value == value);
    } on StateError {
      return null;
    }
  }
}

/// Enum for AccountSet Transaction Flags.
/// Transactions of the AccountSet type support additional values in the Flags field.
/// This enum represents those options.
/// [See AccountSet tf Flags](https://xrpl.org/accountset.html#accountset-flags)
class AccountSetFlag {
  // Require a destination tag to send transactions to this account.
  static const AccountSetFlag tfRequireDestTag = AccountSetFlag._(0x00010000);

  // Allow an optional destination tag when sending transactions to this account.
  static const AccountSetFlag tfOptionalDestTag = AccountSetFlag._(0x00020000);

  // Require authorization for users to hold balances issued by this address.
  static const AccountSetFlag tfRequireAuth = AccountSetFlag._(0x00040000);

  // Allow optional authorization for users to hold balances issued by this address.
  static const AccountSetFlag tfOptionalAuth = AccountSetFlag._(0x00080000);

  // Disallow XRP to be sent to this account.
  static const AccountSetFlag tfDisallowXrp = AccountSetFlag._(0x00100000);

  // Allow XRP to be sent to this account.
  static const AccountSetFlag tfAllowXrp = AccountSetFlag._(0x00200000);

  // The integer value associated with each flag.
  final int value;

  // Constructor for AccountSetFlag.
  const AccountSetFlag._(this.value);
}

/// Represents an [AccountSet transaction](https://xrpl.org/accountset.html),
/// which modifies the properties of an account in the XRP Ledger.
class AccountSet extends XRPTransaction {
  /// [clearFlag] Disable a specific AccountSet Flag
  final AccountSetAsfFlag? clearFlag;

  /// [domain] Set the DNS domain of the account owner. Must be hex-encoded
  /// BytesUtils.toHexString(utf8.encode("https://github.com/mrtnetwork/xrpl_dart")).
  final String? domain;

  /// [emailHash] Set the MD5 Hash to be used for generating an avatar image for this
  /// account.
  final String? emailHash;

  /// [messageKey] Set a public key for sending encrypted messages to this account.
  final String? messageKey;

  /// [setFlag] Enable a specific AccountSet Flag
  final AccountSetAsfFlag? setFlag;

  /// [transferRate] Set the transfer fee to use for tokens issued by this account. See
  /// [TransferRate](https://xrpl.org/accountset.html#transferrate) for
  /// details.
  final int? transferRate;

  /// [tickSize] Set the tick size to use when trading tokens issued by this account in
  /// the decentralized exchange. See [Tick Size](https://xrpl.org/ticksize.html).
  final int? tickSize;

  /// [nftTokenMinter] Sets an alternate account that is allowed to mint NFTokens on this
  /// account's behalf using NFTokenMint's Issuer field. If set, you must
  /// also set the AccountSetAsfFlag.ASF_AUTHORIZED_NFTOKEN_MINTER flag.
  final String? nftTokenMinter;

  AccountSet({
    required super.account,
    this.clearFlag,
    this.domain,
    this.emailHash,
    this.messageKey,
    this.setFlag,
    this.transferRate,
    this.tickSize,
    this.nftTokenMinter,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: XRPLTransactionType.accountSet);
  AccountSet.fromJson(super.json)
      : domain = json['domain'],
        emailHash = json['email_hash'],
        messageKey = json['message_key'],
        transferRate = json['transfer_rate'],
        tickSize = json['tick_size'],
        nftTokenMinter = json['nftoken_minter'],
        clearFlag = AccountSetAsfFlag.fromValue(json['clear_flag']),
        setFlag = AccountSetAsfFlag.fromValue(json['set_flag']),
        super.json();

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'clear_flag': clearFlag?.value,
      'domain': domain,
      'email_hash': emailHash,
      'message_key': messageKey,
      'set_flag': setFlag?.value,
      'transfer_rate': transferRate,
      'tick_size': tickSize,
      'nftoken_minter': nftTokenMinter,
      ...super.toJson()
    };
  }

  @override
  String? get validate {
    return _getTickSizeError() ??
        _getTransferRateError() ??
        _getDomainError() ??
        _getClearFlagError() ??
        _getNftokenMinterError() ??
        super.validate;
  }

  String? _getTickSizeError() {
    if (tickSize == null) {
      return null;
    }
    if (tickSize! > AccountSetConst.maxTickSize) {
      return 'tick_size is above ${AccountSetConst.maxTickSize}.';
    }
    if (tickSize! < AccountSetConst.minTickSize &&
        tickSize! != AccountSetConst.disableTickSize) {
      return 'tick_size is below ${AccountSetConst.minTickSize}.';
    }
    return null;
  }

  String? _getTransferRateError() {
    if (transferRate == null) {
      return null;
    }
    if (transferRate! > AccountSetConst.maxTransferRate) {
      return 'transfer_rate is above ${AccountSetConst.maxTransferRate}.';
    }
    if (transferRate! < AccountSetConst.minTransferRate &&
        transferRate! != AccountSetConst.specialCaseTransferRate) {
      return 'transfer_rate is below ${AccountSetConst.minTransferRate}.';
    }
    return null;
  }

  String? _getDomainError() {
    if (domain != null && domain!.toLowerCase() != domain) {
      return 'Domain $domain is not lowercase';
    }
    if (domain != null && domain!.length > AccountSetConst.maxDomainLength) {
      return 'Must not be longer than ${AccountSetConst.maxDomainLength} characters';
    }
    return null;
  }

  String? _getClearFlagError() {
    if (clearFlag != null && clearFlag == setFlag) {
      return 'Must not be equal to the set_flag';
    }
    return null;
  }

  String? _getNftokenMinterError() {
    if (setFlag != AccountSetAsfFlag.asfAuthorizedNftokenMinter &&
        nftTokenMinter != null) {
      return 'Will not set the minter unless AccountSetAsfFlag.ASF_AUTHORIZED_NFTOKEN_MINTER is set';
    }
    if (setFlag == AccountSetAsfFlag.asfAuthorizedNftokenMinter &&
        nftTokenMinter == null) {
      return 'Must be present if AccountSetAsfFlag.ASF_AUTHORIZED_NFTOKEN_MINTER is set';
    }
    if (clearFlag == AccountSetAsfFlag.asfAuthorizedNftokenMinter &&
        nftTokenMinter != null) {
      return 'Must not be present if AccountSetAsfFlag.ASF_AUTHORIZED_NFTOKEN_MINTER is unset using clear_flag';
    }
    return null;
  }
}
