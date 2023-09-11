// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:xrp_dart/src/rpc/xrpl_rpc.dart';
import 'package:xrp_dart/src/crypto/keypair/xrpl_private_key.dart';
import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/xrpl/helper.dart';
import 'package:xrp_dart/src/xrpl/models/account/accountset.dart';
import 'package:xrp_dart/src/xrpl/models/memo/memo.dart';
import 'package:xrp_dart/src/xrpl/models/account/set_reqular_key.dart';

final rpc = XRPLRpc.testNet();

void blockHoleTest() async {
  final owner = XRPPrivateKey.fromHex(
      "ED799B7E73DA39C20378898B723B615E12EEC2BE6351698FA6525EAC7D35DD1321");
  // await setBlockHoleAccount(owner);
  await disableMaster(owner);
}

Future<void> setBlockHoleAccount(XRPPrivateKey owner) async {
  final String ownerAddress =
      owner.getPublic().toAddress().toXAddress(isTestNetwork: true);
  final String ownerPublic = owner.getPublic().toHex();

  String memoData = bytesToHex(utf8.encode("MRTNETWORK.com"));
  String memoType = bytesToHex(utf8.encode("Text"));
  String mempFormat = bytesToHex(utf8.encode("text/plain"));
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
  await autoFill(rpc, transaction);
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

  String memoData = bytesToHex(utf8.encode("MRTNETWORK.com"));
  String memoType = bytesToHex(utf8.encode("Text"));
  String mempFormat = bytesToHex(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  final transaction = AccountSet(
      setFlag: AccountSetAsfFlag.ASF_DISABLE_MASTER,
      account: owner.getPublic().toAddress().address,
      memos: [memo],
      signingPubKey: signerPublic);
  print("autfil trnsction");
  await autoFill(rpc, transaction);
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
