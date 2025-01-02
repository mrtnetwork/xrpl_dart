// ignore_for_file: avoid_print

import 'package:example/socket_rpc_example/socket_service.dart';
import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void paymentExample() async {
  await simplePaymentEdward();
  await simplePaymentSecp256();
}

Future<void> simplePaymentEdward() async {
  final account = QuickWallet.create(300, algorithm: XRPKeyAlgorithm.ed25519);
  final destination =
      QuickWallet.create(301, algorithm: XRPKeyAlgorithm.ed25519);

  final transaction = Payment(
      amount: CurrencyAmount.xrp(XRPHelper.xrpDecimalToDrop("125.75")),
      destination: destination.address,
      account: account.address,
      signer: XRPLSignature.signer(account.pubHex),
      memos: [exampleMemo]);
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

  /// https://devnet.xrpl.org/transactions/A35C4CEACD76D180F437D966655B63215A1B6CCBBABFA11653CFBD486F454A7D
}

Future<void> simplePaymentSecp256() async {
  final account = QuickWallet.create(300);
  final destination = QuickWallet.create(301);

  final transaction = Payment(
      amount: CurrencyAmount.xrp(XRPHelper.xrpDecimalToDrop("125.75")),
      destination: destination.address,
      account: account.address,
      signer: XRPLSignature.signer(account.pubHex),
      memos: [exampleMemo]);
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

  /// https://devnet.xrpl.org/transactions/729797EE0DC74F6FD267D099F6A3BD4AEAF4D240D3E6DE35BBA697D8DD823138
}

Future<void> exampleWithWebScoket() async {
  final account = QuickWallet.create(300, algorithm: XRPKeyAlgorithm.ed25519);
  final destination =
      QuickWallet.create(301, algorithm: XRPKeyAlgorithm.ed25519);

  final transaction = Payment(
      amount: CurrencyAmount.xrp(XRPHelper.xrpDecimalToDrop("125.75")),
      destination: destination.address,
      account: account.address,
      signer: XRPLSignature.signer(account.pubHex),
      memos: [exampleMemo]);
  final socketRpc = await XRPProvider.devNet((httpUri, websocketUri) async {
    return await RPCWebSocketService.connect(websocketUri);
  });
  await XRPHelper.autoFill(socketRpc, transaction);
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
  final result = await socketRpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/E1EA8A5AE3E65AF866809906CBE486CAF654A8E2CB79CC80AA64A615F7A46661
}
