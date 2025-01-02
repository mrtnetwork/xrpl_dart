import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// The clawback transaction claws back issued funds from token holders.
class Clawback extends XRPTransaction {
  /// [amount] The amount of currency to claw back. The issuer field is used for the token holder's
  /// address, from whom the tokens will be clawed back.
  final IssuedCurrencyAmount amount;

  Clawback({
    required super.account,
    required this.amount,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: XRPLTransactionType.clawback);

  @override
  String? get validate {
    if (amount.issuer == account) {
      return "Holder's address is wrong.";
    }
    return super.validate;
  }

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {'amount': amount.toJson(), ...super.toJson()};
  }

  Clawback.fromJson(super.json)
      : amount = IssuedCurrencyAmount.fromJson(json['amount']),
        super.json();
}
