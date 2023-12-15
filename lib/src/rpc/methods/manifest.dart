import 'package:xrp_dart/src/rpc/methods/methods.dart';
import '../core/methods_impl.dart';

/// The manifest method reports the current
/// "manifest" information for a given validator
/// public key. The "manifest" is the public portion
/// of that validator's configured token.
class RPCManifest extends XRPLedgerRequest<Map<String, dynamic>> {
  RPCManifest({
    required this.publicKey,
  });
  @override
  String get method => XRPRequestMethod.manifest;

  final String publicKey;

  @override
  Map<String, dynamic> toJson() {
    return {"public_key": publicKey};
  }
}
