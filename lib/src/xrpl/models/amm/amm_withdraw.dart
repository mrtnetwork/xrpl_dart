import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Transactions of the AMMWithdraw type support additional values in the Flags field.
/// This enum represents those options.
class AMMWithdrawFlag implements FlagsInterface {
  static const AMMWithdrawFlag tfLpToken = AMMWithdrawFlag._(0x00010000);

  static const AMMWithdrawFlag tfWithdrawAll = AMMWithdrawFlag._(0x00020000);

  static const AMMWithdrawFlag tfOneAssetWithdrawAll =
      AMMWithdrawFlag._(0x00040000);

  static const AMMWithdrawFlag tfSingleAsset = AMMWithdrawFlag._(0x00080000);

  static const AMMWithdrawFlag tfTwoAsset = AMMWithdrawFlag._(0x00100000);

  static const AMMWithdrawFlag tfOneAssetLpToken =
      AMMWithdrawFlag._(0x00200000);

  static const AMMWithdrawFlag tfLimitLpToken = AMMWithdrawFlag._(0x00400000);

  final int value;

  const AMMWithdrawFlag._(this.value);

  @override
  int get id => value;
}

class AMMWithdrawFlagInterface {
  AMMWithdrawFlagInterface({
    required this.tfLpToken,
    required this.tfWithdrawAll,
    required this.tfOneAssetWithdrawAll,
    required this.tfSingleAsset,
    required this.tfTwoAsset,
    required this.tfOneAssetLpToken,
    required this.tfLimitLpToken,
  });

  final bool tfLpToken;
  final bool tfWithdrawAll;
  final bool tfOneAssetWithdrawAll;
  final bool tfSingleAsset;
  final bool tfTwoAsset;
  final bool tfOneAssetLpToken;
  final bool tfLimitLpToken;
}

/// Withdraw assets from an Automated Market Maker (AMM) instance by returning the
/// AMM's liquidity provider tokens (LP Tokens).
class AMMWithdraw extends XRPTransaction {
  /// [asset] The definition for one of the assets in the AMM's pool.
  /// [asset2] The definition for the other asset in the AMM's pool.
  /// [amount] The amount of one asset to withdraw from the AMM.
  /// This must match the type of one of the assets (tokens or XRP) in the AMM's pool.
  ///
  /// [amount2] The amount of another asset to withdraw from the AMM.
  /// If present, this must match the type of the other asset in the AMM's pool
  /// and cannot be the same type as Amount.
  ///
  /// [ePrice] The minimum effective price, in LP Token returned, to pay per unit of the asset
  /// to withdraw.
  ///
  /// [lpTokenIn] How many of the AMM's LP Tokens to redeem.
  AMMWithdraw({
    required super.account,
    required this.asset,
    required this.asset2,
    this.amount,
    this.amount2,
    this.ePrice,
    this.lpTokenIn,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: XRPLTransactionType.ammWithdraw);
  final XRPCurrencies asset;
  final XRPCurrencies asset2;
  final CurrencyAmount? amount;
  final CurrencyAmount? amount2;
  final CurrencyAmount? ePrice;
  final IssuedCurrencyAmount? lpTokenIn;
  AMMWithdraw.fromJson(super.json)
      : asset = XRPCurrencies.fromJson(json['asset']),
        asset2 = XRPCurrencies.fromJson(json['asset2']),
        amount = json['amount'] == null
            ? null
            : CurrencyAmount.fromJson(json['amount']),
        amount2 = json['amount2'] == null
            ? null
            : CurrencyAmount.fromJson(json['amount2']),
        ePrice = json['e_price'] == null
            ? null
            : CurrencyAmount.fromJson(json['e_price']),
        lpTokenIn = json['lp_token_out'] == null
            ? null
            : IssuedCurrencyAmount.fromJson(json['lp_token_in']),
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
      'lp_token_in': lpTokenIn?.toJson(),
      ...super.toJson()
    };
  }

  @override
  String? get validate {
    if (amount2 != null && amount == null) {
      return 'Must set amount with amount2';
    } else if (ePrice != null && amount == null) {
      return 'Must set amount with ePrice';
    } else if (lpTokenIn != null && amount == null) {
      return 'Must set at least lpTokenIn or amount';
    }
    return super.validate;
  }
}
