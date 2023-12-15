import 'package:xrp_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents a [SetRegularKey](https://xrpl.org/setregularkey.html)
/// transaction, which assigns, changes, or removes a secondary "regular" key pair
/// associated with an account.
class SetRegularKey extends XRPTransaction {
  /// [regularKey] The classic address derived from the key pair to authorize for this
  /// account. If omitted, removes any existing regular key pair from the
  /// account. Must not match the account's master key pair.
  final String? regularKey;

  SetRegularKey(
      {this.regularKey,
      required String account,
      List<XRPLMemo>? memos = const [],
      String signingPubKey = "",
      int? ticketSequance,
      BigInt? fee,
      int? lastLedgerSequence,
      int? sequence,
      List<XRPLSigners>? signers,
      dynamic flags,
      int? sourceTag,
      List<String> multiSigSigners = const []})
      : super(
            account: account,
            fee: fee,
            lastLedgerSequence: lastLedgerSequence,
            memos: memos,
            sequence: sequence,
            signers: signers,
            sourceTag: sourceTag,
            flags: flags,
            ticketSequance: ticketSequance,
            signingPubKey: signingPubKey,
            multiSigSigners: multiSigSigners,
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
