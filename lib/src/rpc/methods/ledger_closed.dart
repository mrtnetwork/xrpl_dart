import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/models/models/response.dart';
import '../core/methods_impl.dart';

/// The ledger_closed method returns the unique
/// identifiers of the most recently closed ledger.
/// (This ledger is not necessarily validated and
/// immutable yet.)
class XRPRequestLedgerClosed
    extends XRPLedgerRequest<LedgerClosedResult, Map<String, dynamic>> {
  XRPRequestLedgerClosed();
  @override
  String get method => XRPRequestMethod.ledgerClosed;

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  LedgerClosedResult onResonse(Map<String, dynamic> result) {
    return LedgerClosedResult.fromJson(result);
  }
}
