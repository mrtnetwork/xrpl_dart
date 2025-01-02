// ignore_for_file: avoid_print

import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void xChainBridge() async {
  final wallet = QuickWallet.create(2, account: 1);

  final bridge = XChainCreateBridge(
      account: wallet.address,
      signatureReward: BigInt.from(2000),
      minAccountCreateAmount: XRPHelper.xrpDecimalToDrop("10"),
      signer: XRPLSignature.signer(wallet.pubHex),
      memos: [exampleMemo],
      xchainBridge: XChainBridge(
          issuingChainDoor: "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
          issuingChainIssue: XRP(),
          lockingChainDoor: wallet.address,
          lockingChainIssue: XRP()));
  await XRPHelper.autoFill(wallet.rpc, bridge);

  final blob = bridge.toBlob();
  print("sign transction");
  final sig = wallet.privateKey.sign(blob);
  print("Set transaction signature");
  bridge.setSignature(sig);

  final trhash = bridge.getHash();
  print("transaction hash: $trhash");

  final trBlob = bridge.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await wallet.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/752E66A8C038E0A1322D4E6A8A1996FBCF43BF5A1309EFA0DAA5BA8160D54E68
}
