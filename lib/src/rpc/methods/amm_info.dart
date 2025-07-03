import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/models/models/response.dart';
import 'package:xrpl_dart/src/xrpl/models/currencies/currencies.dart';
import '../core/methods_impl.dart';

/// The [amm_info] method gets information about an Automated Market Maker
/// (AMMResult) instance.
class XRPRequestAMMInfo
    extends XRPLedgerRequest<AMMInfoResult, Map<String, dynamic>> {
  XRPRequestAMMInfo({this.ammAccount, this.asset, this.asset2});
  @override
  String get method => XRPRequestMethod.ammInfo;

  final String? ammAccount;
  final BaseCurrency? asset;
  final BaseCurrency? asset2;

  @override
  Map<String, dynamic> toJson() {
    return {
      'amm_account': ammAccount,
      'asset': asset?.toJson(),
      'asset2': asset2?.toJson()
    };
  }

  @override
  AMMInfoResult onResonse(Map<String, dynamic> result) {
    return AMMInfoResult.fromJson(result);
  }
}
