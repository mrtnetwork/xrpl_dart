import 'package:xrpl_dart/src/rpc/rpc.dart';

/// The sign_for method contributes a signature to a multi-signed transaction.
/// This is an admin-only method: the server must hold (or be given) the
/// secret key material of the `account` contributor.
class XRPRequestSignFor
    extends XRPLedgerRequest<SignForResult, Map<String, dynamic>> {
  XRPRequestSignFor({
    required this.account,
    required this.txJson,
    this.secret,
    this.seed,
    this.seedHex,
    this.passphrase,
    this.keyType,
    this.buildPath = false,
  });
  @override
  String get method => XRPRequestMethod.signFor;

  /// The account contributing a signature.
  final String account;

  /// The multi-signed transaction to add a signature to, in JSON format.
  final Map<String, dynamic> txJson;
  final String? secret;
  final String? seed;
  final String? seedHex;
  final String? passphrase;
  final String? keyType;
  final bool buildPath;

  @override
  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'tx_json': txJson,
      'secret': secret,
      'seed': seed,
      'seed_hex': seedHex,
      'passphrase': passphrase,
      'key_type': keyType,
      'build_path': buildPath,
    };
  }

  @override
  SignForResult onResponse(Map<String, dynamic> result) {
    return SignForResult.fromJson(result);
  }
}
