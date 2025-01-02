// ignore_for_file: avoid_print

import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void xChainCommit() async {
  final wallet1 = QuickWallet.create(2, account: 1);
  final wallet2 = QuickWallet.create(1, account: 1);
  final commit = XChainCommit(
      xchainBridge: XChainBridge(
          issuingChainDoor: "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
          issuingChainIssue: XRP(),
          lockingChainDoor: wallet1.address,
          lockingChainIssue: XRP()),
      account: wallet2.address,
      signer: XRPLSignature.signer(wallet2.pubHex),
      amount: XRPHelper.xrpDecimalToDrop("1"),
      memos: [exampleMemo],
      xchainClaimId: 1);

  await XRPHelper.autoFill(wallet1.rpc, commit);
  final blob = commit.toBlob();
  print("sign transction");
  final sig = wallet2.privateKey.sign(blob);
  print("Set transaction signature");
  commit.setSignature(sig);

  final trhash = commit.getHash();
  print("transaction hash: $trhash");

  final trBlob = commit.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result =
      await wallet1.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/6791DF14FF598948AB2FC2C1D76EECFB7A047727410685301587500F1AC11A2C
}
