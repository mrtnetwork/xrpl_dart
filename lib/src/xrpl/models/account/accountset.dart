import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// Enum for AccountSet Flags.
///
/// There are several options which can be either enabled or disabled for an account.
/// Account options are represented by different types of flags depending on the
/// situation. The AccountSet transaction type has several "AccountSet Flags" (prefixed
/// `asf`) that can enable an option when passed as the SetFlag parameter, or disable
/// an option when passed as the ClearFlag parameter. This enum represents those
/// options.
///
/// [See AccountSet asf Flags](https://xrpl.org/accountset.html#accountset-flags)
enum AccountSetAsfFlag {
  asfAccountTxnId(5),
  asfDefaultRipple(8),
  asfDepositAuth(9),
  asfDisableMaster(4),
  asfDisallowXrp(3),
  asfGlobalFreeze(7),
  asfNoFreeze(6),
  asfRequireAuth(2),
  asfRequireDest(1),
  asfAuthorizedNftokenMinter(10),
  asfDisableIncomingNftokenOffer(12),
  asfDisableIncomingCheck(13),
  asfDisableIncomingPaychan(14),
  asfDisableIncomingTrustline(15),
  asfAllowTrustlineClawback(16);

  final int value;
  const AccountSetAsfFlag(this.value);
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
enum AccountSetFlag {
  tfRequireDestTag(0x00010000),
  tfOptionalDestTag(0x00020000),
  tfRequireAuth(0x00040000),
  tfOptionalAuth(0x00080000),
  tfDisallowXrp(0x00100000),
  tfAllowXrp(0x00200000);

  final int value;
  const AccountSetFlag(this.value);
}

/// Represents an [AccountSet transaction](https://xrpl.org/accountset.html),
/// which modifies the properties of an account in the XRP Ledger.
class AccountSet extends XRPTransaction {
  /// [clearFlag] Disable a specific AccountSet Flag
  final AccountSetAsfFlag? clearFlag;

  /// [domain] Set the DNS domain of the account owner. Must be hex-encoded. You can
  /// use `xrpl.utils.str_to_hex` to convert a UTF-8 string to hex.
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

  /// [neftTokenMinter] Sets an alternate account that is allowed to mint NFTokens on this
  /// account's behalf using NFTokenMint's `Issuer` field. If set, you must
  /// also set the AccountSetAsfFlag.ASF_AUTHORIZED_NFTOKEN_MINTER flag.
  final String? neftTokenMinter;

  AccountSet({
    required super.account,
    super.ticketSequance,
    super.multiSigSigners,
    super.signingPubKey,
    super.memos,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
    this.clearFlag,
    this.domain,
    this.emailHash,
    this.messageKey,
    this.setFlag,
    this.transferRate,
    this.tickSize,
    this.neftTokenMinter,
  }) : super(transactionType: XRPLTransactionType.accountSet);
  AccountSet.fromJson(super.json)
      : domain = json["domain"],
        emailHash = json["email_hash"],
        messageKey = json["message_key"],
        transferRate = json["transfer_rate"],
        tickSize = json["tick_size"],
        neftTokenMinter = json["nftoken_minter"],
        clearFlag = AccountSetAsfFlag.fromValue(json["clear_flag"]),
        setFlag = AccountSetAsfFlag.fromValue(json["set_flag"]),
        super.json();

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "clear_flag", clearFlag?.value);
    addWhenNotNull(json, "domain", domain);
    addWhenNotNull(json, "email_hash", emailHash);
    addWhenNotNull(json, "message_key", messageKey);
    addWhenNotNull(json, "set_flag", setFlag?.value);
    addWhenNotNull(json, "transfer_rate", transferRate);
    addWhenNotNull(json, "tick_size", tickSize);
    addWhenNotNull(json, "nftoken_minter", neftTokenMinter);
    return json;
  }
}
