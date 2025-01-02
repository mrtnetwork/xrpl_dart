import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import '../core/methods_impl.dart';

/// The transaction_entry method retrieves information on a single transaction from a
/// specific ledger version. (The tx method, by contrast, searches all ledgers for the
/// specified transaction. We recommend using that method instead.)
/// `See [transaction_entry](https://xrpl.org/transaction_entry.html)
class XRPRequestTransactionEntry
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestTransactionEntry({
    required this.txHash,
  });
  @override
  String get method => XRPRequestMethod.transactionEntry;

  final String txHash;

  @override
  Map<String, dynamic> toJson() {
    return {'tx_hash': txHash};
  }
}
