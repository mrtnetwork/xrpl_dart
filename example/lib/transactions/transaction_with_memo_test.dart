// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrp_dart/xrp_dart.dart';
import '../main.dart';

void transactionWithMemo() async {
  final hotWallet =
      XRPPrivateKey.fromEntropy("f7f9ff93d716eaced222a3c52a3b2a36");
  final hotWallet2 =
      XRPPrivateKey.fromEntropy("396c8a5c6e088518b469822923b17039");
  await sendXRPL(hotWallet2.getPublic().toAddress().address, hotWallet,
      CurrencyAmount.xrp(BigInt.from(1000000)));
}

Future<void> sendXRPL(
    String destination, XRPPrivateKey owner, CurrencyAmount amount) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();

  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  print("owner public: $ownerPublic");
  final transaction = Payment(
      destination: destination,
      account: ownerAddress,
      memos: [memo],
      amount: amount,
      signingPubKey: ownerPublic);
  print("autofill trnsction");
  await XRPHelper.autoFill(rpc, transaction);
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
