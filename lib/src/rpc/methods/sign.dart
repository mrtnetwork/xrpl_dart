import 'package:xrpl_dart/xrpl_dart.dart';

/// The sign method takes a transaction in JSON format and a seed value, and returns a
/// signed binary representation of the transaction. To contribute one signature to a
/// multi-signed transaction, use the sign_for method instead.
/// By default, this method is admin-only. It can be used as a public method if the
/// server has enabled public signing.
/// Caution:
/// Unless you run the rippled server yourself, you should do local signing with
/// RippleAPI instead of using this command. An untrustworthy server could change the
/// transaction before signing it, or use your secret key to sign additional arbitrary
/// transactions as if they came from you.
// See [sign](https://xrpl.org/sign.html)
class XRPRequestSign
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestSign(
      {required this.transaction,
      this.secret,
      this.seed,
      this.seedHex,
      this.passphrase,
      this.keyType,
      this.offline = false,
      this.buildPath,
      this.feeMulMax = 10,
      this.feeDivMax = 1});
  @override
  String get method => XRPRequestMethod.sign;

  final XRPTransaction transaction;
  final String? secret;
  final String? seed;
  final String? seedHex;
  final String? passphrase;
  final XRPKeyAlgorithm? keyType;
  final bool offline;
  final bool? buildPath;
  final int feeMulMax;
  final int feeDivMax;

  @override
  Map<String, dynamic> toJson() {
    return {
      'tx_json': transaction.toXrpl(),
      'secret': secret,
      'seed': seed,
      'seed_hex': seedHex,
      'passphrase': passphrase,
      'key_type': keyType?.curveType.name,
      'offline': offline,
      'build_path': buildPath,
      'fee_mult_max': feeMulMax,
      'fee_div_max': feeDivMax
    };
  }
}
