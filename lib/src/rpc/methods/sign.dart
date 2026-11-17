import 'package:xrpl_dart/src/rpc/rpc.dart';

/// The sign method cryptographically signs a transaction and returns the
/// signed transaction blob. This is an admin-only method: the server must
/// hold (or be given) the secret key material.
class XRPRequestSign extends XRPLedgerRequest<SignResult, Map<String, dynamic>> {
  XRPRequestSign({
    required this.txJson,
    this.secret,
    this.seed,
    this.seedHex,
    this.passphrase,
    this.keyType,
    this.offline = false,
    this.buildPath = false,
    this.feeMultMax,
    this.feeDivMax,
  });
  @override
  String get method => XRPRequestMethod.sign;

  /// The transaction to sign, in JSON format.
  final Map<String, dynamic> txJson;
  final String? secret;
  final String? seed;
  final String? seedHex;
  final String? passphrase;
  final String? keyType;
  final bool offline;
  final bool buildPath;
  final int? feeMultMax;
  final int? feeDivMax;

  @override
  Map<String, dynamic> toJson() {
    return {
      'tx_json': txJson,
      'secret': secret,
      'seed': seed,
      'seed_hex': seedHex,
      'passphrase': passphrase,
      'key_type': keyType,
      'offline': offline,
      'build_path': buildPath,
      'fee_mult_max': feeMultMax,
      'fee_div_max': feeDivMax,
    };
  }

  @override
  SignResult onResponse(Map<String, dynamic> result) {
    return SignResult.fromJson(result);
  }
}
