// ignore_for_file: avoid_print

import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void didset() async {
  final masterWallet = QuickWallet.create(3, account: 5);
  const String validField = "1234567890abcdefABCDEF";

  final transaction = DIDSet(
      account: masterWallet.address,
      signer: XRPLSignature.signer(masterWallet.pubHex),
      didDocument: validField,
      data: validField,
      uri: validField,
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

  /// https://devnet.xrpl.org/transactions/8B6E741AFA9FC2644ED9C99DAE0770CE329BDBB83B642F455BB7936E1DD20A19
}
