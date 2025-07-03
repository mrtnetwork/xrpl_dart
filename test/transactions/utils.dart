// ignore_for_file: avoid_print

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

class QuickWallet {
  QuickWallet(this.privateKey, {XRPProvider? rpc});
  factory QuickWallet.create(int index,
      {int account = 0,
      XRPProvider? rpc,
      XRPKeyAlgorithm algorithm = XRPKeyAlgorithm.secp256k1}) {
    final entropy = Bip39SeedGenerator(Mnemonic.fromString(
            "spawn have inflict celery market settle expand foil scrub august valid cactus"))
        .generate();
    final bip32 = Bip44.fromSeed(entropy, Bip44Coins.ripple)
        .purpose
        .coin
        .account(account)
        .change(Bip44Changes.chainExt)
        .addressIndex(index);
    return QuickWallet(
        XRPPrivateKey.fromBytes(bip32.privateKey.raw, algorithm: algorithm),
        rpc: rpc);
  }
  final XRPPrivateKey privateKey;

  XRPPublicKey get publicKey => privateKey.getPublic();
  String get address => publicKey.toAddress().toString();
  String get xAddress => publicKey.toAddress().toXAddress(isTestnet: true);
  String get pubHex => publicKey.toHex();
}
