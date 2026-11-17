// XRPL testnet: multi-signature signer lists (set list, co-sign payment, quorum reject).


import 'package:example/examples/local/xrpl_node.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

/// Quorum: the total signer weight required to authorise a transaction.
const int quorum = 2;

Future<void> main() async {
  final net = await XrplTestnet.connect();

  final master = LocalWallet(index: 60, algorithm: XRPKeyAlgorithm.ed25519);
  final signerA = LocalWallet(index: 61, algorithm: XRPKeyAlgorithm.secp256k1);
  final signerB = LocalWallet(index: 62, algorithm: XRPKeyAlgorithm.ed25519);
  final signerC = LocalWallet(index: 63, algorithm: XRPKeyAlgorithm.secp256k1);
  final destination = LocalWallet(index: 64, algorithm: XRPKeyAlgorithm.ed25519);

  print('XRPL testnet: multi-signature');
  print(field('master', master.address));
  print(field('  key', master.algorithm.name));
  print(field('signer A', signerA.address));
  print(field('  key', signerA.algorithm.name));
  print(field('signer B', signerB.address));
  print(field('  key', signerB.algorithm.name));
  print(field('signer C', signerC.address));
  print(field('  key', signerC.algorithm.name));
  print(field('quorum', '$quorum'));
  print('');

  await fund(net, master);
  await fund(net, destination);
  print(field('master funded', '${formatDrops(await net.balanceOf(master.address))} XRP'));
  print('');

  /// ---- 1. configure the signer list ------------------------------------
  final signers = [signerA, signerB, signerC];
  final list = SignerListSet(
    account: master.address,
    signerQuorum: quorum,
    signerEntries: [
      for (final signer in signers)
        SignerEntry(account: signer.address, signerWeight: 1),
    ],
    signer: XRPLSignature.signer(master.pubHex),
  );
  final listResult = await submit(net, list, master);
  final listHash = list.getHash();
  print(field('signer list set', listResult.engineResult));
  print(field('tx', listHash));
  await waitForValidation(net, listHash);

  final configured = await signerList(net, master);
  print(field('signers on ledger', '${configured.length}'));
  for (final entry in configured) {
    print(field('  signer', '${entry.account} (weight ${entry.signerWeight})'));
  }
  print('');

  /// ---- 2. two signers co-sign a payment --------------------------------
  final masterXrpBefore = await net.balanceOf(master.address);

  final payment = Payment(
    account: master.address,
    destination: destination.address,
    amount: XRPAmount(XRPHelper.xrpToDrop('1')),
    multisigSigners: [
      XRPLSigners.singer(account: signerA.address, signingPubKey: signerA.pubHex),
      XRPLSigners.singer(account: signerB.address, signingPubKey: signerB.pubHex),
    ],
  );
  final signed = await multiSign(net, payment, [signerA, signerB]);
  final paymentHash = payment.getHash();
  print(field('two signers', signed.engineResult));
  print(field('tx', paymentHash));
  await waitForValidation(net, paymentHash);
  print(field('destination', formatDrops(await net.balanceOf(destination.address))));
  print(field('master change', formatDrops(
      await net.balanceOf(master.address) - masterXrpBefore)));
  print('');

  /// ---- 3. one signer is not enough -------------------------------------
  /// The same payment with a single signer fails with `tefBAD_QUORUM`.
  final underSigned = Payment(
    account: master.address,
    destination: destination.address,
    amount: XRPAmount(XRPHelper.xrpToDrop('1')),
    multisigSigners: [
      XRPLSigners.singer(account: signerC.address, signingPubKey: signerC.pubHex),
    ],
  );
  final underResult = await multiSign(net, underSigned, [signerC]);
  print(field('one signer', underResult.engineResult));
  print(field('expected', 'tefBAD_QUORUM — the quorum is not met'));

  await net.close();
  print('');
  print('done.');
}

/// Signs [transaction] with every key in [signers] and submits it.
///
/// Each signer signs the same digest for its own account; the library sorts the
/// `Signers` array by account, as the ledger requires.
Future<SubmitResult> multiSign(
  XrplTestnet net,
  Payment transaction,
  List<LocalWallet> signers,
) async {
  await XRPHelper.autoFill(net.provider, transaction);
  final signatures = <XRPLSigners>[];
  for (final signer in signers) {
    final blob = transaction.toSigningBlobBytes(signer.src);
    final signature = signer.privateKey.sign(blob);
    blob.forceZero();
    signatures.add(
      XRPLSigners(
        account: signer.address,
        signingPubKey: signer.pubHex,
        txnSignature: signature.signature,
      ),
    );
  }
  transaction.setMultiSigSignature(signatures);
  return net.provider.request(
    XRPRequestSubmit(txBlob: transaction.toTransactionBlob()),
  );
}

/// The master account's signer list, or an empty list when none is set.
Future<List<LedgerSignerEntry>> signerList(
  XrplTestnet net,
  LocalWallet wallet,
) async {
  final result = await net.provider.request(
    XRPRequestAccountObjectType(
      account: wallet.address,
      type: AccountObjectType.signerList,
    ),
  );
  for (final entry in result.accountObjects) {
    if (entry is LedgerEntrySignerList) return entry.signerEntries;
  }
  return const [];
}