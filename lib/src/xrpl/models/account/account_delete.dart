import 'package:blockchain_utils/helper/extensions/extensions.dart';
import 'package:blockchain_utils/utils/numbers/utils/int_utils.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents an AccountDelete transaction
/// [AccountDelete transaction](https://xrpl.org/accountdelete.html), which deletes an account and any
/// objects it owns in the XRP Ledger, if possible, sending the account's remaining
/// XRP to a specified destination account.
/// See [Deletion of Accounts](https://xrpl.org/accounts.html#deletion-of-accounts)
/// for the requirements to delete an account.
class AccountDelete extends SubmittableTransaction {
  /// [destination] The address of the account to which to send any remaining XRP.
  final String destination;

  /// The [destinationTag](https://xrpl.org/source-and-destination-tags.html) at the
  /// [destination] account where funds should be sent.
  final int? destinationTag;

  /// [credentialIDs] Set of credentials to authorize a deposit made by this
  /// transaction. Requires the Credentials amendment.
  final List<String>? credentialIDs;

  AccountDelete({
    required super.account,
    required this.destination,
    this.destinationTag,
    List<String>? credentialIDs,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
    super.accountTxId,
    super.delegate,
    super.networkId,
  }) : credentialIDs = credentialIDs?.immutable,
       super(transactionType: SubmittableTransactionType.accountDelete);
  AccountDelete.fromJson(super.json)
    : destination = json['destination'],
      destinationTag = IntUtils.tryParse(json['destination_tag']),
      credentialIDs =
          (json['credential_ids'] as List?)?.map((e) => e as String).toList(),
      super.json();

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['destination'] = destination;
    json['destination_tag'] = destinationTag;
    json['credential_ids'] = credentialIDs;
    return json..removeWhere((key, value) => value == null);
  }
}
