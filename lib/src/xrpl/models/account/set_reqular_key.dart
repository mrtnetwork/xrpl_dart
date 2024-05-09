import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'package:xrpl_dart/src/crypto/crypto.dart';

/// Represents a [SetRegularKey](https://xrpl.org/setregularkey.html)
/// transaction, which assigns, changes, or removes a secondary "regular" key pair
/// associated with an account.
class SetRegularKey extends XRPTransaction {
  /// [regularKey] The classic address derived from the key pair to authorize for this
  /// account. If omitted, removes any existing regular key pair from the
  /// account. Must not match the account's master key pair.
  final String? regularKey;

  SetRegularKey({
    this.regularKey,
    required String account,
    List<XRPLMemo>? memos = const [],
    XRPLSignature? signer,
    int? ticketSequance,
    BigInt? fee,
    int? lastLedgerSequence,
    int? sequence,
    List<XRPLSigners>? multisigSigners,
    int? flags,
    int? sourceTag,
  }) : super(
            account: account,
            fee: fee,
            lastLedgerSequence: lastLedgerSequence,
            memos: memos,
            sequence: sequence,
            multisigSigners: multisigSigners,
            sourceTag: sourceTag,
            flags: flags,
            ticketSequance: ticketSequance,
            signer: signer,
            transactionType: XRPLTransactionType.setRegularKey);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      "regular_key": regularKey,
      ...super.toJson(),
    };
  }

  SetRegularKey.fromJson(Map<String, dynamic> json)
      : regularKey = json["regular_key"],
        super.json(json);
}
