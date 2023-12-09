import 'package:xrp_dart/src/xrpl/models/currencies/currencies.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// Represents a `CheckCash transaction [https://xrpl.org/checkcash.html](https://xrpl.org/checkcash.html),
/// which redeems a Check object to receive up to the amount authorized by the
/// corresponding CheckCreate transaction. Only the Destination address of a
/// Check can cash it.
class CheckCash extends XRPTransaction {
  final String checkId;
  final CurrencyAmount? amount;
  final CurrencyAmount? deliverMin;

  /// [checkId] The ID of the `Check ledger object. to cash, as a 64-character
  /// hexadecimal strin
  /// [amount] Redeem the Check for exactly this amount, if possible. The currency must
  /// match that of the SendMax of the corresponding CheckCreate transaction.
  /// You must provide either this field or ``DeliverMin``.
  /// [deliverMin] Redeem the Check for at least this amount and for as much as possible.
  /// The currency must match that of the ``SendMax`` of the corresponding
  /// CheckCreate transaction. You must provide either this field or ``Amount``.
  CheckCash({
    required super.account,
    required this.checkId,
    super.memos,
    super.ticketSequance,
    this.amount,
    this.deliverMin,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  }) : super(transactionType: XRPLTransactionType.checkCash);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "check_id", checkId);
    addWhenNotNull(json, "amount", amount?.toJson());
    addWhenNotNull(json, "deliver_min", deliverMin?.toJson());
    return json;
  }

  CheckCash.fromJson(super.json)
      : checkId = json["check_id"],
        amount = json["amount"] == null
            ? null
            : CurrencyAmount.fromJson(json["amount"]),
        deliverMin = json["deliver_min"] == null
            ? null
            : CurrencyAmount.fromJson(json["deliver_min"]),
        super.json();
}
