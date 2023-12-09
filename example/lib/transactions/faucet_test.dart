// ignore_for_file: avoid_print

import 'package:blockchain_utils/bip/mnemonic/mnemonic.dart';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrp_dart/xrp_dart.dart';

import '../main.dart';

void faucet() async {
  final entropy = Bip39SeedGenerator(Mnemonic.fromString(
          "spawn have inflict celery market settle expand foil scrub august valid cactus"))
      .generate();
  final bip32 = Bip44.fromSeed(entropy, Bip44Coins.ripple)
      .purpose
      .coin
      .account(0)
      .change(Bip44Changes.chainExt)
      .addressIndex(9);
  final privateKey = XRPPrivateKey.fromBytes(bip32.privateKey.raw);
  final publicKey = privateKey.getPublic();
  final address = publicKey.toAddress();

  final resp =
      await rpc.getFucent(address.toXAddress(forTestnet: true, tag: 1024));
  print("resp $resp");
}
