// ignore_for_file: avoid_print

import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void tagExamples() async {
  final account =
      QuickWallet.create(3, algorithm: XRPKeyAlgorithm.secp256k1, account: 20);

  final anotherAccount =
      QuickWallet.create(4, algorithm: XRPKeyAlgorithm.secp256k1, account: 20);
  await setupRequiredDestinationTag(account);
  await sendPaymentToDestinationRequiredTag(
      anotherAccount, account.address, 25);
  await sendFromSourceTag(account, anotherAccount.address, 25);
}

Future<void> setupRequiredDestinationTag(QuickWallet account) async {
  final transaction = AccountSet(
    setFlag: AccountSetAsfFlag.asfRequireDest,
    account: account.address,
    memos: [exampleMemo],
    signer: XRPLSignature.signer(account.pubHex),
  );
  await XRPHelper.autoFill(account.rpc, transaction);
  final blob = transaction.toBlob();
  // return;
  print("sign transction");
  final sig = account.privateKey.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);
  final trhash = transaction.getHash();
  print("transaction hash: $trhash");
  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");
  // return;
  print("broadcasting signed transaction blob");
  final result =
      await account.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/BF6AE43E8A296583CB0540C82AA0D4CB28248DFCC1F2051BB2F3E000A35753B5
}

Future<void> sendPaymentToDestinationRequiredTag(
    QuickWallet account, String destination, int tag) async {
  final XRPAddress destinationAddress = XRPAddress(destination);
  final destinationXAddress =
      destinationAddress.toXAddress(isTestnet: true, tag: tag);
  final transaction = Payment(
      amount: CurrencyAmount.xrp(XRPHelper.xrpDecimalToDrop("125.75")),
      destination: destinationXAddress,
      destinationTag: tag,
      account: account.address,
      signer: XRPLSignature.signer(account.pubHex),
      memos: [exampleMemo]);
  await XRPHelper.autoFill(account.rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = account.privateKey.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);
  final trhash = transaction.getHash();
  print("transaction hash: $trhash");
  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result =
      await account.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/6BC2E40E5B74BC2FF7C4737055DC31E7E52178F66C41D1A0ADDA8864EC62B5DE
}

Future<void> sendFromSourceTag(
    QuickWallet account, String destination, int tag) async {
  final transaction = Payment(
      amount: CurrencyAmount.xrp(XRPHelper.xrpDecimalToDrop("25")),
      destination: destination,
      sourceTag: tag,
      account:
          XRPAddress(account.address).toXAddress(isTestnet: true, tag: tag),
      signer: XRPLSignature.signer(account.pubHex),
      memos: [exampleMemo]);
  await XRPHelper.autoFill(account.rpc, transaction);
  final blob = transaction.toBlob();

  print("sign transction");
  final sig = account.privateKey.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);
  final trhash = transaction.getHash();
  print("transaction hash: $trhash");
  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");
  // return;
  print("broadcasting signed transaction blob");
  final result =
      await account.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/691926DD4CDF87527699BD20CA1F96B8616B57BE0C90A6AD3353DD420953DAA7
}
