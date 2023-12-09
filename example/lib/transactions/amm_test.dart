// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrp_dart/xrp_dart.dart';

import '../main.dart';

/// for now AMM methods working only in devnet-AMM. I don't know that's working on the main or not
void ammTest() async {
  final issueAddress = XRPPrivateKey.fromHex(
      "0088D50FAE117Cc0F49667431E8B151DFD392411003B305667FD73666DDF32ABBC5");

  final hotWallet =
      XRPPrivateKey.fromEntropy("78707270555d4651a9092fbffb791f3d");
  final destination =
      XRPPrivateKey.fromEntropy("da804b5221eae9c404dfe748bf2ccfba");
  // await aMMCreate(
  //   destination,
  //   issueAddress.getPublic().toAddress().toXAddress(),
  // );

  // await aMMVote(
  //   destination,
  //   issueAddress.getPublic().toAddress().address,
  // );
  // await aMMDelete(
  //   destination,
  //   issueAddress.getPublic().toAddress().address,
  // );
  // await aMMDeposit(
  //   destination,
  //   issueAddress.getPublic().toAddress().address,
  // );
  await aMMWithdraw(
    destination,
    issueAddress.getPublic().toAddress().address,
  );
}

Future<void> aMMCreate(XRPPrivateKey coldAddress, String issueAddress) async {
  final String ownerAddress = coldAddress.getPublic().toAddress().address;
  final String ownerPublic = coldAddress.getPublic().toHex();

  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  final accountSet = AMMCreate(
      amount2: CurrencyAmount.xrp(BigInt.from(100000)),
      tradingFee: 75,
      amount: CurrencyAmount.issue(IssuedCurrencyAmount(
          value: "5", currency: "MRT", issuer: issueAddress)),
      account: ownerAddress,
      signingPubKey: ownerPublic,
      memos: [memo]);
  print("autfil trnsction");
  print("AMMCreate fee is high. for example in testnet give 2m drops (2XRP)");
  await XRPHelper.autoFill(rpc, accountSet);

  final blob = accountSet.toBlob();
  print("sign transction");
  final sig = coldAddress.sign(blob);
  print("Set transaction signature");
  accountSet.setSignature(sig);

  final trhash = accountSet.getHash();
  print("transaction hash: $trhash");

  final trBlob = accountSet.toBlob(forSigning: false);

  print("regenarate transaction blob with exists signatures");
  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob, failHard: true);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> aMMDelete(XRPPrivateKey coldAddress, String issueAddress) async {
  final String ownerAddress = coldAddress.getPublic().toAddress().address;
  final String ownerPublic = coldAddress.getPublic().toHex();

  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  final transaction = AMMDelete(
      asset2: XRP(),
      asset: IssuedCurrency(currency: "MRT", issuer: issueAddress),
      account: ownerAddress,
      signingPubKey: ownerPublic,
      memos: [memo]);
  print("autfil trnsction");
  print("AMMCreate fee is high. for example in testnet give 2m drops (2XRP)");
  await XRPHelper.autoFill(rpc, transaction);

  final blob = transaction.toBlob();
  print("sign transction");
  final sig = coldAddress.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);

  final trhash = transaction.getHash();
  print("transaction hash: $trhash");

  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob, failHard: true);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> aMMVote(XRPPrivateKey coldAddress, String issueAddress) async {
  final String ownerAddress = coldAddress.getPublic().toAddress().address;
  final String ownerPublic = coldAddress.getPublic().toHex();

  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  final transaction = AMMVote(
      tradingFee: 12,
      asset2: XRP(),
      asset: IssuedCurrency(currency: "MRT", issuer: issueAddress),
      account: ownerAddress,
      signingPubKey: ownerPublic,
      memos: [memo]);

  print("autfil trnsction");
  await XRPHelper.autoFill(rpc, transaction);

  final blob = transaction.toBlob();
  print("sign transction");
  final sig = coldAddress.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);

  final trhash = transaction.getHash();
  print("transaction hash: $trhash");

  final trBlob = transaction.toBlob(forSigning: false);

  print("regenarate transaction blob with exists signatures");
  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob, failHard: true);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> aMMDeposit(XRPPrivateKey coldAddress, String issueAddress) async {
  final String ownerAddress = coldAddress.getPublic().toAddress().address;
  final String ownerPublic = coldAddress.getPublic().toHex();

  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  final transaction = AMMDeposit(
      asset2: XRP(),
      asset: IssuedCurrency(currency: "MRT", issuer: issueAddress),
      account: ownerAddress,
      signingPubKey: ownerPublic,
      memos: [memo]);
  print("autfil trnsction");
  await XRPHelper.autoFill(rpc, transaction);

  final blob = transaction.toBlob();
  print("sign transction");
  final sig = coldAddress.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);

  final trhash = transaction.getHash();
  print("transaction hash: $trhash");

  final trBlob = transaction.toBlob(forSigning: false);

  print("regenarate transaction blob with exists signatures");
  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob, failHard: true);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> aMMWithdraw(XRPPrivateKey coldAddress, String issueAddress) async {
  final String ownerAddress = coldAddress.getPublic().toAddress().address;
  final String ownerPublic = coldAddress.getPublic().toHex();

  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  final transaction = AMMWithdraw(
      // tradingFee: 12,
      asset2: XRP(),
      asset: IssuedCurrency(currency: "MRT", issuer: issueAddress),
      account: ownerAddress,
      signingPubKey: ownerPublic,
      memos: [memo]);
  print("autfil trnsction");
  await XRPHelper.autoFill(rpc, transaction);

  final blob = transaction.toBlob();
  print("sign transction");
  final sig = coldAddress.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);

  final trhash = transaction.getHash();
  print("transaction hash: $trhash");

  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");
  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob, failHard: true);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}
