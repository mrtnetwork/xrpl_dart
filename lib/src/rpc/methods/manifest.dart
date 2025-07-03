import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/models/models/response.dart';
import '../core/methods_impl.dart';

/// The manifest method reports the current
/// "manifest" information for a given validator
/// public key. The "manifest" is the public portion
/// of that validator's configured token.
class XRPRequestManifest
    extends XRPLedgerRequest<ManifestResult, Map<String, dynamic>> {
  XRPRequestManifest({
    required this.publicKey,
  });
  @override
  String get method => XRPRequestMethod.manifest;

  final String publicKey;

  @override
  Map<String, dynamic> toJson() {
    return {'public_key': publicKey};
  }

  @override
  ManifestResult onResonse(Map<String, dynamic> result) {
    return ManifestResult.fromJson(result);
  }
}
