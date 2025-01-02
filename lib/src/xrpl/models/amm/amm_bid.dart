import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Bid on an Automated Market Maker's (AMM's) auction slot.
/// If you win, you can trade against the AMM at a discounted fee until you are outbid
/// or 24 hours have passed.
/// If you are outbid before 24 hours have passed, you are refunded part of the cost
/// of your bid based on how much time remains.
/// You bid using the AMM's LP Tokens; the amount of a winning bid is returned
/// to the AMM, decreasing the outstanding balance of LP Tokens.
class AMMBid extends XRPTransaction {
  static const int _maxAuthAccounts = 4;

  /// [asset] The definition for one of the assets in the AMM's pool.
  final XRPCurrencies asset;

  /// [asset2] The definition for the other asset in the AMM's pool
  final XRPCurrencies asset2;

  /// [bidMin] Pay at least this amount for the slot.
  /// Setting this value higher makes it harder for others to outbid you.
  /// If omitted, pay the minimum necessary to win the bid.
  final CurrencyAmount? bidMin;

  /// [bidMax] Pay at most this amount for the slot.
  /// If the cost to win the bid is higher than this amount, the transaction fails.
  /// If omitted, pay as much as necessary to win the bid.
  final CurrencyAmount? bidMax;

  /// [authAccounts] A list of up to 4 additional accounts that you allow to trade at the discounted fee.
  /// This cannot include the address of the transaction sender.
  final List<AuthAccount>? authAccounts;

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'asset': asset.toJson(),
      'asset2': asset2.toJson(),
      'bid_min': bidMin?.toJson(),
      'bid_max': bidMax?.toJson(),
      'auth_accounts': (authAccounts?.isEmpty ?? true)
          ? null
          : authAccounts!.map((e) => e.toJson()).toList(),
      ...super.toJson()
    };
  }

  AMMBid.fromJson(super.json)
      : asset = XRPCurrencies.fromJson(json['asset']),
        asset2 = XRPCurrencies.fromJson(json['asset2']),
        bidMax = CurrencyAmount.fromJson(json['bid_max']),
        bidMin = CurrencyAmount.fromJson(json['bid_min']),
        authAccounts = (json['auth_accounts'] as List?)
            ?.map(
              (e) => AuthAccount.fromJson(e),
            )
            .toList(),
        super.json();

  AMMBid({
    required this.asset,
    required this.asset2,
    this.bidMax,
    this.bidMin,
    required super.account,
    this.authAccounts,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: XRPLTransactionType.ammBid);
  @override
  String? get validate {
    if (authAccounts != null && authAccounts!.length > _maxAuthAccounts) {
      return 'authAccounts Length must not be greater than $_maxAuthAccounts';
    }
    return super.validate;
  }
}
