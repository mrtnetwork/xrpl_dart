// ignore_for_file: avoid_print

import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void xChainCreateClaimId() async {
  final wallet1 = QuickWallet.create(2, account: 1);
  final wallet2 = QuickWallet.create(3, account: 1);
  final wallet3 = QuickWallet.create(1, account: 1);
  final claimId = XChainCreateClaimId(
    xchainBridge: XChainBridge(
        issuingChainDoor: "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
        issuingChainIssue: XRP(),
        lockingChainDoor: wallet3.address,
        lockingChainIssue: XRP()),
    signatureReward: BigInt.from(2000),
    account: wallet1.address,
    otherChainSource: wallet2.address,
    signer: XRPLSignature.signer(wallet1.pubHex),
    memos: [exampleMemo],
  );

  await XRPHelper.autoFill(wallet1.rpc, claimId);

  final blob = claimId.toBlob();
  print("sign transction");
  final sig = wallet1.privateKey.sign(blob);
  print("Set transaction signature");
  claimId.setSignature(sig);

  final trhash = claimId.getHash();
  print("transaction hash: $trhash");

  final trBlob = claimId.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result =
      await wallet1.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/128EE1E30E22FBF9D5AB3520E3D530CE5E51B84721EA9139D8AA17740D9DEC39
}
