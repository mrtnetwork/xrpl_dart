import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents one entry in a list of multi-signers authorized to an account.
class SignerEntry extends XRPLBase {
  final String account;
  final int signerWeight;

  /// [walletLocator] An arbitrary 256-bit (32-byte) field that can be used to identify the signer, which
  /// may be useful for smart contracts, or for identifying who controls a key in a large
  /// organization.
  final String? walletLocator;

  SignerEntry(
      {required this.account, required this.signerWeight, this.walletLocator});
  SignerEntry.fromJson(Map<String, dynamic> json)
      : account = json['signer_entry']['account'],
        signerWeight = json['signer_entry']['signer_weight'],
        walletLocator = json['signer_entry']['wallet_locator'];

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'signer_entry': {
        'account': account,
        'signer_weight': signerWeight,
        if (walletLocator != null) 'wallet_locator': walletLocator
      }
    };
  }
}

/// Represents a [SignerListSet](https://xrpl.org/signerlistset.html)
/// transaction, which creates, replaces, or removes a list of signers that
/// can be used to [multi-sign a transaction](https://xrpl.org/multi-signing.html) .
class SignerListSet extends XRPTransaction {
  static const int _maxSignerEnteries = 32;

  final int signerQuorum;
  final List<SignerEntry>? signerEntries;

  SignerListSet({
    required super.account,
    required this.signerQuorum,
    this.signerEntries,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: XRPLTransactionType.signerListSet);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'signer_quorum': signerQuorum,
      'signer_entries': (signerEntries?.isEmpty ?? true)
          ? null
          : signerEntries!.map((e) => e.toJson()).toList(),
      ...super.toJson()
    };
  }

  SignerListSet.fromJson(super.json)
      : signerQuorum = json['signer_quorum'],
        signerEntries = (json['signer_entries'] as List?)
            ?.map((e) => SignerEntry.fromJson(e))
            .toList(),
        super.json();

  @override
  String? get validate {
    if (signerQuorum == 0 && signerEntries != null) {
      return 'Must not include a signerEntries value if the signer list is being deleted.';
    }
    if (signerQuorum != 0 && signerEntries == null) {
      return 'Must have a value of zero for signerQuorum if the signer list is being deleted.';
    }

    if (signerEntries == null) {
      return null;
    }

    if (signerQuorum <= 0) {
      return 'signerQuorum must be greater than or equal to 0 when not deleting signer list.';
    }

    if (signerEntries != null &&
        (signerEntries!.isEmpty ||
            signerEntries!.length > _maxSignerEnteries)) {
      return 'signerEntries must have at least 1 member and no more than $_maxSignerEnteries members. If this transaction is deleting the SignerList, then this parameter must be omitted.';
    }

    final Set<String> accountSet = {};
    int signerWeightSum = 0;
    final RegExp hexWalletLocatorRegex = RegExp(r'^[A-Fa-f0-9]{64}$');
    for (final SignerEntry signerEntry in signerEntries ?? []) {
      if (signerEntry.account == account) {
        return 'The account submitting the transaction cannot appear in a signer entry.';
      }
      if (signerEntry.walletLocator != null &&
          !hexWalletLocatorRegex.hasMatch(signerEntry.walletLocator!)) {
        return "A SignerEntry's walletLocator must be a 256-bit (32-byte) hexadecimal value.";
      }
      accountSet.add(signerEntry.account);
      signerWeightSum += signerEntry.signerWeight;
    }

    if (signerQuorum > signerWeightSum) {
      return 'signerQuorum must be less than or equal to the sum of the SignerWeight values in the signerEntries list.';
    }

    if (accountSet.length != signerEntries!.length) {
      return 'An account cannot appear multiple times in the list of signer entries.';
    }
    return null;
  }
}
