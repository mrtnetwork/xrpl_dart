// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:blockchain_utils/bip/mnemonic/mnemonic.dart';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrp_dart/xrp_dart.dart';
import '../main.dart';

void multiSigTest() async {
  final entropy = Bip39SeedGenerator(Mnemonic.fromString(
          "spawn have inflict celery market settle expand foil scrub august valid cactus"))
      .generate();
  final bip32 = Bip44.fromSeed(entropy, Bip44Coins.ripple)
      .purpose
      .coin
      .account(0)
      .change(Bip44Changes.chainInt);
  final masterWallet =
      XRPPrivateKey.fromBytes(bip32.addressIndex(2).privateKey.raw);

  final signer1 = XRPPrivateKey.fromBytes(bip32.addressIndex(3).privateKey.raw);
  final signer2 = XRPPrivateKey.fromBytes(bip32.addressIndex(4).privateKey.raw);
  final signer3 = XRPPrivateKey.fromBytes(bip32.addressIndex(5).privateKey.raw);
  final destionation =
      XRPPrivateKey.fromBytes(bip32.addressIndex(6).privateKey.raw);
  final List<SignerEntry> sigenrs = [
    SignerEntry(
        account: signer1.getPublic().toAddress().address, signerWeight: 1),
    SignerEntry(
        account: signer2.getPublic().toAddress().address, signerWeight: 1),
    SignerEntry(
        account: signer3.getPublic().toAddress().address, signerWeight: 2)
  ];

  /// first we set 3 signer with 3 thresh hold
  /// thats mean we must sign transaction with siger 1 + signer 2 + signer 3 or (signer3 +(signer1 or signer2))
  await createOrUpdateMultiSIgAccount(masterWallet, sigenrs, 3);

  await setAccountSetUsingMultiSig(
      masterWallet.getPublic().toAddress().address, [signer1, signer3]);

  /// using siger 1 and 3 to sign traansaction
  await sendXRPLUsingMultiSig(
      destionation.getPublic().toAddress().toString(),
      masterWallet.getPublic().toAddress().toString(),
      CurrencyAmount.xrp(XRPHelper.xrpDecimalToDrop("30")),
      [signer1, signer3]);

  /// using siger 1 and 2 to sign traansaction
  /// in this case we got error Signatures provided do not meet the quorum
  await sendXRPLUsingMultiSig(
      destionation.getPublic().toAddress().toString(),
      masterWallet.getPublic().toAddress().toString(),
      CurrencyAmount.xrp(XRPHelper.xrpDecimalToDrop("30")),
      [signer1, signer2]);

  /// with signer 2 and 3
  await sendXRPLUsingMultiSig(
      destionation.getPublic().toAddress().toString(),
      masterWallet.getPublic().toAddress().toString(),
      CurrencyAmount.xrp(XRPHelper.xrpDecimalToDrop("5")),
      [signer2, signer3]);
}

Future<void> createOrUpdateMultiSIgAccount(
    XRPPrivateKey owner, List<SignerEntry> signers, int threshold) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();
  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  print("owner public: $ownerPublic");
  final transaction = SignerListSet(
      signerEntries: signers,
      account: ownerAddress,
      signerQuorum:
          threshold, // threshold. Each signer has weight. when you want to send a multi-sig transaction sum of the weight of the signers must reached signerQuorum
      signingPubKey: ownerPublic,
      memos: [memo]);
  print("autofill trnsction");
  await XRPHelper.autoFill(rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = owner.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);
  final trhash = transaction.getHash();
  print("transaction hash: $trhash");
  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> setAccountSetUsingMultiSig(
    String owner, List<XRPPrivateKey> signersList) async {
  final transaction = AccountSet(
      account: owner,
      signingPubKey: "", // do not set signingPubKey for multisig transaction
      multiSigSigners:
          signersList.map((e) => e.getPublic().toAddress().address).toList(),
      domain: BytesUtils.toHexString(
          utf8.encode("https://https://github.com/mrtnetwork/xrp_dart")));
  await XRPHelper.autoFill(rpc, transaction);
  final List<XRPLSigners> signerSignatures = [];

  /// we know signerQuorum is 2
  /// rpc.getAccountObjects(address,type: AccountObjectType.SIGNER_LIST);
  int signerQuorum = 2;

  int sumOfWeight = 0;
  for (final i in signersList) {
    /// Here we use the toMultisigBlob method to generate the blob, the blob
    /// structure in multi-sig transaction needs different prefixes and suffixes.
    final blob = transaction.toMultisigBlob(i.getPublic().toAddress().address);
    final sig = i.sign(blob);
    signerSignatures.add(XRPLSigners(
        account: i.getPublic().toAddress().address,
        signingPubKey: i.getPublic().toHex(),
        txnSignature: sig));

    ///  we know each signer has 1 weight
    sumOfWeight += 1;

    /// we don't need another signatory, because threshold reached
    if (sumOfWeight >= signerQuorum) break;
  }
  transaction.setMultiSigSignatur(signerSignatures);
  final trhash = transaction.getHash();
  print("transaction hash: $trhash");

  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> sendXRPLUsingMultiSig(String destination, String owner,
    CurrencyAmount amount, List<XRPPrivateKey> signersList) async {
  final transaction = Payment(
      destination: destination,
      multiSigSigners:
          signersList.map((e) => e.getPublic().toAddress().address).toList(),
      account: owner,
      amount: amount,
      signingPubKey: ''); // do not set signingPubKey for multisig transaction
  print("autofill trnsction");
  await XRPHelper.autoFill(rpc, transaction);
  final List<XRPLSigners> signerSignatures = [];

  /// we know signerQuorum is 2
  /// rpc.getAccountObjects(address,type: AccountObjectType.SIGNER_LIST);
  int signerQuorum = 2;

  int sumOfWeight = 0;
  for (final i in signersList) {
    /// Here we use the toMultisigBlob method to generate the blob, the blob
    /// structure in multi-sig transaction needs different prefixes and suffixes.
    final blob = transaction.toMultisigBlob(i.getPublic().toAddress().address);
    final sig = i.sign(blob);
    signerSignatures.add(XRPLSigners(
        account: i.getPublic().toAddress().address,
        signingPubKey: i.getPublic().toHex(),
        txnSignature: sig));

    ///  we know each signer has 1 weight
    sumOfWeight += 1;

    /// we don't need another signatory, because threshold reached
    if (sumOfWeight >= signerQuorum) break;
  }
  transaction.setMultiSigSignatur(signerSignatures);

  final trhash = transaction.getHash();
  print("transaction hash: $trhash");
  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}
