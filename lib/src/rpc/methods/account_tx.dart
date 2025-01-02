import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/on_chain_models/on_chain_models.dart';
import '../core/methods_impl.dart';

/// This request retrieves from the ledger a list of transactions that involved the
/// specified account.
/// See [account_tx](https://xrpl.org/account_tx.html)
class XRPRequestAccountTx
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestAccountTx({
    required this.account,
    this.limit,
    this.marker,
    this.ledgerIndexMax,
    this.ledgerIndexMin,
    this.binary = false,
    this.forward = false,
    super.ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.accountTx;

  final String account;
  final int? limit;

  final dynamic marker;
  final int? ledgerIndexMin;
  final int? ledgerIndexMax;
  final bool binary;
  final bool forward;

  @override
  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'limit': limit,
      'marker': marker,
      'ledger_index_min': ledgerIndexMin,
      'ledger_index_max': ledgerIndexMax,
      'binary': binary,
      'forward': forward
    };
  }
}
