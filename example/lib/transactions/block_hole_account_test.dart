// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:blockchain_utils/blockchain_utils.dart';

import 'package:xrp_dart/xrp_dart.dart';

import '../main.dart';

void blockHoleTest() async {
  final owner = XRPPrivateKey.fromHex(
      "ED799B7E73DA39C20378898B723B615E12EEC2BE6351698FA6525EAC7D35DD1321");
  // await setBlockHoleAccount(owner);
  await disableMaster(owner);
}

Future<void> setBlockHoleAccount(XRPPrivateKey owner) async {
  final String ownerAddress =
      owner.getPublic().toAddress().toXAddress(forTestnet: true);
  final String ownerPublic = owner.getPublic().toHex();

  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  const String blackholeAddress = "rrrrrrrrrrrrrrrrrrrrBZbvji";
  print("owner public: $ownerPublic");
  final transaction = SetRegularKey(
      account: ownerAddress,
      signingPubKey: ownerPublic,
      regularKey: blackholeAddress,
      memos: [memo]);
  print("autfil trnsction");
  await XRPHelper.autoFill(rpc, transaction);
  final blob = transaction.toBlob();
  print("blob $blob");
  print("sign transction");
  final sig = owner.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);
  final trhash = transaction.getHash();
  print("transaction hash: $trhash");

  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob");

  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> disableMaster(XRPPrivateKey owner) async {
  final String signerPublic = owner.getPublic().toHex();

  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  final transaction = AccountSet(
      setFlag: AccountSetAsfFlag.asfDisableMaster,
      account: owner.getPublic().toAddress().address,
      memos: [memo],
      signingPubKey: signerPublic);
  print("autfil trnsction");
  await XRPHelper.autoFill(rpc, transaction);
  final blob = transaction.toBlob();
  print("blob: $blob");
  print("sign transction with reqular wallet");
  final sig = owner.sign(blob);
  print("sig: $sig");
  print("Set transaction signature");
  transaction.setSignature(sig);
  final trhash = transaction.getHash();
  print("transaction hash: $trhash");

  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob");

  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}
