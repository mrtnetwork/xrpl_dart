// ignore_for_file: avoid_print
import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

const String masterAccount = "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh";
void xChainAddClaimAttestation() async {
  final desctinationWallet = QuickWallet.create(100, account: 100);
  final doorWallet = QuickWallet.create(101, account: 100);
  final witnessWallet = QuickWallet.create(102, account: 100);

  final bridge = XChainBridge(
      lockingChainDoor: doorWallet.address,
      issuingChainDoor: masterAccount,
      issuingChainIssue: XRP(),
      lockingChainIssue: XRP());

  await createBridge(doorWallet, bridge);
  await createClaimId(desctinationWallet, bridge);
  await wintessSignerList(doorWallet, witnessWallet);
  await addClaimAttestation();
}

Future<void> createBridge(QuickWallet account, XChainBridge bridge) async {
  final transaction = XChainCreateBridge(
    signer: XRPLSignature.signer(account.pubHex),
    memos: [exampleMemo],
    account: account.address,
    xchainBridge: bridge,
    signatureReward: BigInt.from(200),
    minAccountCreateAmount: XRPHelper.xrpDecimalToDrop("10"),
  );
  await XRPHelper.autoFill(account.rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = account.privateKey.sign(blob);
  transaction.setSignature(sig);
  final trBlob = transaction.toBlob(forSigning: false);
  final result =
      await account.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("is success: ${result.isSuccess}");
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");

  /// https://devnet.xrpl.org/transactions/4236252485CBA6A28A5C4ECF0CA50DAACA526EC068D49EEA796643B286F1C627
}

Future<void> createClaimId(QuickWallet account, XChainBridge bridge) async {
  final otherChainSourceWallet = QuickWallet.create(105, account: 100);

  final transaction = XChainCreateClaimId(
      signer: XRPLSignature.signer(account.pubHex),
      memos: [exampleMemo],
      account: account.address,
      xchainBridge: bridge,
      signatureReward: BigInt.from(200),
      otherChainSource: otherChainSourceWallet.address);
  await XRPHelper.autoFill(account.rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = account.privateKey.sign(blob);
  transaction.setSignature(sig);
  final trBlob = transaction.toBlob(forSigning: false);
  final result =
      await account.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("is success: ${result.isSuccess}");
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");

  /// https://devnet.xrpl.org/transactions/338643778539E1C78E90417AEEDA64823252A4311DC3BFB566D4D1DEEB840F2C
}

Future<void> wintessSignerList(
    QuickWallet account, QuickWallet witnessWallet) async {
  final transaction = SignerListSet(
      signer: XRPLSignature.signer(account.pubHex),
      memos: [exampleMemo],
      account: account.address,
      signerEntries: [
        SignerEntry(account: witnessWallet.address, signerWeight: 1)
      ],
      signerQuorum: 1);
  await XRPHelper.autoFill(account.rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = account.privateKey.sign(blob);
  transaction.setSignature(sig);
  final trBlob = transaction.toBlob(forSigning: false);
  final result =
      await account.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("is success: ${result.isSuccess}");
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");

  /// https://devnet.xrpl.org/transactions/8BAA71EB763217839E080978C2DB48C058FD5147D09F4780E9FCD0D3F077AA2B
}

Future<void> addClaimAttestation() async {
  final desctinationWallet = QuickWallet.create(100, account: 100);
  final doorWallet = QuickWallet.create(101, account: 100);
  final witnessWallet = QuickWallet.create(102, account: 100);
  final bridge = XChainBridge(
      lockingChainDoor: doorWallet.address,
      issuingChainDoor: masterAccount,
      issuingChainIssue: XRP(),
      lockingChainIssue: XRP());
  final transaction = XChainCreateBridge(
    signer: XRPLSignature.signer(doorWallet.pubHex),
    account: doorWallet.address,
    xchainBridge: bridge,
    memos: [exampleMemo],
    signatureReward: BigInt.from(200),
    minAccountCreateAmount: XRPHelper.xrpDecimalToDrop("10"),
  );
  final otherChainSourceWallet = QuickWallet.create(105, account: 100);
  Map<String, dynamic> attenstationToSign = {
    "XChainBridge": transaction.toXrpl()["XChainBridge"],
    "OtherChainSource": otherChainSourceWallet.address,
    "Amount": XRPHelper.xrpDecimalToDrop("3").toString(),
    "AttestationRewardAccount": witnessWallet.address,
    "WasLockingChainSend": 0,
    "XChainClaimID": 1,
    "Destination": desctinationWallet.address,
  };
  final encode = XRPHelper.toBlob(attenstationToSign);
  final sign = witnessWallet.privateKey.sign(encode);
  final addClain = XChainAddClaimAttestation(
      account: witnessWallet.address,
      xchainBridge: bridge,
      xchainClaimId: 1,
      destination: desctinationWallet.address,
      signer: XRPLSignature.signer(witnessWallet.pubHex),
      signature: sign.signature!,
      otherChainSource: otherChainSourceWallet.address,
      publicKey: witnessWallet.pubHex,
      wasLockingChainSend: false,
      attestationRewardAccount: witnessWallet.address,
      attestationSignerAccount: witnessWallet.address,
      amount: XRPHelper.xrpDecimalToDrop("3"));
  await XRPHelper.autoFill(witnessWallet.rpc, addClain);
  final blob = addClain.toBlob();
  print("sign transction");
  final sig = witnessWallet.privateKey.sign(blob);
  addClain.setSignature(sig);
  final trBlob = addClain.toBlob(forSigning: false);
  final result =
      await witnessWallet.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("is success: ${result.isSuccess}");
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");

  /// https://devnet.xrpl.org/transactions/5BF99AFC2CF1C787A4AF6D6013FB86C30390C34E34FEBF8344DC0B98AC753737
}
