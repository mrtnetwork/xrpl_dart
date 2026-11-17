// XRPL testnet: keys, addresses and signatures (ED25519 + SECP256K1, offline).


import 'dart:convert';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:example/examples/local/xrpl_node.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

Future<void> main() async {
  final net = await XrplTestnet.connect();
  print('XRPL testnet keys and addresses');
  print(field('rpc', XRPProviderConst.testnetUri));
  print(field('ledger', '${await net.ledgerIndex()}'));
  print('');

  for (final algorithm in XRPKeyAlgorithm.values) {
    /// Same seed and index for both algorithms, so only the algorithm differs.
    final wallet = LocalWallet(index: 0, algorithm: algorithm);

    print('${algorithm.name.toUpperCase()} (prefix ${algorithm.prefix})');
    print(field('seed', wallet.seed));
    print(field('private key', wallet.privateKey.toHex()));
    print(field('public key', wallet.pubHex));
    print(field('classic', wallet.address));
    print(field('x-address', wallet.xAddress));
    print('');

    /// Sign a message and verify it with the matching public key.
    final message = utf8.encode('xrpl-dart example');
    final signature = wallet.privateKey.sign(message).signature!;
    final verified = wallet.publicKey.verifySignature(
      BytesUtils.toHexString(message),
      signature,
    );
    print(field('message', 'xrpl-dart example'));
    print(field('signature', signature));
    print(field('verify', '$verified'));
    print('');
  }

  /// The two algorithms produce unrelated addresses from the same entropy.
  final ed = LocalWallet(index: 0, algorithm: XRPKeyAlgorithm.ed25519);
  final secp = LocalWallet(index: 0, algorithm: XRPKeyAlgorithm.secp256k1);
  print('same entropy, different algorithms:');
  print(field('ed25519', ed.address));
  print(field('secp256k1', secp.address));
  print(field('same address', '${ed.address == secp.address}'));

  await net.close();
  print('');
  print('done.');
}

List<int> utf8Bytes(String value) => BytesUtils.fromHexString(
  value.codeUnits.map((c) => c.toRadixString(16).padLeft(2, '0')).join(),
);