import 'package:xrp_dart/src/rpc/rpc.dart';

/// Retrieve information about the public ledger.
/// See [ledger](https://xrpl.org/ledger.html)
class RPCLedger extends XRPLedgerRequest<Map<String, dynamic>> {
  RPCLedger(
      {this.full = false,
      this.accounts = false,
      this.transactions = false,
      this.expand = false,
      this.ownerFunds = false,
      this.binary = false,
      this.queue = false,
      this.type,
      XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated});
  @override
  String get method => XRPRequestMethod.ledger;

  final bool full;
  final bool accounts;
  final bool transactions;
  final bool expand;
  final bool ownerFunds;
  final bool binary;
  final bool queue;
  final LedgerEntryType? type;

  @override
  Map<String, dynamic> toJson() {
    return {
      "full": full,
      "accounts": accounts,
      "transactions": transactions,
      "expand": expand,
      "owner_funds": ownerFunds,
      "binary": binary,
      "queue": queue,
      "type": type?.value
    };
  }
}
