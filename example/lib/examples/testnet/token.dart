// XRPL testnet: issue and transfer a fungible token (trust line + mint + transfer back).

import 'package:example/examples/local/xrpl_node.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

/// The token this example issues.
const String currencyCode = 'TST';

/// The trust line limit the holder sets. It is deliberately large so that
/// re-running the example cannot hit the ceiling.
const String trustLimit = '1000000';

/// Amount the issuer sends the holder on the first run.
const String issueAmount = '500';

/// Amount the holder sends back to the issuer.
const String returnAmount = '50';

Future<void> main() async {
  final net = await XrplTestnet.connect();

  final issuer = LocalWallet(index: 10, algorithm: XRPKeyAlgorithm.ed25519);
  final holder = LocalWallet(index: 11, algorithm: XRPKeyAlgorithm.secp256k1);

  print('XRPL testnet: issuing a token');
  print(field('issuer', issuer.address));
  print(field('  key', issuer.algorithm.name));
  print(field('holder', holder.address));
  print(field('  key', holder.algorithm.name));
  print(field('currency', currencyCode));
  print('');

  await fund(net, issuer);
  await fund(net, holder);
  print(field('issuer funded',
      '${formatDrops(await net.balanceOf(issuer.address))} XRP'));
  print(field('holder funded',
      '${formatDrops(await net.balanceOf(holder.address))} XRP'));
  print('');

  /// ---- 1. trust line ----------------------------------------------------
  /// A trust line is one-sided: only the holder needs to create it.
  final trust = TrustSet(
    account: holder.address,
    limitAmount: IssuedCurrencyAmount(
      currency: currencyCode,
      issuer: issuer.address,
      value: trustLimit,
    ),
    signer: XRPLSignature.signer(holder.pubHex),
  );
  final trustResult = await submit(net, trust, holder);
  final trustHash = trust.getHash();
  print(field('trustset', trustResult.engineResult));
  print(field('tx', trustHash));

  final trustValidated = await waitForValidation(net, trustHash);
  print(field(
      'validated',
      '${trustValidated.validated} '
          '${resultOf(trustValidated)}'));
  print('');

  /// ---- 2. issue ---------------------------------------------------------
  /// The accounts are deterministic, so a previous run may already hold some of
  /// the token. Top up to `issueAmount + returnAmount` so there is always enough
  /// to send back, then send back whatever is above `issueAmount`. The holder
  /// therefore ends every run with exactly `issueAmount`.
  final held = BigInt.parse(await tokenBalance(net, holder, currencyCode));
  final target = BigInt.parse(issueAmount) + BigInt.parse(returnAmount);
  final toIssue = target - held;
  if (toIssue > BigInt.zero) {
    final issue = Payment(
      account: issuer.address,
      destination: holder.address,
      amount: IssuedCurrencyAmount(
        currency: currencyCode,
        issuer: issuer.address,
        value: toIssue.toString(),
      ),
      signer: XRPLSignature.signer(issuer.pubHex),
    );
    final issueResult = await submit(net, issue, issuer);
    final issueHash = issue.getHash();
    print(field('issue', issueResult.engineResult));
    print(field('tx', issueHash));
    await waitForValidation(net, issueHash);
  }
  print(field('holder balance',
      '${await tokenBalance(net, holder, currencyCode)} TST'));
  print('');

  /// ---- 3. send back -----------------------------------------------------
  final sendBack = BigInt.parse(await tokenBalance(net, holder, currencyCode)) -
      BigInt.parse(issueAmount);
  if (sendBack <= BigInt.zero) {
    throw StateError('holder has nothing to send back');
  }
  final back = Payment(
    account: holder.address,
    destination: issuer.address,
    amount: IssuedCurrencyAmount(
      currency: currencyCode,
      issuer: issuer.address,
      value: sendBack.toString(),
    ),
    signer: XRPLSignature.signer(holder.pubHex),
  );
  final backResult = await submit(net, back, holder);
  final backHash = back.getHash();
  await waitForValidation(net, backHash);
  print(field('transfer back', backResult.engineResult));
  print(field('  amount', '$sendBack TST'));
  print(field('tx', backHash));

  print(field('holder balance',
      '${await tokenBalance(net, holder, currencyCode)} TST'));
  print(field('issuer balance',
      '${await tokenBalance(net, issuer, currencyCode)} TST'));
  print('');
  print('trust lines of the holder:');
  for (final line in await trustLines(net, holder.address)) {
    print(field(
      line.currency,
      '${line.balance} (limit ${line.limit}, peer ${line.account})',
    ));
  }

  await net.close();
  print('');
  print('done.');
}

/// Token balance of [wallet] for [currency], in whole units.
Future<String> tokenBalance(
  XrplTestnet net,
  LocalWallet wallet,
  String currency,
) async {
  for (final line in await trustLines(net, wallet.address)) {
    if (line.currency != currency) continue;
    return line.balance;
  }
  return '0';
}

/// Trust lines of [address].
Future<List<AccountLinesTrustline>> trustLines(
  XrplTestnet net,
  String address,
) async {
  final result = await net.provider.request(
    XRPRequestAccountLines(account: address),
  );
  return result.lines;
}
