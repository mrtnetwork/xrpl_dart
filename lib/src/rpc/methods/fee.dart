import 'package:xrp_dart/src/rpc/rpc.dart';

/// The fee command reports the current state of the open-ledger requirements
/// for the transaction cost. This requires the FeeEscalation amendment to be
/// enabled.
/// This is a public command available to unprivileged users.
class RPCFee extends XRPLedgerRequest<LedgerInfo> {
  RPCFee();
  @override
  String get method => XRPRequestMethod.fee;

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  LedgerInfo onResonse(Map<String, dynamic> result) {
    return LedgerInfo.fromJson(result);
  }
}
