// ignore_for_file: avoid_print, unused_import, unused_local_variable

import 'dart:convert';
import 'package:xrp_dart/src/rpc/types.dart';
import 'package:xrp_dart/src/rpc/xrpl_rpc.dart';
import 'package:xrp_dart/src/crypto/keypair/xrpl_private_key.dart';
import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/xrpl/bytes/definations/definations.dart';
import 'package:xrp_dart/src/xrpl/helper.dart';
import 'package:xrp_dart/src/xrpl/models/check/check_cancel.dart';
import 'package:xrp_dart/src/xrpl/models/check/check_cash.dart';
import 'package:xrp_dart/src/xrpl/models/check/check_create.dart';
import 'package:xrp_dart/src/xrpl/models/currencies/currencies.dart';
import 'package:xrp_dart/src/xrpl/models/memo.dart';
import 'package:xrp_dart/src/xrpl/models/transaction.dart';

import '../main.dart';
import 'issue_token_test.dart';

void checkTest() async {
  final hotWallet =
      XRPPrivateKey.fromEntropy("78707270555d4651a9092fbffb791f3d");
  final issueWallet =
      XRPPrivateKey.fromEntropy("da804b5221eae9c404dfe748bf2ccfba");
  final destinationWallet =
      XRPPrivateKey.fromEntropy("f7f9ff93d716eaced222a3c52a3b2a36");

  // await checkCreate(
  //     hotWallet,
  //     destinationWallet.getPublic().toAddress().address,
  //     CurrencyAmount.xrp(BigInt.from(10000000)));
  await cancelCheck(hotWallet);
  // await createTrustLineFromHotWalletToColdWallet(
  //     destinationWallet, issueWallet.getPublic().toAddress().address);
  await chechCash(destinationWallet,
      amount: CurrencyAmount.xrp(BigInt.from(10000000)));
  // await rpc.getAccountObjects(hotWallet.getPublic().toAddress().address,
  //     type: AccountObjectType.CHECK);
}

Future<void> checkCreate(
    XRPPrivateKey owner, String destination, CurrencyAmount sendMax) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();

  String memoData = bytesToHex(utf8.encode("https://github.com/MohsenHaydari"));
  String memoType = bytesToHex(utf8.encode("Text"));
  String mempFormat = bytesToHex(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  print("owner public: $ownerPublic");
  final transaction = CheckCreate(
    sendMax: sendMax,
    destination: destination,
    account: ownerAddress,
    signingPubKey: ownerPublic,
    memos: [memo],
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
  print("regenarate transaction blob with exists signatures");
  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> cancelCheck(XRPPrivateKey coldAddress) async {
  final String ownerAddress = coldAddress.getPublic().toAddress().address;
  final String ownerPublic = coldAddress.getPublic().toHex();

  String memoData = bytesToHex(utf8.encode("https://github.com/MohsenHaydari"));
  String memoType = bytesToHex(utf8.encode("Text"));
  String mempFormat = bytesToHex(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);

  const String checkId =
      "10667BCD29ECA1484AD2FFAEE067E3750E3B32DA5DFF43820204DA0EC52469C3";
  print("owner public: $ownerPublic");
  final transaction = CheckCancel(
    account: ownerAddress,
    signingPubKey: ownerPublic,
    checkId: checkId,
    memos: [memo],
  );
  print("autfil trnsction");
  await autoFill(rpc, transaction);
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
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

/// for checkCash if amout is issue, destinaton must create trust line with issue before checkCash
Future<void> chechCash(XRPPrivateKey owner, {CurrencyAmount? amount}) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();

  String memoData = bytesToHex(utf8.encode("https://github.com/MohsenHaydari"));
  String memoType = bytesToHex(utf8.encode("Text"));
  String mempFormat = bytesToHex(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);

  /// get check of address await rpc.getAccountObjects(address,
  /// type: AccountObjectType.CHECK);
  const String checkId =
      "4C9B59CDEAAB70D041C561ABCAF8A69FE2B5B5AD7B6C638518A50B87EAEFED97";
  print("owner public: $ownerPublic");
  final transction = CheckCash(
    account: ownerAddress,
    signingPubKey: ownerPublic,
    amount: amount,
    checkId: checkId,
    memos: [memo],
  );
  print("autfil trnsction");
  await autoFill(rpc, transction);
  final blob = transction.toBlob();
  print("sign transction");
  final sig = owner.sign(blob);
  print("Set transaction signature");
  transction.setSignature(sig);

  final trhash = transction.getHash();
  print("transaction hash: $trhash");

  final trBlob = transction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}
