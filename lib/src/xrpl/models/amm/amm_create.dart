import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Create a new Automated Market Maker (AMM) instance for trading a pair of
/// assets (fungible tokens or XRP).
///
/// Creates both an AMM object and a special AccountRoot object to represent the AMM.
/// Also transfers ownership of the starting balance of both assets from the sender to
/// the created AccountRoot and issues an initial balance of liquidity provider
/// tokens (LP Tokens) from the AMM account to the sender.
///
/// Caution: When you create the AMM, you should fund it with (approximately)
/// equal-value amounts of each asset.
/// Otherwise, other users can profit at your expense by trading with
/// this AMM (performing arbitrage).
/// The currency risk that liquidity providers take on increases with the
/// volatility (potential for imbalance) of the asset pair.
/// The higher the trading fee, the more it offsets this risk,
/// so it's best to set the trading fee based on the volatility of the asset pair.
class AMMCreate extends XRPTransaction {
  static const int ammMaxTradingFee = 1000;

  /// [amount] The first of the two assets to fund this AMM with. This must be a positive amount
  final CurrencyAmount amount;

  /// [amount2] The second of the two assets to fund this AMM with. This must be a positive amount.
  final CurrencyAmount amount2;

  /// [tradingFee] The fee to charge for trades against this AMM instance, in units of 1/100,000;
  /// a value of 1 is equivalent to 0.001%.
  /// The maximum value is 1000, indicating a 1% fee.
  /// The minimum value is 0.
  final int tradingFee;

  AMMCreate({
    required super.account,
    required this.amount,
    required this.amount2,
    required this.tradingFee,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: XRPLTransactionType.ammCreate);
  AMMCreate.fromJson(super.json)
      : amount = CurrencyAmount.fromJson(json['amount']),
        amount2 = CurrencyAmount.fromJson(json['amount2']),
        tradingFee = json['trading_fee'],
        super.json();
  @override
  String? get validate {
    if (tradingFee < 0 || tradingFee > ammMaxTradingFee) {
      return 'TradingFee Must be between 0 and $ammMaxTradingFee';
    }
    return super.validate;
  }

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'amount': amount.toJson(),
      'amount2': amount2.toJson(),
      'trading_fee': tradingFee,
      ...super.toJson()
    };
  }
}
