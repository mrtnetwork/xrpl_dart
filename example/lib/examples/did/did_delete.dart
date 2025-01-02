// ignore_for_file: avoid_print

import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void didDelete() async {
  final masterWallet = QuickWallet.create(3, account: 5);

  final transaction = DIDDelete(
      account: masterWallet.address,
      signer: XRPLSignature.signer(masterWallet.pubHex),
      memos: [exampleMemo]);
  await XRPHelper.autoFill(masterWallet.rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = masterWallet.privateKey.sign(blob);
  transaction.setSignature(sig);
  final trBlob = transaction.toBlob(forSigning: false);
  final result =
      await masterWallet.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("is success: ${result.isSuccess}");
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");

  /// https://devnet.xrpl.org/transactions/5A5AC6FFB09940CB4CFA87FF5D196A7795E44D5CAE7FD76474B033BB5B439066
}
