import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/xrpl/models/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// Represents an `[EscrowCreate](https://xrpl.org/escrowcreate.html)
/// transaction, which locks up XRP until a specific time or condition is met.
class EscrowCreate extends XRPTransaction {
  final BigInt amount;
  final String destination;
  final String? destinationTag;
  late final int? cancelAfter;
  late final int? finishAfter;
  final String? condition;
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "amount", amount.toString());
    addWhenNotNull(json, "destination", destination);
    addWhenNotNull(json, "destination_tag", destinationTag);
    addWhenNotNull(json, "cancel_after", cancelAfter);
    addWhenNotNull(json, "finish_after", finishAfter);
    addWhenNotNull(json, "condition", condition);
    return json;
  }

  EscrowCreate.fromJson(Map<String, dynamic> json)
      : amount = parseBigInt(json["amount"])!,
        destination = json["destination"],
        destinationTag = json["destination_tag"],
        cancelAfter = json["cancel_after"],
        finishAfter = json["finish_after"],
        condition = json["condition"],
        super.json(json);

  /// [amount] Amount of XRP, in drops, to deduct from the sender's balance and set aside in escrow
  /// [destination] The address that should receive the escrowed XRP when the time or condition is met
  /// [cancelAfter] when this escrow expires.
  /// This value is immutable; the funds can only be returned the sender after
  /// this time.
  ///
  /// [finishAfter] when the escrowed XRP can
  /// be released to the recipient. This value is immutable; the funds cannot
  /// move until this time is reached.
  ///
  /// [condition] Hex value representing a
  /// [PREIMAGE-SHA-256 crypto-condition](https://tools.ietf.org/html/draft-thomas-crypto-conditions-04#section-8.1.)
  /// The funds can only be delivered to the recipient if this condition is
  /// fulfilled.
  EscrowCreate({
    required super.account,
    required this.amount,
    required this.destination,
    super.memos,
    super.ticketSequance,
    DateTime? cancelAfterTime,
    DateTime? finishAfterTime,
    this.condition,
    this.destinationTag,
    // required super.transactionType,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  })  : assert(() {
          if (cancelAfterTime != null &&
              finishAfterTime != null &&
              finishAfterTime.millisecondsSinceEpoch >=
                  cancelAfterTime.millisecondsSinceEpoch) {
            return false;
          }
          return true;
        }(), "The finish_after time must be before the cancel_after time."),
        super(transactionType: XRPLTransactionType.ESCROW_CREATE) {
    if (cancelAfterTime != null) {
      cancelAfter = datetimeToRippleTime(cancelAfterTime);
    } else {
      cancelAfter = null;
    }
    if (finishAfterTime != null) {
      finishAfter = datetimeToRippleTime(finishAfterTime);
    } else {
      finishAfter = null;
    }
  }
}
