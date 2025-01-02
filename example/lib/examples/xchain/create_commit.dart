// ignore_for_file: avoid_print
import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

const String masterAccount = "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh";
void xChainAccountCreateCommit() async {
  final doorWallet = QuickWallet.create(201);
  final desctinationWallet = QuickWallet.create(200);
  final masterWallet = QuickWallet.create(203);
  // await desctinationWallet.fucent();
  // await doorWallet.fucent();
  // await masterWallet.fucent();
  final bridge = XChainBridge(
      lockingChainDoor: doorWallet.address,
      issuingChainDoor: masterAccount,
      issuingChainIssue: XRP(),
      lockingChainIssue: XRP());
  final transaction = XChainAccountCreateCommit(
      account: masterWallet.address,
      signer: XRPLSignature.signer(masterWallet.pubHex),
      xchainBridge: bridge,
      destination: desctinationWallet.address,
      amount: XRPHelper.xrpDecimalToDrop("10"),
      signatureReward: BigInt.from(200));
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

  /// https://devnet.xrpl.org/transactions/004FA871D054D159F5E77A0B1D62395EFF99D6FCE0FCA8859DE0EEC0A3830212
}
