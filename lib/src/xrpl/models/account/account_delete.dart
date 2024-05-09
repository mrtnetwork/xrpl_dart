import 'package:xrpl_dart/src/crypto/crypto.dart';
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

  AccountDelete({
    required String account,
    required this.destination,
    this.destinationTag,
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
            multisigSigners: multisigSigners,
            flags: flags,
            lastLedgerSequence: lastLedgerSequence,
            memos: memos,
            ticketSequance: ticketSequance,
            signer: signer,
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
