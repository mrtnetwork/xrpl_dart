// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:xrp_dart/src/crypto/keypair/xrpl_private_key.dart';
import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/xrpl/helper.dart';
import 'package:xrp_dart/src/xrpl/models/account/accountset.dart';
import 'package:xrp_dart/src/xrpl/models/currencies/currencies.dart';
import 'package:xrp_dart/src/xrpl/models/memo.dart';
import 'package:xrp_dart/src/xrpl/models/payment.dart';
import 'package:xrp_dart/src/xrpl/models/signer_list/signer_list.dart';
import 'package:xrp_dart/src/xrpl/models/account/signers.dart';

import '../main.dart';

void multiSigTest() async {
  final masterWallet =
      XRPPrivateKey.fromEntropy("6fb82ba47423cae608bae97db7e1ddd7");
  final signer1 = XRPPrivateKey.fromEntropy("f7f9ff93d716eaced222a3c52a3b2a36");
  final signer2 = XRPPrivateKey.fromEntropy("396c8a5c6e088518b469822923b17039");
  final List<SignerEntry> sigenrs = [
    SignerEntry(
        account: signer1.getPublic().toAddress().address, signerWeight: 1),
    SignerEntry(
        account: signer2.getPublic().toAddress().address, signerWeight: 1)
  ];

  await createOrUpdateMultiSIgAccount(masterWallet, sigenrs);

  await setAccountSetUsingMultiSig(
      masterWallet.getPublic().toAddress().address, [signer1, signer2]);
  await sendXRPLUsingMultiSig(
      signer2.getPublic().toAddress().address,
      masterWallet.getPublic().toAddress().address,
      CurrencyAmount.xrp(BigInt.from(10000000)),
      [signer1, signer2]);
}

Future<void> createOrUpdateMultiSIgAccount(
    XRPPrivateKey owner, List<SignerEntry> signers) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();
  String memoData = bytesToHex(utf8.encode("https://github.com/MohsenHaydari"));
  String memoType = bytesToHex(utf8.encode("Text"));
  String mempFormat = bytesToHex(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  print("owner public: $ownerPublic");
  final transaction = SignerListSet(
      signerEntries: signers,
      account: ownerAddress,
      signerQuorum:
          2, // threshold. Each signer has weight. when you want to send a multi-sig transaction sum of the weight of the signers must reached signerQuorum
      signingPubKey: ownerPublic,
      memos: [memo]);
  print("autofill trnsction");
  await autoFill(rpc, transaction);
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
      domain: bytesToHex(utf8.encode("https://MRTNETWORK.com")));
  await autoFill(rpc, transaction);
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
  await autoFill(rpc, transaction);
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
