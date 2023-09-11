// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';
import 'package:xrp_dart/src/crypto/keypair/xrpl_private_key.dart';
import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/xrpl/helper.dart';
import 'package:xrp_dart/src/xrpl/models/memo.dart';
import 'package:xrp_dart/src/xrpl/models/payment_channel/payment_channel_claim.dart';
import 'package:xrp_dart/src/xrpl/models/payment_channel/payment_channel_create.dart';
import 'package:xrp_dart/src/xrpl/models/payment_channel/payment_channel_fund.dart';

import '../main.dart';

void paymentChannelTest() async {
  final masterWallet =
      XRPPrivateKey.fromEntropy("f7f9ff93d716eaced222a3c52a3b2a36");
  final destinationWallet =
      XRPPrivateKey.fromEntropy("396c8a5c6e088518b469822923b17039");
  await createPaymentChannel(
      masterWallet, destinationWallet.getPublic().toAddress().address);
  await claimPaymentChannel(masterWallet, masterWallet);
  await fundPaymentChannel(masterWallet);
}

Future<void> createPaymentChannel(
    XRPPrivateKey owner, String destinationAddress) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();

  String memoData = bytesToHex(utf8.encode("MRTNETWORK.com"));
  String memoType = bytesToHex(utf8.encode("Text"));
  String mempFormat = bytesToHex(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  print("owner public: $ownerPublic");
  final transaction = PaymentChannelCreate(
    account: ownerAddress,
    signingPubKey: ownerPublic,
    destination: destinationAddress,
    memos: [memo],
    amount: BigInt.from(1000000),
    publicKey: owner.getPublic().toHex(),
    settleDelay: 1,
  );
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
  print("regenarate transaction blob");

  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> claimPaymentChannel(
    XRPPrivateKey owner, XRPPrivateKey publicxx) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();

  String memoData = bytesToHex(utf8.encode("MRTNETWORK.com"));
  String memoType = bytesToHex(utf8.encode("Text"));
  String mempFormat = bytesToHex(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  const String channelId =
      "752AB3DDFCF93A39BD0B861F2115CF47E8092DD0511303311D275BB2DC5D2025";
  print("owner public: $ownerPublic");
  final transaction = PaymentChannelClaim(
    account: ownerAddress,
    signingPubKey: ownerPublic,
    channel: channelId,
    flags: PaymentChannelClaimFlag.TF_CLOSE.value,
    memos: [memo],
    publicKey: owner.getPublic().toHex(),
    amount: BigInt.from(1000000),
  );
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
  print("regenarate transaction blob");

  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> fundPaymentChannel(XRPPrivateKey owner) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();

  String memoData = bytesToHex(utf8.encode("MRTNETWORK.com"));
  String memoType = bytesToHex(utf8.encode("Text"));
  String mempFormat = bytesToHex(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  const String channelId =
      "752AB3DDFCF93A39BD0B861F2115CF47E8092DD0511303311D275BB2DC5D2025";
  print("owner public: $ownerPublic");
  final transaction = PaymentChannelFund(
    account: ownerAddress,
    memos: [memo],
    signingPubKey: ownerPublic,
    channel: channelId,
    amount: BigInt.from(10000000),
  );
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
  print("regenarate transaction blob");

  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}
