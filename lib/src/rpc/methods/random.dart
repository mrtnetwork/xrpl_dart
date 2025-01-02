import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import '../core/methods_impl.dart';

/// The random command provides a random number to be
/// used as a source of entropy for random number generation by clients.
class XRPRequestRandom
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestRandom();
  @override
  String get method => XRPRequestMethod.random;

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
