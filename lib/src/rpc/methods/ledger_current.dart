import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/core/methods_impl.dart';

/// The ledger_current method returns the unique
/// identifiers of the current in-progress ledger.
/// This command is mostly useful for testing,
/// because the ledger returned is still in flux.
class XRPRequestLedgerCurrent
    extends XRPLedgerRequest<int, Map<String, dynamic>> {
  XRPRequestLedgerCurrent();
  @override
  String get method => XRPRequestMethod.ledgerCurrent;

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  int onResponse(Map<String, dynamic> result) {
    // rippled answers `ledger_current_index`, but some proxies and Clio
    // builds answer `ledger_index` (as int or numeric string). Accept both.
    final dynamic raw =
        result["ledger_current_index"] ?? result["ledger_index"];
    final int? index = IntUtils.tryParse(raw);
    if (index == null) {
      throw const BuError(
        DefaultErrorType.invalidArgument,
        'ledger_current response has neither ledger_current_index nor ledger_index.',
      );
    }
    return index;
  }
}
