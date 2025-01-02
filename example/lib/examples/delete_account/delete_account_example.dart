// ignore_for_file: avoid_print

import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void deleteAccountExample() async {
  final account =
      QuickWallet.create(3, algorithm: XRPKeyAlgorithm.secp256k1, account: 20);

  final anotherAccount =
      QuickWallet.create(4, algorithm: XRPKeyAlgorithm.secp256k1, account: 20);
  await deleteAccount(account, anotherAccount.address);
}

Future<void> deleteAccount(QuickWallet account, String destionation) async {
  final transaction = AccountDelete(
    account: account.address,
    memos: [exampleMemo],
    destination: destionation,
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

  /// https://devnet.xrpl.org/transactions/F349DE996367A90AC32FB3D858D3EDB57D946277B9A4E2B93AFD41E7C43C7A7F
}
