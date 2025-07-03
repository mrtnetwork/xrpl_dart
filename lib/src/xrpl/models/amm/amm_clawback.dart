import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Claw back tokens from a holder who has deposited your issued tokens into an AMM
/// pool.
class AMMClawback extends SubmittableTransaction {
  final String holder;
  final IssuedCurrency asset;
  final BaseCurrency asset2;
  final IssuedCurrencyAmount? amount;

  @override
  Map<String, dynamic> toJson() {
    return {
      'holder': holder,
      'asset': asset.toJson(),
      'asset2': asset2.toJson(),
      'amount': amount?.toJson(),
      ...super.toJson()
    }..removeWhere((_, v) => v == null);
  }

  AMMClawback.fromJson(super.json)
      : holder = json['holder'],
        asset = IssuedCurrency.fromJson(json['asset']),
        asset2 = BaseCurrency.fromJson(json['asset2']),
        amount = json["amount"] == null
            ? null
            : IssuedCurrencyAmount.fromJson(json['bid_max']),
        super.json();

  AMMClawback({
    required this.holder,
    required this.asset,
    required this.asset2,
    this.amount,
    required super.account,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: SubmittableTransactionType.ammBid);
  @override
  String? get validate {
    if (account == holder) {
      return "The issuer and holder accounts must be different.";
    }
    if (account != asset.issuer) {
      return "The transaction sender must match the asset issuer.";
    }
    final amount = this.amount;
    if (amount != null &&
        (amount.issuer != asset.issuer || amount.currency != asset.currency)) {
      return "The amount's issuer and currency must match the corresponding asset.";
    }
    return super.validate;
  }
}
