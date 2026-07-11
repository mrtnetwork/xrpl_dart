// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:example/socket_rpc_example/http_service.dart';
import 'package:http/http.dart' show Client;
import 'package:xrpl_dart/xrpl_dart.dart';
import 'package:http/http.dart' as http;

String memoData = BytesUtils.toHexString(
    utf8.encode("https://github.com/mrtnetwork/xrpl_dart"));
String memoType = BytesUtils.toHexString(utf8.encode("Text"));
String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
final exampleMemo =
    XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);

class QuickWallet {
  final String? fucentUrl;
  QuickWallet(this.privateKey, {XRPProvider? rpc, String? fucentUrl})
      : rpc = rpc ??
            XRPProvider(
              RPCHttpService(XRPProviderConst.devnetUri, http.Client()),
            ),
        fucentUrl = fucentUrl ??
            (rpc == null
                ? XRPProvider.getFaucetUrl(XRPProviderConst.devnetUri)
                : null) {
    print(
        "wallet created $address\n${privateKey.toHex()}\n$pubHex\n====================================");
  }
  factory QuickWallet.create(int index,
      {int account = 0,
      XRPProvider? rpc,
      XRPKeyAlgorithm algorithm = XRPKeyAlgorithm.secp256k1,
      String? fucentUrl}) {
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
        fucentUrl: fucentUrl,
        rpc: rpc);
  }
  final XRPPrivateKey privateKey;

  XRPPublicKey get publicKey => privateKey.getPublic();
  XRPXAddress get toAddress => publicKey.toXAddress(ChainType.testnet);

  String get address => toAddress.classicAddress;
  String get xAddress => toAddress.address;
  String get pubHex => publicKey.toHex();
  final XRPProvider rpc;

  /// get fucent in specify node
  Future<String> fucent({String? addr}) async {
    final url = fucentUrl;
    if (url == null) throw Exception("missing fucent url");
    final requestPayload = {
      'destination': addr ?? address,
      'userAgent': 'xrpl-dart'
    };
    final client = Client();
    final response = await client.post(Uri.parse(url),
        body: StringUtils.encodeJson(requestPayload));
    assert(response.statusCode <= 200 && response.statusCode < 300,
        "fucent failed ${response.body}.");
    return response.body;
  }
}
