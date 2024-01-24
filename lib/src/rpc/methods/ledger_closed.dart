import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import '../core/methods_impl.dart';

/// The ledger_closed method returns the unique
/// identifiers of the most recently closed ledger.
/// (This ledger is not necessarily validated and
/// immutable yet.)
class RPCLedgerClosed extends XRPLedgerRequest<Map<String, dynamic>> {
  RPCLedgerClosed();
  @override
  String get method => XRPRequestMethod.ledgerClosed;

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
