// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:xrp_dart/src/xrpl/models/base/base.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// Represents one entry in a list of multi-signers authorized to an account.
class SignerEntry extends XrplNestedModel {
  /// [walletLocator] An arbitrary 256-bit (32-byte) field that can be used to identify the signer, which
  /// may be useful for smart contracts, or for identifying who controls a key in a large
  /// organization.
  SignerEntry(
      {required this.account, required this.signerWeight, this.walletLocator});
  SignerEntry.fromJson(Map<String, dynamic> json)
      : account = json["signer_entry"]["account"],
        signerWeight = json["signer_entry"]["signer_weight"],
        walletLocator = json["signer_entry"]["wallet_locator"];
  final String account;
  final int signerWeight;

  final String? walletLocator;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    addWhenNotNull(json, "account", account);
    addWhenNotNull(json, "signer_weight", signerWeight);
    addWhenNotNull(json, "wallet_locator", walletLocator);
    return {"signer_entry": json};
  }
}

/// Represents a [SignerListSet](https://xrpl.org/signerlistset.html)
/// transaction, which creates, replaces, or removes a list of signers that
/// can be used to [multi-sign a transaction](https://xrpl.org/multi-signing.html) .
class SignerListSet extends XRPTransaction {
  static const int MAX_SIGNER_ENTRIES = 32;

  final int signerQuorum;
  final List<SignerEntry>? signerEntries;

  SignerListSet({
    required super.account,
    required this.signerQuorum,
    super.memos,
    super.ticketSequance,
    this.signerEntries,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  }) : super(transactionType: XRPLTransactionType.SIGNER_LIST_SET) {
    final err = _getErrors();
    assert(err == null, err);
  }
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "signer_quorum", signerQuorum);
    addWhenNotNull(
        json,
        "signer_entries",
        (signerEntries?.isEmpty ?? true)
            ? null
            : signerEntries!.map((e) => e.toJson()).toList());
    return json;
  }

  SignerListSet.fromJson(Map<String, dynamic> json)
      : signerQuorum = json["signer_quorum"],
        signerEntries = (json["signer_entries"] as List?)
            ?.map((e) => SignerEntry.fromJson(e))
            .toList(),
        super.json(json);

  String? _getErrors() {
    if (signerQuorum == 0 && signerEntries != null) {
      return "Must not include a `signerEntries` value if the signer list is being deleted.";
    }
    if (signerQuorum != 0 && signerEntries == null) {
      return "Must have a value of zero for `signerQuorum` if the signer list is being deleted.";
    }

    if (signerEntries == null) {
      return null;
    }

    if (signerQuorum <= 0) {
      return "`signerQuorum` must be greater than or equal to 0 when not deleting signer list.";
    }

    if (signerEntries != null &&
        (signerEntries!.isEmpty ||
            signerEntries!.length > MAX_SIGNER_ENTRIES)) {
      return "`signerEntries` must have at least 1 member and no more than $MAX_SIGNER_ENTRIES members. If this transaction is deleting the SignerList, then this parameter must be omitted.";
    }

    Set<String> accountSet = {};
    int signerWeightSum = 0;
    final RegExp HEX_WALLET_LOCATOR_REGEX = RegExp(r'^[A-Fa-f0-9]{64}$');
    for (SignerEntry signerEntry in signerEntries ?? []) {
      if (signerEntry.account == account) {
        return "The account submitting the transaction cannot appear in a signer entry.";
      }
      if (signerEntry.walletLocator != null &&
          !HEX_WALLET_LOCATOR_REGEX.hasMatch(signerEntry.walletLocator!)) {
        return "A SignerEntry's walletLocator must be a 256-bit (32-byte) hexadecimal value.";
      }
      accountSet.add(signerEntry.account);
      signerWeightSum += signerEntry.signerWeight;
    }

    if (signerQuorum > signerWeightSum) {
      return "`signerQuorum` must be less than or equal to the sum of the SignerWeight values in the `signerEntries` list.";
    }

    if (accountSet.length != signerEntries!.length) {
      return "An account cannot appear multiple times in the list of signer entries.";
    }
    return null;
  }
}
