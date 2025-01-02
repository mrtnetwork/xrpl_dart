// ignore_for_file: avoid_print

import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

const String masterAccount = "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh";
void xChainAddAccountCreateAttestation() async {
  final doorWallet = QuickWallet.create(201);
  final witnessWallet = QuickWallet.create(202);
  // await desctinationWallet.fucent();
  // await doorWallet.fucent();
  // await witnessWallet.fucent();
  // await masterWallet.fucent();
  final bridge = XChainBridge(
      lockingChainDoor: doorWallet.address,
      issuingChainDoor: masterAccount,
      issuingChainIssue: XRP(),
      lockingChainIssue: XRP());
  await createBridge(doorWallet, bridge);
  await wintessSignerList(doorWallet, witnessWallet);
  await addAccountCreateAttestation();
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

  /// https://devnet.xrpl.org/transactions/EC811E9BEC91F75068487B0CC21A21B2386B5B2DCA4F2ECB0D4718B27260E028
}

Future<void> createClaimId(QuickWallet account, XChainBridge bridge) async {
  final otherChainSourceWallet = QuickWallet.create(105);
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

  /// https://devnet.xrpl.org/transactions/62DB2EA36862A1CC30F21B89106C24ECF50E3676C94363F062F7D053475835D0
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

  /// https://devnet.xrpl.org/transactions/104117575746D172A7094DCFCF5EF460BEEAF48CBB6BA7D870225EAD9986AE41
}

Future<void> addAccountCreateAttestation() async {
  final desctinationWallet = QuickWallet.create(200);
  final doorWallet = QuickWallet.create(201);
  final witnessWallet = QuickWallet.create(202);
  final bridge = XChainBridge(
      lockingChainDoor: doorWallet.address,
      issuingChainDoor: masterAccount,
      issuingChainIssue: XRP(),
      lockingChainIssue: XRP());
  final transaction = XChainCreateBridge(
    signer: XRPLSignature.signer(doorWallet.pubHex),
    account: doorWallet.address,
    xchainBridge: bridge,
    signatureReward: BigInt.from(200),
    minAccountCreateAmount: XRPHelper.xrpDecimalToDrop("10"),
  );
  final accountBrdigeInfo = await doorWallet.rpc.request(
      XRPRequestAccountObjectType(
          account: doorWallet.address, type: AccountObjectType.bridge));
  final bridgeCount = int.parse((accountBrdigeInfo["account_objects"][0]
              ["XChainAccountClaimCount"])
          .toString()) +
      1;

  final otherChainSourceWallet = QuickWallet.create(250);
  Map<String, dynamic> attenstationToSign = {
    "XChainBridge": transaction.toXrpl()["XChainBridge"],
    "OtherChainSource": otherChainSourceWallet.address,
    "Amount": XRPHelper.xrpDecimalToDrop("300").toString(),
    "AttestationRewardAccount": witnessWallet.address,
    "WasLockingChainSend": 0,
    "XChainAccountCreateCount": bridgeCount,
    "SignatureReward": BigInt.from(200).toString(),
    "Destination": desctinationWallet.address,
  };
  final encode = XRPHelper.toBlob(attenstationToSign);
  final sign = witnessWallet.privateKey.sign(encode);
  final addClain = XChainAddAccountCreateAttestation(
      account: witnessWallet.address,
      xchainBridge: bridge,
      signatureReward: BigInt.from(200),
      xChainAccountCreateCount: bridgeCount,
      destination: desctinationWallet.address,
      signer: XRPLSignature.signer(witnessWallet.pubHex),
      signature: sign.signature!,
      otherChainSource: otherChainSourceWallet.address,
      publicKey: witnessWallet.pubHex,
      wasLockingChainSend: false,
      attestationRewardAccount: witnessWallet.address,
      attestationSignerAccount: witnessWallet.address,
      amount: XRPHelper.xrpDecimalToDrop("300"));
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

  /// https://devnet.xrpl.org/transactions/6A315378F9E062547C4E07DC33209683B8E5976F9A845119D577075A1262A2C9
}
