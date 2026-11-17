/// Live test for [XRPQuickClientApi] across testnet, devnet and mainnet.
///
/// Read-only calls only (no submission, no funding). Run from the package
/// root: `dart tool/live_quick_test.dart`
///
/// Override endpoints (e.g. a local rippled or Clio node):
/// ```sh
/// XRP_MAINNET_URL=http://localhost:5005 \
/// XRP_TESTNET_URL=http://localhost:5005 \
/// XRP_DEVNET_URL=http://localhost:5005 \
///   dart tool/live_quick_test.dart
/// ```
///
/// Harness provider uses `dart:io` so no extra dependency is needed.
library;

import 'dart:io';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

final String _mainnetUrl =
    Platform.environment['XRP_MAINNET_URL'] ?? XRPProviderConst.mainetUri;
final String _testnetUrl =
    Platform.environment['XRP_TESTNET_URL'] ?? XRPProviderConst.testnetUri;
final String _devnetUrl =
    Platform.environment['XRP_DEVNET_URL'] ?? XRPProviderConst.devnetUri;

/// Genesis account: exists on every network that shares mainnet history,
/// guaranteed on mainnet. Test/devnets reset periodically, so account
/// assertions there only exercise the nullable (not-found) path.
const String _genesisAccount = 'r9cZA1mLK5R5Am25ArfXFmqgNwjZgnfk59';

class _IoService with XRPServiceProvider {
  _IoService(this.url, {HttpClient? client})
    : client = client ?? HttpClient();
  @override
  final String url;
  final HttpClient client;

  @override
  Future<BaseServiceResponse> doRequest(
    XRPRequestDetails params, {
    Duration? timeout,
  }) async {
    final uri = params.encodeUrl(url);
    final t = timeout ?? const Duration(seconds: 30);
    final HttpClientRequest req = await client.postUrl(uri).timeout(t);
    params.headers.forEach(req.headers.set);
    final body = params.encodeBody();
    if (body != null && body.isNotEmpty) req.add(body);
    final resp = await req.close().timeout(t);
    final bytes = await resp
        .fold<List<int>>(<int>[], (p, e) => p..addAll(e))
        .timeout(t);
    return params.toResponse(bytes, statusCode: resp.statusCode);
  }
}

int _failures = 0;

/// Explicit check: `assert()` is stripped when asserts are disabled
/// (plain `dart tool/...` runs), so live verification must throw.
void _check(bool cond, String message) {
  if (!cond) throw StateError(message);
}

Future<T> _step<T>(String name, Future<T> Function() fn) async {
  try {
    final r = await fn();
    stdout.writeln('PASS $name');
    return r;
  } catch (e) {
    _failures++;
    stdout.writeln('FAIL $name: $e');
    rethrow;
  }
}

Future<void> _checkNetwork(String name, String url) async {
  stdout.writeln('--- $name ($url) ---');
  final client = DefaultXRPQuickClient.fromService(_IoService(url));

  final info = await _step('$name server_info', client.serverInfo);
  _check(
    (info.info.buildVersion ?? '').isNotEmpty,
    '$name: empty build version',
  );
  stdout.writeln('  build_version=${info.info.buildVersion}');

  final fee = await _step('$name fee', client.feeData);
  _check(fee.drops.minimumFee > 0, '$name: bad minimum fee');
  final suggested = await _step('$name suggestedFee', client.suggestedFee);
  _check(suggested > BigInt.zero, '$name: bad suggested fee');

  // Exercises the fixed parser on every network: rippled answers
  // `ledger_current_index`, some proxies/Clio builds answer `ledger_index`.
  final current = await _step('$name ledger_current', client.ledgerCurrent);
  _check(current > 0, '$name: bad ledger index');

  final closed = await _step('$name ledger_closed', client.ledgerClosed);
  _check(closed.ledgerIndex > 0, '$name: bad closed ledger index');

  // Drift detector: the live type table must contain every type the codec
  // knows about. "Contains" (not "equals") so ahead-of-us devnets still pass.
  // The table is large (~100KB); allow a longer timeout.
  final defs = await _step('$name server_definitions', () async {
    final d = await client.provider.request(
      XRPRequestServerDefinitions(),
      timeout: const Duration(seconds: 120),
    );
    _check(d.transactionTypes?['NFTokenModify'] == 61, '$name: no NFTokenModify in live definitions');
    _check(
      (d.ledgerEntryTypes ?? {}).containsKey('Vault'),
      '$name: no Vault ledger entry in live definitions',
    );
    final fields = (d.fields ?? []).map((e) => e.name).toSet();
    for (final field in ['CredentialIDs', 'DomainID', 'NFTokenID']) {
      _check(fields.contains(field), '$name: no $field in live definitions');
    }
    return d;
  });
  stdout.writeln('  definitions_hash=${defs.hash}');

  if (name == 'mainnet') {
    final account = await _step(
      '$name account_info',
      () => client.getAccountInfo(_genesisAccount),
    );
    _check(account != null, '$name: genesis account missing');
    _check(
      (await client.getAccountBalance(_genesisAccount)) > BigInt.zero,
      '$name: genesis balance not positive',
    );
    final seq = await _step(
      '$name account_sequence',
      () => client.getAccountSequence(_genesisAccount),
    );
    _check(seq > 0, '$name: bad account sequence');

    final txes = await _step(
      '$name account_tx',
      () => client.accountTx(account: _genesisAccount, limit: 5),
    );
    _check(txes.transactions.isNotEmpty, '$name: no genesis transactions');
    final first = txes.transactions.first;
    final hash = first.txJson?.hash;
    if (hash == null) throw StateError('$name: first tx has no hash');
    final tx = await _step('$name tx', () => client.transaction(hash));
    _check(tx != null && tx.validated == true, '$name: tx not validated');
    final status = await _step(
      '$name transactionStatus',
      () => client.transactionStatus(hash),
    );
    _check(
      status == XRPQuickTxStatus.block,
      '$name: expected block status, got $status',
    );

    final nfts = await _step(
      '$name account_nfts',
      () => client.accountNFTs(account: _genesisAccount, limit: 5),
    );
    stdout.writeln('  genesis nfts=${nfts.accountNfts.length}');
  } else {
    // Test/devnets reset: the account may or may not exist. Either way the
    // nullable path must behave (account object or null, never a crash).
    final account = await _step(
      '$name account_info (nullable)',
      () => client.getAccountInfo(_genesisAccount),
    );
    stdout.writeln('  genesis present=${account != null}');
  }
}

Future<void> main() async {
  await _checkNetwork('mainnet', _mainnetUrl);
  await _checkNetwork('testnet', _testnetUrl);
  await _checkNetwork('devnet', _devnetUrl);
  if (_failures > 0) {
    stderr.writeln('FAILED ($_failures)');
    exit(1);
  }
  stdout.writeln('ALL LIVE CHECKS PASSED');
}
