import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents an AccountDelete transaction
/// [AccountDelete transaction](https://xrpl.org/accountdelete.html), which deletes an account and any
/// objects it owns in the XRP Ledger, if possible, sending the account's remaining
/// XRP to a specified destination account.
/// See [Deletion of Accounts](https://xrpl.org/accounts.html#deletion-of-accounts)
/// for the requirements to delete an account.
class AccountDelete extends XRPTransaction {
  /// [destination] The address of the account to which to send any remaining XRP.
  final String destination;

  /// The [destinationTag](https://xrpl.org/source-and-destination-tags.html) at the
  /// [destination] account where funds should be sent.
  final String? destinationTag;

  AccountDelete(
      {required String account,
      required this.destination,
      this.destinationTag,
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
            multiSigSigners: multiSigSigners,
            signers: signers,
            flags: flags,
            lastLedgerSequence: lastLedgerSequence,
            memos: memos,
            ticketSequance: ticketSequance,
            signingPubKey: signingPubKey,
            sequence: sequence,
            sourceTag: sourceTag,
            transactionType: XRPLTransactionType.accountDelete);
  AccountDelete.fromJson(Map<String, dynamic> json)
      : destination = json["destination"],
        destinationTag = json["destination_tag"],
        super.json(json);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json["destination"] = destination;
    json["destination_tag"] = destinationTag;
    return json;
  }
}
