import 'package:blockchain_utils/utils/utils.dart';
import 'package:xrpl_dart/src/utility/helper.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'package:xrpl_dart/src/crypto/crypto.dart';

/// Represents an [EscrowCreate](https://xrpl.org/escrowcreate.html)
/// transaction, which locks up XRP until a specific time or condition is met.
class EscrowCreate extends XRPTransaction {
  /// [amount] Amount of XRP, in drops, to deduct from the sender's balance and set aside in escrow
  final BigInt amount;

  /// [destination] The address that should receive the escrowed XRP when the time or condition is met
  final String destination;

  /// [cancelAfter] when this escrow expires.
  /// This value is immutable; the funds can only be returned the sender after
  /// this time.
  late final int? cancelAfter;

  /// [finishAfter] when the escrowed XRP can
  /// be released to the recipient. This value is immutable; the funds cannot
  /// move until this time is reached.
  late final int? finishAfter;

  /// [condition] Hex value representing a
  /// [PREIMAGE-SHA-256 crypto-condition](https://tools.ietf.org/html/draft-thomas-crypto-conditions-04#section-8.1.)
  /// The funds can only be delivered to the recipient if this condition is
  /// fulfilled.
  final String? condition;
  final String? destinationTag;

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      "amount": amount.toString(),
      "destination": destination,
      "destination_tag": destinationTag,
      "cancel_after": cancelAfter,
      "finish_after": finishAfter,
      "condition": condition,
      ...super.toJson()
    };
  }

  EscrowCreate.fromJson(Map<String, dynamic> json)
      : amount = BigintUtils.tryParse(json["amount"])!,
        destination = json["destination"],
        destinationTag = json["destination_tag"],
        cancelAfter = json["cancel_after"],
        finishAfter = json["finish_after"],
        condition = json["condition"],
        super.json(json);

  EscrowCreate({
    required String account,
    required this.amount,
    required this.destination,
    DateTime? cancelAfterTime,
    DateTime? finishAfterTime,
    this.condition,
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
            lastLedgerSequence: lastLedgerSequence,
            memos: memos,
            sequence: sequence,
            multisigSigners: multisigSigners,
            sourceTag: sourceTag,
            flags: flags,
            ticketSequance: ticketSequance,
            signer: signer,
            transactionType: XRPLTransactionType.escrowCreate) {
    if (cancelAfterTime != null) {
      cancelAfter = XRPHelper.datetimeToRippleTime(cancelAfterTime);
    } else {
      cancelAfter = null;
    }
    if (finishAfterTime != null) {
      finishAfter = XRPHelper.datetimeToRippleTime(finishAfterTime);
    } else {
      finishAfter = null;
    }
  }
  @override
  String? get validate {
    if (cancelAfter != null &&
        finishAfter != null &&
        finishAfter! >= cancelAfter!) {
      return "The finishAfter time must be before the cancelAfter time.";
    }
    return super.validate;
  }
}
