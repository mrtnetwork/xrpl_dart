import 'package:xrp_dart/src/xrpl/models/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// Represents an `AccountDelete transaction
/// [https://xrpl.org/accountdelete.html](https://xrpl.org/accountdelete.html), which deletes an account and any
/// objects it owns in the XRP Ledger, if possible, sending the account's remaining
/// XRP to a specified destination account.
/// See `Deletion of Accounts
/// [https://xrpl.org/accounts.html#deletion-of-accounts](https://xrpl.org/accounts.html#deletion-of-accounts)
/// for the requirements to delete an account.
class AccountDelete extends XRPTransaction {
  final String destination;
  final String? destinationTag;

  /// [destination] The address of the account to which to send any remaining XRP.
  AccountDelete({
    required super.account,
    required this.destination,
    this.destinationTag,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  }) : super(transactionType: XRPLTransactionType.ACCOUNT_DELETE);
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "destination", destination);
    addWhenNotNull(json, "destination_tag", destinationTag);
    return json;
  }

  AccountDelete.fromJson(Map<String, dynamic> json)
      : destination = json["destination"],
        destinationTag = json["destination_tag"],
        super.json(json);
}