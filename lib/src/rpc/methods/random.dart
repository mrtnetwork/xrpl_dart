import 'package:xrp_dart/src/rpc/methods/methods.dart';
import '../core/methods_impl.dart';

/// The random command provides a random number to be
/// used as a source of entropy for random number generation by clients.
class RPCRandom extends XRPLedgerRequest<Map<String, dynamic>> {
  RPCRandom();
  @override
  String get method => XRPRequestMethod.random;

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
