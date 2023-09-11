// ignore_for_file: constant_identifier_names

import 'package:xrp_dart/src/xrpl/models/account/auth_account.dart';
import 'package:xrp_dart/src/xrpl/models/currencies/currencies.dart';
import 'package:xrp_dart/src/xrpl/models/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// Bid on an Automated Market Maker's (AMM's) auction slot.
/// If you win, you can trade against the AMM at a discounted fee until you are outbid
/// or 24 hours have passed.
/// If you are outbid before 24 hours have passed, you are refunded part of the cost
/// of your bid based on how much time remains.
/// You bid using the AMM's LP Tokens; the amount of a winning bid is returned
/// to the AMM, decreasing the outstanding balance of LP Tokens.
class AMMBid extends XRPTransaction {
  static const int _MAX_AUTH_ACCOUNTS = 4;
  final XRPCurrencies asset;
  final XRPCurrencies asset2;
  final CurrencyAmount bidMin;
  final CurrencyAmount bidMax;
  final List<AuthAccount>? authAccounts;

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "asset", asset.toJson());
    addWhenNotNull(json, "asset2", asset2.toJson());
    addWhenNotNull(json, "bid_min", bidMin.toJson());
    addWhenNotNull(json, "bid_max", bidMax.toJson());
    addWhenNotNull(
        json,
        "auth_accounts",
        (authAccounts?.isEmpty ?? true)
            ? null
            : authAccounts!.map((e) => e.toJson()).toList());
    return json;
  }

  AMMBid.fromJson(Map<String, dynamic> json)
      : asset = XRPCurrencies.fromJson(json["asset"]),
        asset2 = XRPCurrencies.fromJson(json["asset2"]),
        bidMax = CurrencyAmount.fromJson(json["bid_max"]),
        bidMin = CurrencyAmount.fromJson(json["bid_min"]),
        authAccounts = (json["auth_accounts"] as List?)
            ?.map(
              (e) => AuthAccount.fromJson(e),
            )
            .toList(),
        super.json(json);

  /// [asset] The definition for one of the assets in the AMM's pool.
  /// [asset2] The definition for the other asset in the AMM's pool
  /// [bidMin] Pay at least this amount for the slot.
  /// Setting this value higher makes it harder for others to outbid you.
  /// If omitted, pay the minimum necessary to win the bid.
  ///
  /// [bidMax] Pay at most this amount for the slot.
  /// If the cost to win the bid is higher than this amount, the transaction fails.
  /// If omitted, pay as much as necessary to win the bid.
  ///
  /// [authAccounts] A list of up to 4 additional accounts that you allow to trade at the discounted fee.
  /// This cannot include the address of the transaction sender.
  AMMBid({
    required super.account,
    required this.asset,
    required this.asset2,
    required this.bidMax,
    required this.bidMin,
    this.authAccounts,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  })  : assert(() {
          if (asset is IssuedCurrencyAmount || asset2 is IssuedCurrencyAmount) {
            return false;
          }
          return true;
        }(), "use IssuedCurrency instead of IssuedCurrencyAmount"),
        assert(() {
          if (authAccounts != null &&
              authAccounts.length > _MAX_AUTH_ACCOUNTS) {
            return false;
          }
          return true;
        }(),
            "authAccounts Length must not be greater than $_MAX_AUTH_ACCOUNTS"),
        super(transactionType: XRPLTransactionType.AMM_BID);
}
