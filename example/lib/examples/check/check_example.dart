// ignore_for_file: avoid_print

import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void checkExamples() async {
  final account =
      QuickWallet.create(3, algorithm: XRPKeyAlgorithm.secp256k1, account: 20);

  final destination =
      QuickWallet.create(4, algorithm: XRPKeyAlgorithm.secp256k1, account: 20);

  /// https://devnet.xrpl.org/transactions/B75D2646B81924AEF4D3A46BDCA16FB79EA0DC7CC70E8CF489F482096D014598/detailed
  await checkCreate(account, destination.address,
      CurrencyAmount.xrp(XRPHelper.xrpDecimalToDrop("500")));

  /// cancelcheck
  await cancelCheck(account);

  /// create another check
  /// https://devnet.xrpl.org/transactions/7D787978F8464AB0727BF88B144EA0B9A9B08B12137A1C8821CEE50BBED9D21F/detailed
  await checkCreate(account, destination.address,
      CurrencyAmount.xrp(XRPHelper.xrpDecimalToDrop("617.02839")));

  /// cash
  await chechCash(destination,
      amount: CurrencyAmount.xrp(XRPHelper.xrpDecimalToDrop("617.02839")));
}

Future<void> checkCreate(
    QuickWallet account, String destination, CurrencyAmount sendMax) async {
  final transaction = CheckCreate(
    sendMax: sendMax,
    destination: destination,
    account: account.address,
    signer: XRPLSignature.signer(account.pubHex),
    memos: [exampleMemo],
  );
  print("autfil trnsction");
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
}

Future<void> cancelCheck(QuickWallet account) async {
  final checkInfo = await account.rpc.request(XRPRequestAccountObjectType(
      account: account.address, type: AccountObjectType.check));
  final String checkIndex = checkInfo["account_objects"][0]["index"];

  final transaction = CheckCancel(
    account: account.address,
    signer: XRPLSignature.signer(account.pubHex),
    checkId: checkIndex,
    memos: [exampleMemo],
  );
  print("autfil trnsction");
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

  /// https://devnet.xrpl.org/transactions/63AB56B06D61A7C0768DB3E97F995426C386155B5C146C6B73BC1F186E126D7C/detailed
}

Future<void> chechCash(QuickWallet destination,
    {CurrencyAmount? amount}) async {
  final checkInfo = await destination.rpc.request(XRPRequestAccountObjectType(
      account: destination.address, type: AccountObjectType.check));

  final String checkIndex = checkInfo["account_objects"][0]["index"];
  final transction = CheckCash(
    account: destination.address,
    signer: XRPLSignature.signer(destination.pubHex),
    amount: amount,
    checkId: checkIndex,
    memos: [exampleMemo],
  );
  print("autfil trnsction");
  await XRPHelper.autoFill(destination.rpc, transction);
  final blob = transction.toBlob();
  print("sign transction");
  final sig = destination.privateKey.sign(blob);
  print("Set transaction signature");
  transction.setSignature(sig);

  final trhash = transction.getHash();
  print("transaction hash: $trhash");

  final trBlob = transction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result =
      await destination.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/90C9F69DAAF7ED264924EABB3A8D7FC1213E00A30F6C312464122F474AF93DFB/detailed
}
