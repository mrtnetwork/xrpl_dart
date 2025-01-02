import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/on_chain_models/on_chain_models.dart';
import '../core/methods_impl.dart';

/// This request calculates the total balances issued by a given account, optionally
/// excluding amounts held by operational addresses.
/// See [gateway_balances](https://xrpl.org/gateway_balances.html)
class XRPRequestGatewayBalances
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestGatewayBalances({
    required this.account,
    this.hotWallet,
    this.strict = false,
    super.ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.gatewayBalances;

  final String account;
  final bool strict;

  /// should be string or list String
  final dynamic hotWallet;

  @override
  Map<String, dynamic> toJson() {
    return {'account': account, 'strict': strict, 'hotWallet': hotWallet};
  }
}
