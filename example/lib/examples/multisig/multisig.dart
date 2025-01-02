// ignore_for_file: avoid_print

import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void exampleMultisig() async {
  final masterWallet = QuickWallet.create(0, account: 20);

  /// define 5 signers
  /// 1 weight
  final signer1Wallet =
      QuickWallet.create(1, algorithm: XRPKeyAlgorithm.ed25519, account: 20);

  /// 1 weight
  final signer2Wallet =
      QuickWallet.create(2, algorithm: XRPKeyAlgorithm.ed25519, account: 20);

  /// 1 weight
  final signer3Wallet =
      QuickWallet.create(3, algorithm: XRPKeyAlgorithm.secp256k1, account: 20);

  /// 2 weight
  final signer4Wallet =
      QuickWallet.create(4, algorithm: XRPKeyAlgorithm.secp256k1, account: 20);

  /// 3 weight
  final signer5Wallet =
      QuickWallet.create(5, algorithm: XRPKeyAlgorithm.secp256k1, account: 20);
  const int signerQuorum = 3;

  final List<SignerEntry> signers = [
    SignerEntry(account: signer1Wallet.address, signerWeight: 1),
    SignerEntry(account: signer2Wallet.address, signerWeight: 1),
    SignerEntry(account: signer3Wallet.address, signerWeight: 1),
    SignerEntry(account: signer4Wallet.address, signerWeight: 2),
    SignerEntry(account: signer5Wallet.address, signerWeight: 3),
  ];
  final destination = QuickWallet.create(6, account: 20);

  await createOrUpdateMultiSIgAccount(masterWallet, signers, signerQuorum);
  await disableMaster(masterWallet);

  /// sign with 3 account sum of weight == signerQuorum
  /// https://devnet.xrpl.org/transactions/971740EEC2BE3C3608158EBCB18B5F5AC76B4DAA6E54EA88E9CB4C71FE1BD102/detailed
  await sendXRPLUsingMultiSig(
      masterWallet,
      destination.address,

      /// sum of weight must be equal to signerQuorum
      [signer1Wallet, signer2Wallet, signer3Wallet],
      signerQuorum);

  /// sign with 2 account sum of weight == signerQuorum
  /// https://devnet.xrpl.org/transactions/50589F7E73705DEEFC2E5B5FCD0150DA7F141A7F98F06DF14607FB696EDE2C24/detailed
  await sendXRPLUsingMultiSig(
      masterWallet,
      destination.address,

      /// sum of weight must be equal to signerQuorum
      [signer1Wallet, signer4Wallet],
      signerQuorum);

  /// sign with 1 account sum of weight == signerQuorum
  /// https://devnet.xrpl.org/transactions/FA86B2707577D2A9B31431DC404703EDBD4BB91BDB2F00B31848101C3289FE67/detailed
  await sendXRPLUsingMultiSig(
      masterWallet,
      destination.address,

      /// sum of weight must be equal to signerQuorum
      [signer5Wallet],
      signerQuorum);

  /// enable master again
  await enableMaster(
      masterWallet, [signer1Wallet, signer2Wallet, signer3Wallet]);

  /// remove or update signers
  /// https://devnet.xrpl.org/transactions/B25802C7FEFC41A0A99267E4F9F117F117F25A180F8BF232B6AE24AAAB6AF5DB/detailed
  await createOrUpdateMultiSIgAccount(masterWallet, null, 0);
}

Future<void> createOrUpdateMultiSIgAccount(
    QuickWallet masterWallet, List<SignerEntry>? signers, int threshold) async {
  final transaction = SignerListSet(
      signerEntries: signers,
      account: masterWallet.address,
      signerQuorum: threshold,
      signer: XRPLSignature.signer(masterWallet.pubHex),
      memos: [exampleMemo]);
  print("autofill trnsction");
  await XRPHelper.autoFill(masterWallet.rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = masterWallet.privateKey.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);
  final trhash = transaction.getHash();
  print("transaction hash: $trhash");
  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result =
      await masterWallet.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/A9AAE0595140757F0EE85188AC5D7826F19286352867F0BC924D7A6837A2A5CB
}

Future<void> disableMaster(QuickWallet masterWallet) async {
  final transaction = AccountSet(
      account: masterWallet.address,
      signer: XRPLSignature.signer(masterWallet.pubHex),
      setFlag: AccountSetAsfFlag.asfDisableMaster,
      memos: [exampleMemo]);
  await XRPHelper.autoFill(masterWallet.rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = masterWallet.privateKey.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);
  final trhash = transaction.getHash();
  print("transaction hash: $trhash");

  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob");

  final result =
      await masterWallet.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/7C952FC73A986EA7A0F68BB50FFED5615E1F1F527BD2A16D9C88A9CDB5F9D2EB
}

Future<void> sendXRPLUsingMultiSig(QuickWallet masaterWallet,
    String destination, List<QuickWallet> signersList, int signerQuorum) async {
  final transaction = Payment(
    destination: destination,
    multisigSigners: signersList
        .map((e) =>
            XRPLSigners.singer(account: e.address, signingPubKey: e.pubHex))
        .toList(),
    account: masaterWallet.address,
    memos: [exampleMemo],
    amount: CurrencyAmount.xrp(XRPHelper.xrpDecimalToDrop("50")),
  ); // do not set signingPubKey for multisig transaction
  await XRPHelper.autoFill(masaterWallet.rpc, transaction);
  final List<XRPLSigners> signerSignatures = [];
  for (final i in signersList) {
    final blob = transaction.toMultisigBlob(i.address);
    final sig = i.privateKey.sign(blob);
    signerSignatures.add(XRPLSigners(
        account: i.address,
        signingPubKey: i.pubHex,
        txnSignature: sig.signature));
  }
  transaction.setMultiSigSignature(signerSignatures);

  final trhash = transaction.getHash();
  print("transaction hash: $trhash");
  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result =
      await masaterWallet.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> enableMaster(
    QuickWallet masterWallet, List<QuickWallet> signersList) async {
  final transaction = AccountSet(
      account: masterWallet.address,
      clearFlag: AccountSetAsfFlag.asfDisableMaster,
      multisigSigners: signersList
          .map((e) =>
              XRPLSigners.singer(account: e.address, signingPubKey: e.pubHex))
          .toList(),
      memos: [exampleMemo]);
  print("autofill trnsction");
  await XRPHelper.autoFill(masterWallet.rpc, transaction);
  final List<XRPLSigners> signerSignatures = [];
  for (final i in signersList) {
    final blob = transaction.toMultisigBlob(i.address);
    final sig = i.privateKey.sign(blob);
    signerSignatures.add(XRPLSigners(
        account: i.address,
        signingPubKey: i.pubHex,
        txnSignature: sig.signature));
  }
  transaction.setMultiSigSignature(signerSignatures);

  final trhash = transaction.getHash();
  print("transaction hash: $trhash");
  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result =
      await masterWallet.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/17399A1E7A3669CA68AC3F449CA113D95F819918A25D69580F5B47B60FADBB84
}
