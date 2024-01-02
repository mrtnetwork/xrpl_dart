import 'package:xrp_dart/src/rpc/methods/methods.dart';
import 'package:xrp_dart/src/rpc/on_chain_models/on_chain_models.dart';
import '../core/methods_impl.dart';

/// This request returns information about an account's trust lines, including balances
/// in all non-XRP currencies and assets. All information retrieved is relative to a
/// particular version of the ledger.
/// See [account_lines](https://xrpl.org/account_lines.html)
class RPCAccountLines extends XRPLedgerRequest<Map<String, dynamic>> {
  RPCAccountLines({
    required this.account,
    this.peer,
    this.limit,
    this.marker,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) : super(ledgerIndex: ledgerIndex);
  @override
  String get method => XRPRequestMethod.accountLines;

  final String account;
  final String? peer;
  final int? limit;
  final dynamic marker;

  @override
  Map<String, dynamic> toJson() {
    return {"account": account, "peer": peer, "limit": limit, "marker": marker};
  }
}
