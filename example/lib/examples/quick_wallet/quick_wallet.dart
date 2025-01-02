// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:example/socket_rpc_example/http_service.dart';
import 'package:xrpl_dart/xrpl_dart.dart';
import 'package:http/http.dart' as http;

String memoData = BytesUtils.toHexString(
    utf8.encode("https://github.com/mrtnetwork/xrpl_dart"));
String memoType = BytesUtils.toHexString(utf8.encode("Text"));
String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
final exampleMemo =
    XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);

class QuickWallet {
  QuickWallet(this.privateKey, {XRPProvider? rpc})
      : rpc = rpc ??
            XRPProvider(
                RPCHttpService(XRPProviderConst.testnetUri, http.Client())) {
    print(
        "wallet created $address\n${privateKey.toHex()}\n$pubHex\n====================================");
  }
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
  final XRPProvider rpc;
  Future<void> fucent({String? addr}) async {
    final resp = await rpc.getFucent(addr ?? address);
    print(resp);
  }
}
