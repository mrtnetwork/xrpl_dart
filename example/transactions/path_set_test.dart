// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:xrp_dart/src/crypto/keypair/xrpl_private_key.dart';
import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/xrpl/helper.dart';
import 'package:xrp_dart/src/xrpl/models/currencies/currencies.dart';
import 'package:xrp_dart/src/xrpl/models/memo/memo.dart';
import 'package:xrp_dart/src/xrpl/models/payment/payment.dart';

import '../main.dart';

void pathSetTest() async {
  final hotWallet =
      XRPPrivateKey.fromEntropy("78707270555d4651a9092fbffb791f3d");

  await sendUsingPath(hotWallet);
}

Future<void> sendUsingPath(XRPPrivateKey owner) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();
  final destinationAmount = IssuedCurrencyAmount(
    value: "0.001",
    currency: "USD",
    issuer: "rVnYNK9yuxBz4uP8zC8LEFokM2nqH3poc",
  );
  final data = await rpc.getRipplePathFound(
      sourceAccount: owner.getPublic().toAddress().address,
      destinationAccount: "rKT4JX4cCof6LcDYRz8o3rGRu7qxzZ2Zwj",
      destinationAmount: CurrencyAmount.issue(destinationAmount),
      currencies: [XRP()]);
  print("paths ${data.alternatives.first.pathsComputed}");
  String memoData = bytesToHex(utf8.encode("https://github.com/MohsenHaydari"));
  String memoType = bytesToHex(utf8.encode("Text"));
  String mempFormat = bytesToHex(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  print("owner public: $ownerPublic");
  final transaction = Payment(
      destination: "rKT4JX4cCof6LcDYRz8o3rGRu7qxzZ2Zwj",
      account: ownerAddress,
      signingPubKey: ownerPublic,
      memos: [memo],
      paths: data.alternatives.first.pathsComputed,
      amount: CurrencyAmount.issue(destinationAmount));
  print("autfil trnsction");
  await autoFill(rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = owner.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);

  final trhash = transaction.getHash();
  print("transaction hash: $trhash");

  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}
