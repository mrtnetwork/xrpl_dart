// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:xrp_dart/src/xrpl/models/currencies/currencies.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// The clawback transaction claws back issued funds from token holders.
class Clawback extends XRPTransaction {
  final IssuedCurrencyAmount amount;

  /// [amount] The amount of currency to claw back. The issuer field is used for the token holder's
  /// address, from whom the tokens will be clawed back.
  Clawback({
    required super.account,
    required this.amount,
    super.memos,
    super.ticketSequance,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  })  : assert(() {
          if (amount.issuer == account) {
            return false;
          }
          return true;
        }(), "Holder's address is wrong."),
        super(transactionType: XRPLTransactionType.CLAWBACK);
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "amount", amount.toJson());
    return json;
  }

  Clawback.fromJson(Map<String, dynamic> json)
      : amount = IssuedCurrencyAmount.fromJson(json["amount"]),
        super.json(json);
}
