// ignore_for_file: avoid_print

import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void ammVote() async {
  final isuuerWallet = QuickWallet.create(0, account: 5);
  final lpWallet = QuickWallet.create(1, account: 5);
  final info = await isuuerWallet.rpc.request(XRPRequestAMMInfo(
      asset: XRPCurrency(),
      asset2: IssuedCurrency(currency: "USD", issuer: isuuerWallet.address)));
  final tradingFee = info.amm.tradingFee;
  await _ammVote(
      lpWallet,
      XRPCurrency(),
      IssuedCurrency(currency: "USD", issuer: isuuerWallet.address),
      tradingFee + 15);
}

Future<void> _ammVote(QuickWallet wallet, BaseCurrency assets,
    BaseCurrency assets2, int tradingFee) async {
  final transaction = AMMVote(
      account: wallet.address,
      signer: XRPLSignature.signer(wallet.pubHex),
      tradingFee: tradingFee,
      asset: assets,
      asset2: assets2,
      memos: [exampleMemo]);
  await XRPHelper.autoFill(wallet.rpc, transaction);
  final blob = transaction.toSigningBlobBytes(wallet.toAddress);
  print("sign transction");
  final sig = wallet.privateKey.sign(blob);
  transaction.setSignature(sig);
  final trBlob = transaction.toTransactionBlob();
  final result = await wallet.rpc.request(XRPRequestSubmit(txBlob: trBlob));
  print("is success: ${result.isSuccess}");
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");

  /// https://devnet.xrpl.org/transactions/62D925970E0F84D9FB8B6A1713A157995FCB6498D2A365D3B2F91865475D233E
}
