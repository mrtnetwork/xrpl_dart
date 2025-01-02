import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import '../core/methods_impl.dart';

/// The ledger_closed method returns the unique
/// identifiers of the most recently closed ledger.
/// (This ledger is not necessarily validated and
/// immutable yet.)
class XRPRequestLedgerClosed
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestLedgerClosed();
  @override
  String get method => XRPRequestMethod.ledgerClosed;

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
