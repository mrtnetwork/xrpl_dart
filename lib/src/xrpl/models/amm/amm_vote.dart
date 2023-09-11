import 'package:xrp_dart/src/xrpl/models/amm/amm_create.dart';
import 'package:xrp_dart/src/xrpl/models/currencies/currencies.dart';
import 'package:xrp_dart/src/xrpl/models/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// Vote on the trading fee for an Automated Market Maker (AMM) instance.
/// Up to 8 accounts can vote in proportion to the amount of the AMM's LP Tokens
/// they hold.
/// Each new vote re-calculates the AMM's trading fee based on a weighted average
/// of the votes.
class AMMVote extends XRPTransaction {
  /// [asset] The definition for one of the assets in the AMM's pool.
  /// [asset2] The definition for the other asset in the AMM's pool.
  ///
  /// [tradingFee] The proposed fee to vote for, in units of 1/100,000; a value of 1 is equivalent
  /// to 0.001%.
  /// The maximum value is 1000, indicating a 1% fee. This field is required.
  AMMVote({
    required super.account,
    required this.tradingFee,
    required this.asset,
    required this.asset2,
    super.signingPubKey,
    super.memos,
    super.ticketSequance,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  })  : assert(() {
          if (tradingFee < 0 || tradingFee > AMMCreate.AMM_MAX_TRADING_FEE) {
            return false;
          }
          return true;
        }(), "Must be between 0 and ${AMMCreate.AMM_MAX_TRADING_FEE}"),
        super(transactionType: XRPLTransactionType.AMM_VOTE);
  final XRPCurrencies asset;
  final XRPCurrencies asset2;
  final int tradingFee;
  AMMVote.fromJson(Map<String, dynamic> json)
      : asset = XRPCurrencies.fromJson(json["asset"]),
        asset2 = XRPCurrencies.fromJson(json["asset2"]),
        tradingFee = json["trading_fee"],
        super.json(json);
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "asset", asset.toJson());
    addWhenNotNull(json, "asset2", asset2.toJson());
    addWhenNotNull(json, "trading_fee", tradingFee);
    return json;
  }
}
