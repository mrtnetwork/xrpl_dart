import 'package:xrpl_dart/src/rpc/rpc.dart';

/// The server_state command asks the server for various
/// machine-readable information about the rippled server's
/// current state. The response is almost the same as the
/// server_info method, but uses units that are easier to
/// process instead of easier to read. (For example, XRP
/// values are given in integer drops instead of scientific
/// notation or decimal values, and time is given in
/// milliseconds instead of seconds.)
class XRPRequestServerState
    extends XRPLedgerRequest<XRPLedgerState, Map<String, dynamic>> {
  XRPRequestServerState();
  @override
  String get method => XRPRequestMethod.serverState;

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  XRPLedgerState onResonse(Map<String, dynamic> result) {
    return XRPLedgerState.fromJson(result);
  }
}
