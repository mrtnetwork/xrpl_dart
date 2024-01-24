import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import '../core/methods_impl.dart';

/// The ping command returns an acknowledgement, so that
/// clients can test the connection status and latency.
class RPCPing extends XRPLedgerRequest<Map<String, dynamic>> {
  RPCPing();
  @override
  String get method => XRPRequestMethod.ping;

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
