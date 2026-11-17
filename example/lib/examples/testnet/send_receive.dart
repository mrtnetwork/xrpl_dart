// XRPL testnet: send XRP (ED25519 sender) and sweep it back (SECP256K1 receiver).

import 'dart:convert';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:example/examples/local/xrpl_node.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

Future<void> main() async {
  final net = await XrplTestnet.connect();

  final sender = LocalWallet(index: 0, algorithm: XRPKeyAlgorithm.ed25519);
  final receiver = LocalWallet(index: 1, algorithm: XRPKeyAlgorithm.secp256k1);

  print('XRPL testnet: send and receive');
  print(field('rpc', XRPProviderConst.testnetUri));
  print(field('sender', sender.address));
  print(field('  key', sender.algorithm.name));
  print(field('receiver', receiver.address));
  print(field('  key', receiver.algorithm.name));
  print('');

  /// ---- receive ----------------------------------------------------------
  /// Nothing is signed on the receiving side; the address is all that is needed.
  print('receiving is passive: share the address, then wait for the funds.');
  print(field('balance before',
      '${formatDrops(await net.balanceOf(receiver.address))} XRP'));
  print('');

  /// ---- fund and send ----------------------------------------------------
  await fund(net, sender);
  final senderBalance = await net.balanceOf(sender.address);
  print(field('sender funded', '${formatDrops(senderBalance)} XRP'));

  final amount = XRPHelper.xrpToDrop('1.5');
  final payment = Payment(
    account: sender.address,
    destination: receiver.address,
    amount: XRPAmount(amount),
    signer: XRPLSignature.signer(sender.pubHex),
    memos: [memo('xrpl-dart example')],
  );

  final result = await submit(net, payment, sender);
  final hash = payment.getHash();
  print(field('submit', result.engineResult));
  print(field('tx', hash));

  final validated = await waitForValidation(net, hash);
  print(field('validated', '${validated.validated} ${resultOf(validated)}'));
  print(field('ledger', '${validated.ledgerIndex}'));
  print(field('explorer', explorerUrl(hash)));
  print('');

  final received = await net.balanceOf(receiver.address);
  print(field('received', '${formatDrops(received)} XRP'));
  print(field('sweep amount',
      '${formatDrops(received - XRPHelper.xrpToDrop('2'))} XRP'));
  print('');

  /// ---- spend what was received -----------------------------------------
  /// The receiver sends most of its balance back. An account must always keep
  /// at least the base reserve (1 XRP on testnet), so the sweep leaves 2 XRP
  /// behind rather than emptying the account.
  final reserve = XRPHelper.xrpToDrop('2');
  final sweepAmount = received - reserve;
  final sweep = Payment(
    account: receiver.address,
    destination: sender.address,
    amount: XRPAmount(sweepAmount),
    signer: XRPLSignature.signer(receiver.pubHex),
  );
  final sweepResult = await submit(net, sweep, receiver);
  final sweepHash = sweep.getHash();
  print(field('sweep', sweepResult.engineResult));
  print(field('tx', sweepHash));

  final sweepValidated = await waitForValidation(net, sweepHash);
  print(field(
      'validated',
      '${sweepValidated.validated} '
          '${resultOf(sweepValidated)}'));
  print(field('receiver after',
      '${formatDrops(await net.balanceOf(receiver.address))} XRP'));
  print(field('explorer', explorerUrl(sweepHash)));

  await net.close();
  print('');
  print('done.');
}

/// A memo carrying [text] as UTF-8.
XRPLMemo memo(String text) {
  final data = BytesUtils.toHexString(utf8.encode(text));
  return XRPLMemo(
    memoData: data,
    memoType: BytesUtils.toHexString(utf8.encode('text/plain')),
    memoFormat: BytesUtils.toHexString(utf8.encode('text/plain')),
  );
}
