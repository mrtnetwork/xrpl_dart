import 'package:xrp_dart/src/xrpl/models/xrp_transactions.dart';

/// The clawback transaction claws back issued funds from token holders.
class Clawback extends XRPTransaction {
  /// [amount] The amount of currency to claw back. The issuer field is used for the token holder's
  /// address, from whom the tokens will be clawed back.
  final IssuedCurrencyAmount amount;

  Clawback(
      {required String account,
      required this.amount,
      List<XRPLMemo>? memos = const [],
      String signingPubKey = "",
      int? ticketSequance,
      BigInt? fee,
      int? lastLedgerSequence,
      int? sequence,
      List<XRPLSigners>? signers,
      dynamic flags,
      int? sourceTag,
      List<String> multiSigSigners = const []})
      : super(
            account: account,
            fee: fee,
            lastLedgerSequence: lastLedgerSequence,
            memos: memos,
            sequence: sequence,
            signers: signers,
            sourceTag: sourceTag,
            flags: flags,
            ticketSequance: ticketSequance,
            signingPubKey: signingPubKey,
            multiSigSigners: multiSigSigners,
            transactionType: XRPLTransactionType.clawback);

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
    return {"amount": amount.toJson(), ...super.toJson()};
  }

  Clawback.fromJson(Map<String, dynamic> json)
      : amount = IssuedCurrencyAmount.fromJson(json["amount"]),
        super.json(json);
}
