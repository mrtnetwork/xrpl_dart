// ignore_for_file: constant_identifier_names

import 'package:xrp_dart/src/xrpl/models/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/transaction_types.dart';
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
  ASF_ACCOUNT_TXN_ID(5),
  ASF_DEFAULT_RIPPLE(8),
  ASF_DEPOSIT_AUTH(9),
  ASF_DISABLE_MASTER(4),
  ASF_DISALLOW_XRP(3),
  ASF_GLOBAL_FREEZE(7),
  ASF_NO_FREEZE(6),
  ASF_REQUIRE_AUTH(2),
  ASF_REQUIRE_DEST(1),
  ASF_AUTHORIZED_NFTOKEN_MINTER(10),
  ASF_DISABLE_INCOMING_NFTOKEN_OFFER(12),
  ASF_DISABLE_INCOMING_CHECK(13),
  ASF_DISABLE_INCOMING_PAYCHAN(14),
  ASF_DISABLE_INCOMING_TRUSTLINE(15),
  ASF_ALLOW_TRUSTLINE_CLAWBACK(16);

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
  TF_REQUIRE_DEST_TAG(0x00010000),
  TF_OPTIONAL_DEST_TAG(0x00020000),
  TF_REQUIRE_AUTH(0x00040000),
  TF_OPTIONAL_AUTH(0x00080000),
  TF_DISALLOW_XRP(0x00100000),
  TF_ALLOW_XRP(0x00200000);

  final int value;
  const AccountSetFlag(this.value);
}

/// Represents an [AccountSet transaction](https://xrpl.org/accountset.html),
/// which modifies the properties of an account in the XRP Ledger.
class AccountSet extends XRPTransaction {
  /// [clearFlag] Disable a specific AccountSet Flag
  ///
  /// [domain] Set the DNS domain of the account owner. Must be hex-encoded. You can
  /// use `xrpl.utils.str_to_hex` to convert a UTF-8 string to hex.
  ///
  /// [emailHash] Set the MD5 Hash to be used for generating an avatar image for this
  /// account.
  /// [messageKey] Set a public key for sending encrypted messages to this account.
  /// [setFlag] Enable a specific AccountSet Flag
  ///
  /// [transferRate] Set the transfer fee to use for tokens issued by this account. See
  /// [TransferRate](https://xrpl.org/accountset.html#transferrate) for
  /// details.
  ///
  /// [tickSize] Set the tick size to use when trading tokens issued by this account in
  /// the decentralized exchange. See [Tick Size](https://xrpl.org/ticksize.html).
  ///
  /// [neftTokenMinter] Sets an alternate account that is allowed to mint NFTokens on this
  /// account's behalf using NFTokenMint's `Issuer` field. If set, you must
  /// also set the AccountSetAsfFlag.ASF_AUTHORIZED_NFTOKEN_MINTER flag.
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
  }) : super(transactionType: XRPLTransactionType.ACCOUNT_SET);
  final AccountSetAsfFlag? clearFlag;
  final String? domain;
  final String? emailHash;
  final String? messageKey;
  final AccountSetAsfFlag? setFlag;
  final int? transferRate;
  final int? tickSize;
  final String? neftTokenMinter;
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

  AccountSet.fromJson(Map<String, dynamic> json)
      : domain = json["domain"],
        emailHash = json["email_hash"],
        messageKey = json["message_key"],
        transferRate = json["transfer_rate"],
        tickSize = json["tick_size"],
        neftTokenMinter = json["nftoken_minter"],
        clearFlag = AccountSetAsfFlag.fromValue(json["clear_flag"]),
        setFlag = AccountSetAsfFlag.fromValue(json["set_flag"]),
        super.json(json);
}
