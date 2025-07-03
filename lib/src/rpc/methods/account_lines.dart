import 'package:xrpl_dart/src/rpc/core/methods_impl.dart';
import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/models/models.dart';

/// This request returns information about an account's trust lines, including balances
/// in all non-XRP currencies and assets. All information retrieved is relative to a
/// particular version of the ledger.
/// See [account_lines](https://xrpl.org/account_lines.html)
class XRPRequestAccountLines
    extends XRPLedgerRequest<AccountLinesResult, Map<String, dynamic>> {
  XRPRequestAccountLines({
    required this.account,
    this.peer,
    this.limit,
    this.marker,
    super.ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.accountLines;

  final String account;
  final String? peer;
  final int? limit;
  final dynamic marker;

  @override
  Map<String, dynamic> toJson() {
    return {'account': account, 'peer': peer, 'limit': limit, 'marker': marker};
  }

  @override
  AccountLinesResult onResonse(Map<String, dynamic> result) {
    return AccountLinesResult.fromJson(result);
  }
}
