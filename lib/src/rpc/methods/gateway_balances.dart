import 'package:xrp_dart/src/rpc/methods/methods.dart';
import 'package:xrp_dart/src/rpc/on_chain_models/on_chain_models.dart';
import '../core/methods_impl.dart';

/// This request calculates the total balances issued by a given account, optionally
/// excluding amounts held by operational addresses.
/// See [gateway_balances](https://xrpl.org/gateway_balances.html)
class RPCGatewayBalances extends XRPLedgerRequest<Map<String, dynamic>> {
  RPCGatewayBalances({
    required this.account,
    this.hotWallet,
    this.strict = false,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) : super(ledgerIndex: ledgerIndex);
  @override
  String get method => XRPRequestMethod.gatewayBalances;

  final String account;
  final bool strict;

  /// should be string or list String
  final dynamic hotWallet;
  @override
  String? get validate {
    if (hotWallet != null) {
      if (hotWallet is! String && hotWallet is! List<String>) {
        return "hotWallet variable should be string or list String";
      }
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {"account": account, "strict": strict, "hotWallet": hotWallet};
  }
}
