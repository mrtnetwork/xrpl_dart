// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:xrp_dart/src/xrpl/models/currencies/currencies.dart';
import 'package:xrp_dart/src/xrpl/models/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// Transactions of the AMMDeposit type support additional values in the Flags field.
/// This enum represents those options.
enum AMMDepositFlag {
  TF_LP_TOKEN(0x00010000),
  TF_SINGLE_ASSET(0x00080000),
  TF_TWO_ASSET(0x00100000),
  TF_ONE_ASSET_LP_TOKEN(0x00200000),
  TF_LIMIT_LP_TOKEN(0x00400000);

  final int value;
  const AMMDepositFlag(this.value);
}

class AMMDepositFlagInterface {
  AMMDepositFlagInterface(
      {required this.TF_LP_TOKEN,
      required this.TF_SINGLE_ASSET,
      required this.TF_TWO_ASSET,
      required this.TF_ONE_ASSET_LP_TOKEN,
      required this.TF_LIMIT_LP_TOKEN});
  final bool TF_LP_TOKEN;
  final bool TF_SINGLE_ASSET;
  final bool TF_TWO_ASSET;
  final bool TF_ONE_ASSET_LP_TOKEN;
  final bool TF_LIMIT_LP_TOKEN;
}

/// Deposit funds into an Automated Market Maker (AMM) instance
/// and receive the AMM's liquidity provider tokens (LP Tokens) in exchange.
///
/// You can deposit one or both of the assets in the AMM's pool.
/// If successful, this transaction creates a trust line to the AMM Account (limit 0)
/// to hold the LP Tokens.
class AMMDeposit extends XRPTransaction {
  /// [asset] The definition for one of the assets in the AMM's pool.
  /// [asset2] The definition for the other asset in the AMM's pool.
  ///
  /// [amount] The amount of one asset to deposit to the AMM.
  /// If present, this must match the type of one of the assets (tokens or XRP)
  /// in the AMM's pool.
  ///
  /// [amount2] The amount of another asset to add to the AMM.
  /// If present, this must match the type of the other asset in the AMM's pool
  /// and cannot be the same asset as Amount.
  ///
  /// [ePrice] The maximum effective price, in the deposit asset, to pay
  /// for each LP Token received.
  ///
  /// [lpTokenOut] How many of the AMM's LP Tokens to buy.
  AMMDeposit({
    required super.account,
    required this.asset,
    required this.asset2,
    super.memos,
    super.ticketSequance,
    this.amount,
    this.amount2,
    this.ePrice,
    this.lpTokenOut,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  }) : super(transactionType: XRPLTransactionType.AMM_DEPOSIT) {
    final err = _getError();
    assert(err == null, err);
  }
  final XRPCurrencies asset;
  final XRPCurrencies asset2;
  final CurrencyAmount? amount;
  final CurrencyAmount? amount2;
  final CurrencyAmount? ePrice;
  final IssuedCurrencyAmount? lpTokenOut;
  AMMDeposit.fromJson(Map<String, dynamic> json)
      : asset = XRPCurrencies.fromJson(json["asset"]),
        asset2 = XRPCurrencies.fromJson(json["asset2"]),
        amount = json["amount"] == null
            ? null
            : CurrencyAmount.fromJson(json["amount"]),
        amount2 = json["amount2"] == null
            ? null
            : CurrencyAmount.fromJson(json["amount2"]),
        ePrice = json["e_price"] == null
            ? null
            : CurrencyAmount.fromJson(json["e_price"]),
        lpTokenOut = json["lp_token_out"] == null
            ? null
            : IssuedCurrencyAmount.fromJson(json["lp_token_out"]),
        super.json(json);
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "asset", asset.toJson());
    addWhenNotNull(json, "asset2", asset2.toJson());
    addWhenNotNull(json, "amount", amount?.toJson());
    addWhenNotNull(json, "amount2", amount2?.toJson());
    addWhenNotNull(json, "e_price", ePrice?.toJson());
    addWhenNotNull(json, "lp_token_out", lpTokenOut?.toJson());

    return json;
  }

  String? _getError() {
    if (amount2 != null && amount == null) {
      return "Must set `amount` with `amount2`";
    } else if (ePrice != null && amount == null) {
      return "Must set `amount` with `e_price`";
    } else if (lpTokenOut != null && amount == null) {
      return "Must set at least `lp_token_out` or `amount`";
    }
    return null;
  }
}
