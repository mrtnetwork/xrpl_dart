import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// Represents a [SetRegularKey](https://xrpl.org/setregularkey.html)
/// transaction, which assigns, changes, or removes a secondary "regular" key pair
/// associated with an account.
class SetRegularKey extends XRPTransaction {
  final String? regularKey;

  /// [regularKey] The classic address derived from the key pair to authorize for this
  /// account. If omitted, removes any existing regular key pair from the
  /// account. Must not match the account's master key pair.
  SetRegularKey({
    required super.account,
    super.memos,
    this.regularKey,
    super.ticketSequance,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  }) : super(transactionType: XRPLTransactionType.SET_REGULAR_KEY);
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "regular_key", regularKey);
    return json;
  }

  SetRegularKey.fromJson(Map<String, dynamic> json)
      : regularKey = json["regular_key"],
        super.json(json);
}
