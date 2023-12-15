import 'package:xrp_dart/src/rpc/methods/methods.dart';
import 'package:xrp_dart/src/xrpl/models/currencies/currencies.dart';
import '../core/methods_impl.dart';

/// The [amm_info] method gets information about an Automated Market Maker
/// (AMM) instance.
class RPCAMMInfo extends XRPLedgerRequest<Map<String, dynamic>> {
  RPCAMMInfo({
    this.ammAccount,
    this.asset,
    this.asset2,
  });
  @override
  String get method => XRPRequestMethod.ammInfo;

  final String? ammAccount;
  final XRPCurrencies? asset;
  final XRPCurrencies? asset2;

  @override
  Map<String, dynamic> toJson() {
    return {
      "amm_account": ammAccount,
      "asset": asset?.toJson(),
      "asset2": asset2?.toJson(),
    };
  }
}
