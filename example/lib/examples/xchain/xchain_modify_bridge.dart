// ignore_for_file: avoid_print

import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void xChainModifyBridge() async {
  final wallet = QuickWallet.create(2, account: 1);

  final modifyBridge = XChainModifyBridge(
    xchainBridge: XChainBridge(
        issuingChainDoor: "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
        issuingChainIssue: XRP(),
        lockingChainDoor: wallet.address,
        lockingChainIssue: XRP()),
    signatureReward: BigInt.from(400),
    account: wallet.address,
    signer: XRPLSignature.signer(wallet.pubHex),
    minAccountCreateAmount: XRPHelper.xrpDecimalToDrop("10"),
    memos: [exampleMemo],
  );

  await XRPHelper.autoFill(wallet.rpc, modifyBridge);

  final blob = modifyBridge.toBlob();
  print("sign transction");
  final sig = wallet.privateKey.sign(blob);
  print("Set transaction signature");
  modifyBridge.setSignature(sig);

  final trhash = modifyBridge.getHash();
  print("transaction hash: $trhash");

  final trBlob = modifyBridge.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await wallet.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/C2322B9AC27B42BC85B06B4CA55619220BAC884442A8245ED6C74C85A97ECA86
}
