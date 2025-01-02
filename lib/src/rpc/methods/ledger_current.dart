import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import '../core/methods_impl.dart';

/// The ledger_current method returns the unique
/// identifiers of the current in-progress ledger.
/// This command is mostly useful for testing,
/// because the ledger returned is still in flux.
class XRPRequestLedgerCurrent
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestLedgerCurrent();
  @override
  String get method => XRPRequestMethod.ledgerCurrent;

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
