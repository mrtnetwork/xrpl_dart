import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// The clawback transaction claws back issued funds from token holders.
class Clawback extends SubmittableTransaction {
  /// [amount] The amount of currency to claw back. The issuer field is used for the token holder's
  /// address, from whom the tokens will be clawed back.
  final BaseAmount amount;

  /// Indicates the AccountID that the issuer wants to clawback. This field is only valid
  /// for clawing back MPTs.
  final String? holder;

  Clawback({
    required super.account,
    required this.amount,
    this.holder,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: SubmittableTransactionType.ammClawback);

  @override
  String? get validate {
    // if (amount.issuer == account) {
    //   return "Holder's address is wrong.";
    // }
    return super.validate;
  }

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {'amount': amount.toJson(), "holder": holder, ...super.toJson()}
      ..removeWhere((_, v) => v == null);
  }

  Clawback.fromJson(super.json)
      : amount = BaseAmount.fromJson(json['amount']),
        holder = json["holder"],
        super.json();
}
