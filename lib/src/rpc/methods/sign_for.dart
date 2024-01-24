import 'package:xrpl_dart/xrpl_dart.dart';

/// The sign_for command provides one signature for a multi-signed transaction.
/// By default, this method is admin-only. It can be used as a public method if the
/// server has enabled public signing.
/// This command requires the MultiSign amendment to be enabled.
/// See [sign_for](https://xrpl.org/sign_for.html)
class RPCSignFor extends XRPLedgerRequest<Map<String, dynamic>> {
  RPCSignFor({
    required this.transaction,
    required this.account,
    this.secret,
    this.seed,
    this.seedHex,
    this.passphrase,
    this.keyType,
  });
  @override
  String get method => XRPRequestMethod.signFor;
  final String account;
  final XRPTransaction transaction;
  final String? secret;
  final String? seed;
  final String? seedHex;
  final String? passphrase;
  final XRPKeyAlgorithm? keyType;

  @override
  String? get validate {
    final List<String?> param = [secret, seed, seedHex, passphrase];
    param.removeWhere((element) => element == null);
    if (param.length != 1) {
      return "singFor Must have only one of secret, seed, seedHex, and passphrase.";
    }
    if (secret != null && keyType != null) {
      return "Must omit keyType if secret is provided.";
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "tx_json": transaction.toXrpl(),
      "secret": secret,
      "seed": seed,
      "seed_hex": seedHex,
      "passphrase": passphrase,
      "key_type": keyType?.curveType.name,
      "account": account
    };
  }
}
