// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrp_dart/xrp_dart.dart';
import '../main.dart';

void issueTokenTest() async {
  final hotWallet =
      XRPPrivateKey.fromEntropy("78707270555d4651a9092fbffb791f3d");
  final coldWallet =
      XRPPrivateKey.fromEntropy("da804b5221eae9c404dfe748bf2ccfba");
  await configureIsuuerAddress(coldWallet);
  await configureHotWalletAddress(hotWallet);
  await createTrustLineFromHotWalletToColdWallet(
      hotWallet, coldWallet.getPublic().toAddress().address);
  await sendToken(coldWallet, coldWallet.getPublic().toAddress().address,
      hotWallet.getPublic().toAddress().address);
}

Future<void> configureIsuuerAddress(XRPPrivateKey coldAddress) async {
  final String ownerAddress = coldAddress.getPublic().toAddress().address;
  print(ownerAddress);
  final String ownerPublic = coldAddress.getPublic().toHex();

  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  print("owner public: $ownerPublic");
  final accountSet = AccountSet(
      transferRate: 0,
      tickSize: 5,
      domain: memoData,
      account: ownerAddress,
      signingPubKey: ownerPublic,
      memos: [memo],
      setFlag: AccountSetAsfFlag.asfDefaultRipple);
  print("autfil trnsction");
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
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> configureHotWalletAddress(XRPPrivateKey hotWallet) async {
  final String ownerAddress = hotWallet.getPublic().toAddress().address;
  final String ownerPublic = hotWallet.getPublic().toHex();

  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  print("owner public: $ownerPublic");
  final accountSet = AccountSet(
      account: ownerAddress,
      signingPubKey: ownerPublic,
      memos: [memo],
      setFlag: AccountSetAsfFlag.asfRequireAuth);
  print("autofill trnsction");
  await XRPHelper.autoFill(rpc, accountSet);
  final blob = accountSet.toBlob();
  print("sign transction");
  final sig = hotWallet.sign(blob);
  print("Set transaction signature");
  accountSet.setSignature(sig);
  final trhash = accountSet.getHash();
  print("transaction hash: $trhash");

  final trBlob = accountSet.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> createTrustLineFromHotWalletToColdWallet(
    XRPPrivateKey hotWallet, String coldWalletAddress) async {
  final String ownerAddress = hotWallet.getPublic().toAddress().address;
  final String ownerPublic = hotWallet.getPublic().toHex();

  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  print("owner public: $ownerPublic");
  final trustLine = TrustSet(
    account: ownerAddress,
    signingPubKey: ownerPublic,
    limitAmount: IssuedCurrencyAmount(
      value: "10000000000",
      currency: "FOO",
      issuer: coldWalletAddress,
    ),
    memos: [memo],
  );
  print("autofill trnsction");
  await XRPHelper.autoFill(rpc, trustLine);
  final blob = trustLine.toBlob();
  print("sign transction");
  final sig = hotWallet.sign(blob);
  print("Set transaction signature");
  trustLine.setSignature(sig);
  final trhash = trustLine.getHash();
  print("transaction hash: $trhash");
  final trBlob = trustLine.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> sendToken(XRPPrivateKey hotWallet, String coldWalletAddress,
    String destination) async {
  final String ownerAddress = hotWallet.getPublic().toAddress().address;
  final String ownerPublic = hotWallet.getPublic().toHex();

  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  final sendToken = Payment(
    destination: destination,
    account: ownerAddress,
    signingPubKey: ownerPublic,
    memos: [memo],
    fee: "10",
    sequence: 41057009,
    lastLedgerSequence: 41057170,
    amount: CurrencyAmount.issue(IssuedCurrencyAmount(
      value: "12.000022",
      currency: "FOO",
      issuer: coldWalletAddress,
    )),
  );
  print("autofill trnsction");
  await XRPHelper.autoFill(rpc, sendToken);
  final blob = sendToken.toBlob();
  print("sign transction");
  final sig = hotWallet.sign(blob);
  print("Set transaction signature");
  sendToken.setSignature(sig);
  final trhash = sendToken.getHash();
  print("transaction hash: $trhash");
  final trBlob = sendToken.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}
