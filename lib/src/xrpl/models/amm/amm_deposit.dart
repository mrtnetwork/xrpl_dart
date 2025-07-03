import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Transactions of the AMMDeposit type support additional values in the Flags field.
/// This enum represents those options.
class AMMDepositFlag implements FlagsInterface {
  static const AMMDepositFlag tfLpToken = AMMDepositFlag._(0x00010000);

  static const AMMDepositFlag tfSingleAsset = AMMDepositFlag._(0x00080000);

  static const AMMDepositFlag tfTwoAsset = AMMDepositFlag._(0x00100000);

  static const AMMDepositFlag tfOneAssetLpToken = AMMDepositFlag._(0x00200000);

  static const AMMDepositFlag tfLimitLpToken = AMMDepositFlag._(0x00400000);

  final int value;

  const AMMDepositFlag._(this.value);

  @override
  int get id => value;
}

/// Deposit funds into an Automated Market Maker (AMM) instance
/// and receive the AMM's liquidity provider tokens (LP Tokens) in exchange.
///
/// You can deposit one or both of the assets in the AMM's pool.
/// If successful, this transaction creates a trust line to the AMM Account (limit 0)
/// to hold the LP Tokens.
class AMMDeposit extends SubmittableTransaction {
  /// [asset] The definition for one of the assets in the AMM's pool.
  final BaseCurrency asset;

  /// [asset2] The definition for the other asset in the AMM's pool.
  final BaseCurrency asset2;

  /// [amount] The amount of one asset to deposit to the AMM.
  /// If present, this must match the type of one of the assets (tokens or XRP)
  /// in the AMM's pool.
  final BaseAmount? amount;

  /// [amount2] The amount of another asset to add to the AMM.
  /// If present, this must match the type of the other asset in the AMM's pool
  /// and cannot be the same asset as Amount.
  final BaseAmount? amount2;

  /// [ePrice] The maximum effective price, in the deposit asset, to pay
  /// for each LP Token received.
  final BaseAmount? ePrice;

  /// [lpTokenOut] How many of the AMM's LP Tokens to buy.
  final IssuedCurrencyAmount? lpTokenOut;

  AMMDeposit({
    required super.account,
    required this.asset,
    required this.asset2,
    this.amount,
    this.amount2,
    this.ePrice,
    this.lpTokenOut,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: SubmittableTransactionType.ammDeposit);

  AMMDeposit.fromJson(super.json)
      : asset = BaseCurrency.fromJson(json['asset']),
        asset2 = BaseCurrency.fromJson(json['asset2']),
        amount =
            json['amount'] == null ? null : BaseAmount.fromJson(json['amount']),
        amount2 = json['amount2'] == null
            ? null
            : BaseAmount.fromJson(json['amount2']),
        ePrice = json['e_price'] == null
            ? null
            : BaseAmount.fromJson(json['e_price']),
        lpTokenOut = json['lp_token_out'] == null
            ? null
            : IssuedCurrencyAmount.fromJson(json['lp_token_out']),
        super.json();

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'asset': asset.toJson(),
      'asset2': asset2.toJson(),
      'amount': amount?.toJson(),
      'amount2': amount2?.toJson(),
      'e_price': ePrice?.toJson(),
      'lp_token_out': lpTokenOut?.toJson(),
      ...super.toJson()
    }..removeWhere((_, v) => v == null);
  }

  @override
  String? get validate {
    if (amount2 != null && amount == null) {
      return 'Must set amount with amount2';
    } else if (ePrice != null && amount == null) {
      return 'Must set amount with e_price';
    } else if (lpTokenOut == null && amount == null) {
      return 'Must set at least lp_token_out or amount';
    }
    return super.validate;
  }
}
