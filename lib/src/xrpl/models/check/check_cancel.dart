import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// Represents a `CheckCancel [https://xrpl.org/checkcancel.html](https://xrpl.org/checkcancel.html) transaction,
/// which cancels an unredeemed Check, removing it from the ledger
/// without sending any money. The source or the destination of the check
/// can cancel a Check at any time using this transaction type. If the
/// Check has expired, any address can cancel it.
class CheckCancel extends XRPTransaction {
  final String checkId;

  /// [checkId] The ID of the `Check ledger object. to cash, as a 64-character
  CheckCancel({
    required super.account,
    required this.checkId,
    super.memos,
    super.ticketSequance,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  }) : super(transactionType: XRPLTransactionType.checkCancel);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "check_id", checkId);
    return json;
  }

  CheckCancel.fromJosn(super.json)
      : checkId = json["check_id"],
        super.json();
}
