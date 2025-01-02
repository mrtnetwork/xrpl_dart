import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/xrpl/models/currencies/currencies.dart';
import '../core/methods_impl.dart';

/// The [amm_info] method gets information about an Automated Market Maker
/// (AMM) instance.
class XRPRequestAMMInfo
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestAMMInfo({
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
      'amm_account': ammAccount,
      'asset': asset?.toJson(),
      'asset2': asset2?.toJson(),
    };
  }
}
