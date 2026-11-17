// XRPL testnet: escrow with a PREIMAGE-SHA-256 condition (lock + reveal).

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:example/examples/local/xrpl_node.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

Future<void> main() async {
  final net = await XrplTestnet.connect();

  final sender = LocalWallet(index: 20, algorithm: XRPKeyAlgorithm.ed25519);
  final receiver = LocalWallet(index: 21, algorithm: XRPKeyAlgorithm.secp256k1);

  print('XRPL testnet: conditional escrow');
  print(field('sender', sender.address));
  print(field('  key', sender.algorithm.name));
  print(field('receiver', receiver.address));
  print(field('  key', receiver.algorithm.name));
  print('');

  await fund(net, sender);
  await fund(net, receiver);
  print(field('sender funded',
      '${formatDrops(await net.balanceOf(sender.address))} XRP'));
  print(field('receiver funded',
      '${formatDrops(await net.balanceOf(receiver.address))} XRP'));
  print('');

  /// ---- 1. create --------------------------------------------------------
  /// A 16-byte secret; the condition is its SHA-256, the fulfillment is the
  /// DER-wrapped preimage that the receiver will publish to claim.
  final secret = QuickCrypto.generateRandom(length: 16);
  final preimage = FulfillmentPreimageSha256.generate(secret);
  print(field('secret', BytesUtils.toHexString(secret)));
  print(field('condition', preimage.condition));
  print(field('fulfillment', preimage.fulfillment));
  print('');

  final amount = XRPHelper.xrpToDrop('2');
  final create = EscrowCreate(
    account: sender.address,
    destination: receiver.address,
    amount: XRPAmount(amount),
    condition: preimage.condition,
    cancelAfterTime: DateTime.now().add(const Duration(days: 1)),
    signer: XRPLSignature.signer(sender.pubHex),
  );
  final createResult = await submit(net, create, sender);
  final createHash = create.getHash();
  print(field('create', createResult.engineResult));
  print(field('tx', createHash));

  final created = await waitForValidation(net, createHash);
  print(field('validated', '${created.validated} ${resultOf(created)}'));
  print(field('offer sequence', '${create.sequence}'));
  print(field('sender after',
      '${formatDrops(await net.balanceOf(sender.address))} XRP'));
  print('');

  /// The escrow object is owned by the sender; find it in the account objects.
  final escrow = await findEscrow(net, sender.address);
  print(field('escrow id', escrow ?? 'not found'));
  print('');

  /// ---- 2. finish --------------------------------------------------------
  /// The receiver publishes the preimage, which both proves the secret and
  /// releases the funds.
  final finish = EscrowFinish(
    account: receiver.address,
    owner: sender.address,
    offerSequence: create.sequence!,
    condition: preimage.condition,
    fulfillment: preimage.fulfillment,
    signer: XRPLSignature.signer(receiver.pubHex),
  );
  final finishResult = await submit(net, finish, receiver);
  final finishHash = finish.getHash();
  print(field('finish', finishResult.engineResult));
  print(field('tx', finishHash));

  final finished = await waitForValidation(net, finishHash);
  print(field('validated', '${finished.validated} ${resultOf(finished)}'));
  print(field('receiver after',
      '${formatDrops(await net.balanceOf(receiver.address))} XRP'));
  print(field('sender after',
      '${formatDrops(await net.balanceOf(sender.address))} XRP'));
  print(field('explorer', explorerUrl(finishHash)));

  await net.close();
  print('');
  print('done.');
}

/// The ledger entry id of the sender's escrow, or null when there is none.
Future<String?> findEscrow(XrplTestnet net, String account) async {
  final result = await net.provider.request(
    XRPRequestAccountObjectType(
      account: account,
      type: AccountObjectType.escrow,
    ),
  );
  for (final entry in result.accountObjects) {
    final json = entry.toJson();
    final index = json['index'];
    if (index is String) return index;
  }
  return null;
}
