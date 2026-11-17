// XRPL testnet: checks (write + cash) and payment channels (open + fund + claim).

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:example/examples/local/xrpl_node.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

/// The check amount, in XRP.
const String checkAmount = '3';

/// The channel's initial amount, in XRP.
const String channelAmount = '5';

/// The top-up added to the channel, in XRP.
const String channelTopUp = '2';

/// The amount the destination claims, in XRP.
const String claimed = '1';

Future<void> main() async {
  final net = await XrplTestnet.connect();

  final sender = LocalWallet(index: 90, algorithm: XRPKeyAlgorithm.ed25519);
  final destination =
      LocalWallet(index: 91, algorithm: XRPKeyAlgorithm.secp256k1);

  /// The key that authorises claims against the channel. It does not need to
  /// belong to either party.
  final channelKey =
      LocalWallet(index: 92, algorithm: XRPKeyAlgorithm.secp256k1);

  print('XRPL testnet: checks and payment channels');
  print(field('sender', sender.address));
  print(field('  key', sender.algorithm.name));
  print(field('destination', destination.address));
  print(field('  key', destination.algorithm.name));
  print(field('channel key', channelKey.address));
  print('');

  await fund(net, sender);
  await fund(net, destination);
  print(field('sender funded',
      '${formatDrops(await net.balanceOf(sender.address))} XRP'));
  print('');

  /// ---- 1. check ---------------------------------------------------------
  await checkFlow(net, sender, destination);
  print('');

  /// ---- 2. payment channel ----------------------------------------------
  await channelFlow(net, sender, destination, channelKey);

  await net.close();
  print('');
  print('done.');
}

/// Writes a check and cashes it.
Future<void> checkFlow(
  XrplTestnet net,
  LocalWallet sender,
  LocalWallet destination,
) async {
  final before = await net.balanceOf(destination.address);

  final check = CheckCreate(
    account: sender.address,
    destination: destination.address,
    sendMax: XRPAmount(XRPHelper.xrpToDrop(checkAmount)),
    expirationTime: DateTime.now().add(const Duration(days: 1)),
    signer: XRPLSignature.signer(sender.pubHex),
  );
  final createResult = await submit(net, check, sender);
  await waitForValidation(net, check.getHash());
  print(field('check create', createResult.engineResult));
  print(field('tx', check.getHash()));

  /// The check id is the ledger entry created by the transaction.
  final checkId = await createdEntryId(net, check.getHash(), 'Check');
  print(field('check id', checkId));

  /// The sender's pending checks are readable through `account_objects`; this
  /// also exercises the Check decoder.
  final pending = await net.provider.request(
    XRPRequestAccountObjectType(
      account: sender.address,
      type: AccountObjectType.check,
    ),
  );
  print(field('pending checks', '${pending.accountObjects.length}'));
  for (final entry in pending.accountObjects) {
    final json = entry.toJson();
    print(field('  send max', '${json['SendMax']} drops'));
    print(field('  to', '${json['Destination']}'));
  }

  /// Only the destination can cash a check.
  final cash = CheckCash(
    account: destination.address,
    checkId: checkId,
    amount: XRPAmount(XRPHelper.xrpToDrop(checkAmount)),
    signer: XRPLSignature.signer(destination.pubHex),
  );
  final cashResult = await submit(net, cash, destination);
  await waitForValidation(net, cash.getHash());
  print(field('check cash', cashResult.engineResult));
  print(field('tx', cash.getHash()));

  final delta = await net.balanceOf(destination.address) - before;
  print(field('destination delta', formatDrops(delta)));
  print(field(
      'pending checks after', '${(await pendingChecks(net, sender)).length}'));
}

/// Opens a channel, tops it up, and claims part of it.
Future<void> channelFlow(
  XrplTestnet net,
  LocalWallet sender,
  LocalWallet destination,
  LocalWallet channelKey,
) async {
  final before = await net.balanceOf(destination.address);

  final create = PaymentChannelCreate(
    account: sender.address,
    destination: destination.address,
    amount: XRPAmount(XRPHelper.xrpToDrop(channelAmount)),

    /// One day: the sender must wait this long before it may close the channel
    /// without the destination's help.
    settleDelay: 60 * 60 * 24,
    publicKey: channelKey.pubHex,
    signer: XRPLSignature.signer(sender.pubHex),
  );
  final createResult = await submit(net, create, sender);
  await waitForValidation(net, create.getHash());
  print(field('channel create', createResult.engineResult));
  print(field('tx', create.getHash()));

  /// The sender is a fixed address, so earlier runs may have left channels
  /// behind. Read the id from this transaction's metadata rather than taking the
  /// first entry of the list.
  final channelId = await createdEntryId(
    net,
    create.getHash(),
    'PayChannel',
  );
  print(field('channel id', channelId));
  print(field('amount', '${XRPHelper.xrpToDrop(channelAmount)} drops'));

  /// Top up.
  final fund = PaymentChannelFund(
    account: sender.address,
    channel: channelId,
    amount: XRPHelper.xrpToDrop(channelTopUp),
    signer: XRPLSignature.signer(sender.pubHex),
  );
  final fundResult = await submit(net, fund, sender);
  await waitForValidation(net, fund.getHash());
  print(field('channel fund', fundResult.engineResult));

  /// The destination claims 1 XRP, proving it with the channel key's signature.
  final claimAmount = XRPHelper.xrpToDrop(claimed);
  final claim = PaymentChannelClaim(
    account: destination.address,
    channel: channelId,

    /// `Amount` is the cumulative total being claimed, and `Balance` is the
    /// channel balance after the claim. The signed amount is the cumulative
    /// total, so both must be the same value for a first claim.
    amount: claimAmount,
    balance: claimAmount,
    publicKey: channelKey.pubHex,
    signer: XRPLSignature.signer(destination.pubHex),
  );

  /// The claim signature covers the channel and the cumulative amount, and is
  /// made with the channel key rather than the account key. It has to be added
  /// before the transaction itself is signed, so this one is filled and signed
  /// explicitly instead of going through [submit].
  final signature = channelKey.privateKey
      .sign(BytesUtils.fromHexString(claim.signForClaim()))
      .signature;
  claim.signature = signature;
  await signInPlace(net, claim, destination);
  final claimResult = await submitSigned(net, claim);
  await waitForValidation(net, claim.getHash());
  print(field('channel claim', claimResult.engineResult));
  print(field('tx', claim.getHash()));

  final after = await net.provider.request(
    XRPRequestAccountChannel(
      account: sender.address,
      destinationAccount: destination.address,
    ),
  );
  for (final c in after.channels) {
    if (c.channelId == channelId) {
      print(field('channel balance', '${c.balance} drops'));
      print(field('channel amount', '${c.amount} drops'));
    }
  }

  final delta = await net.balanceOf(destination.address) - before;
  print(field('destination delta', formatDrops(delta)));
}

/// The check objects owned by [wallet].
Future<List<dynamic>> pendingChecks(XrplTestnet net, LocalWallet wallet) async {
  final result = await net.provider.request(
    XRPRequestAccountObjectType(
      account: wallet.address,
      type: AccountObjectType.check,
    ),
  );
  return result.accountObjects;
}

/// The ledger entry id of the entry of [entryType] created by [hash].
Future<String> createdEntryId(
  XrplTestnet net,
  String hash,
  String entryType,
) async {
  final tx = await net.provider.request(XRPRequestTx(transaction: hash));
  final meta = tx.meta;
  if (meta != null) {
    for (final node in meta.affectedNodes) {
      if (node is! CreatedNode) continue;
      if (node.ledgerEntryType == entryType) return node.ledgerIndex;
    }
  }
  throw StateError('no $entryType created by $hash');
}
