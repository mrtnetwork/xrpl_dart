// ignore_for_file: avoid_print

import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void depositePreAuth() async {
  final hotWallet =
      QuickWallet.create(350, algorithm: XRPKeyAlgorithm.secp256k1);
  final coldWallet =
      QuickWallet.create(351, algorithm: XRPKeyAlgorithm.ed25519);
  await authorize(hotWallet, coldWallet.address);
  await unauthorize(hotWallet, coldWallet.address);
}

Future<void> authorize(QuickWallet account, String autorize) async {
  final transaction = DepositPreauth(
    account: account.address,
    authorize: autorize,
    memos: [exampleMemo],
    signer: XRPLSignature.signer(account.pubHex),
  );
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

  /// https://devnet.xrpl.org/transactions/9BF07070F9424A94D89DA2FDE5FAD2145AF7298FA95D2084A7452BF8FE279E20
}

Future<void> unauthorize(QuickWallet account, String autorize) async {
  final transaction = DepositPreauth(
    account: account.address,
    unauthorize: autorize,
    memos: [exampleMemo],
    signer: XRPLSignature.signer(account.pubHex),
  );
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

  /// https://devnet.xrpl.org/transactions/D31C36250F1458D38EBCF308CAEAEE465C222B78BE38E09C1C7A02C12F660445
}
