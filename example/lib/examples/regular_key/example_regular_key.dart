// ignore_for_file: avoid_print

import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void regularKeyExamples() async {
  final account = QuickWallet.create(0, account: 12);

  final regularWallet =
      QuickWallet.create(360, algorithm: XRPKeyAlgorithm.ed25519);
  final destinationWallet =
      QuickWallet.create(380, algorithm: XRPKeyAlgorithm.ed25519);

  /// enable regular key
  await setupOrUpdateReqularKey(account, regularWallet.address);

  /// disable master
  await disableMaster(account);

  /// send xrp with reqular signing
  await sendXrpWithRegularKey(
      account, regularWallet, destinationWallet.address);

  /// enable master again
  await enableMasterFromRegularKey(account, regularWallet);

  /// remove regular key
  await setupOrUpdateReqularKey(account, null);
}

Future<void> setupOrUpdateReqularKey(
    QuickWallet masterWallet, String? reqularWalletAddress) async {
  final transaction = SetRegularKey(
      account: masterWallet.address,
      signer: XRPLSignature.signer(masterWallet.pubHex),
      regularKey: reqularWalletAddress,
      memos: [exampleMemo]);
  print("autfil trnsction");
  await XRPHelper.autoFill(masterWallet.rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = masterWallet.privateKey.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);
  final trhash = transaction.getHash();
  print("transaction hash: $trhash");

  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob");

  final result =
      await masterWallet.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/E22F84F2205AC5093AA1D8C8A8CB245B97C433F909A7F974CE52C9271CC7C3A0
}

Future<void> disableMaster(QuickWallet masterWallet) async {
  final transaction = AccountSet(
      account: masterWallet.address,
      signer: XRPLSignature.signer(masterWallet.pubHex),
      setFlag: AccountSetAsfFlag.asfDisableMaster,
      memos: [exampleMemo]);
  await XRPHelper.autoFill(masterWallet.rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = masterWallet.privateKey.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);
  final trhash = transaction.getHash();
  print("transaction hash: $trhash");

  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob");

  final result =
      await masterWallet.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/6BA1F893EC244ACCBF6896558A57401D1EABEC870328A7A41B8FFDDCAB497DBB
}

Future<void> sendXrpWithRegularKey(
    QuickWallet wallet, QuickWallet reqularWallet, String destination) async {
  final transaction = Payment(
      amount: CurrencyAmount.xrp(XRPHelper.xrpDecimalToDrop("170.009")),
      destination: destination,
      account: wallet.address,
      signer: XRPLSignature.signer(reqularWallet.pubHex),
      memos: [exampleMemo]);
  await XRPHelper.autoFill(wallet.rpc, transaction);
  final blob = transaction.toBlob();
  // return;
  print("sign transction");
  final sig = reqularWallet.privateKey.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);
  final trhash = transaction.getHash();
  print("transaction hash: $trhash");
  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");
  // return;
  print("broadcasting signed transaction blob");
  final result =
      await reqularWallet.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/14BE1C3F8074800C507B8CAEAF4C914EDF7B7E6B36CD600BBD4303FA5DA28C75
}

Future<void> enableMasterFromRegularKey(
    QuickWallet masterWallet, QuickWallet regularWallet) async {
  final transaction = AccountSet(
      account: masterWallet.address,
      signer: XRPLSignature.signer(regularWallet.pubHex),
      clearFlag: AccountSetAsfFlag.asfDisableMaster,
      memos: [exampleMemo]);
  await XRPHelper.autoFill(masterWallet.rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = regularWallet.privateKey.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);
  final trhash = transaction.getHash();
  print("transaction hash: $trhash");

  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob");

  final result =
      await masterWallet.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/ADC4F38C28650968F5CBCEDB54F4F273C8102A54FDFA3DF6B13103111D53A4D0
}
