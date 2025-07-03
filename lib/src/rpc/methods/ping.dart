import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/models/models/response.dart';
import '../core/methods_impl.dart';

/// The ping command returns an acknowledgement, so that
/// clients can test the connection status and latency.
class XRPRequestPing
    extends XRPLedgerRequest<PingResult, Map<String, dynamic>> {
  XRPRequestPing();
  @override
  String get method => XRPRequestMethod.ping;

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  PingResult onResonse(Map<String, dynamic> result) {
    return PingResult.fromJson(result);
  }
}
