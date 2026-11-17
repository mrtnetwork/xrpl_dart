// Shared helpers for the XRPL testnet examples.
//
// Every example talks to the public **XRPL testnet** through its JSON-RPC
// endpoint. Funding uses the official testnet faucet; nothing else is contacted.
//
//   RPC    https://s.altnet.rippletest.net:51234/
//   faucet https://faucet.altnet.rippletest.net/accounts
//
// Keys are deterministic: each wallet is derived from a fixed 16-byte seed
// plus its index and algorithm, so every run reuses the same addresses.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:http/http.dart' as http;
import 'package:xrpl_dart/xrpl_dart.dart';

/// Minimal HTTP JSON-RPC client for the XRPL public API.
class IoService with XRPServiceProvider {
  IoService(this.url, {HttpClient? client}) : client = client ?? HttpClient();

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
    final req = await client.postUrl(uri).timeout(t);
    params.headers.forEach(req.headers.set);
    final body = params.encodeBody();
    if (body != null && body.isNotEmpty) req.add(body);
    final resp = await req.close().timeout(t);
    final bytes =
        await resp.fold<List<int>>(<int>[], (p, e) => p..addAll(e)).timeout(t);
    return params.toResponse(bytes, statusCode: resp.statusCode);
  }

  Future<void> close() async => client.close();
}

/// The XRPL testnet: one provider plus the testnet faucet.
class XrplTestnet {
  XrplTestnet._(this.provider);

  static const String faucetUrl =
      'https://faucet.altnet.rippletest.net/accounts';

  final XRPProvider<IoService> provider;

  static Future<XrplTestnet> connect() async {
    final service = IoService(XRPProviderConst.testnetUri);
    return XrplTestnet._(XRPProvider<IoService>(service));
  }

  /// Confirmed balance of [address] in drops (zero when the account is missing).
  Future<BigInt> balanceOf(String address) async {
    try {
      final info = await provider.request(
        XRPRequestAccountInfo(
          account: address,
          ledgerIndex: XRPLLedgerIndex.validated,
        ),
      );
      return BigInt.parse(info.accountData.balance);
    } on RPCError catch (e) {
      if (e.errorCode == 19 || e.message.contains('actNotFound')) {
        return BigInt.zero;
      }
      rethrow;
    }
  }

  /// Sequence number of [address] (throws when the account does not exist).
  Future<int> sequenceOf(String address) async {
    final info = await provider.request(
      XRPRequestAccountInfo(
        account: address,
        ledgerIndex: XRPLLedgerIndex.current,
      ),
    );
    return info.accountData.sequence;
  }

  /// Last validated ledger index.
  Future<int> ledgerIndex() async {
    final info = await provider.request(XRPRequestServerInfo());
    return info.info.validatedLedger?.seq ?? 0;
  }

  Future<void> close() => provider.service.close();
}

/// A deterministic testnet wallet for one algorithm.
class LocalWallet {
  LocalWallet._(
    this.privateKey,
    this.entropy,
    this.index,
    this.algorithm,
  );

  final XRPPrivateKey privateKey;

  /// The 16-byte entropy this wallet was derived from.
  final List<int> entropy;
  final int index;
  final XRPKeyAlgorithm algorithm;

  static final List<int> _seed = BytesUtils.fromHexString('7a' * 16);

  factory LocalWallet({
    required int index,
    XRPKeyAlgorithm algorithm = XRPKeyAlgorithm.secp256k1,
  }) {
    final entropy = QuickCrypto.sha256Hash([
      ..._seed,
      index,
      algorithm.index,
    ]).sublist(0, 16);
    return LocalWallet._(
      XRPPrivateKey.fromEntropyBytes(entropy, algorithm: algorithm),
      entropy,
      index,
      algorithm,
    );
  }

  XRPPublicKey get publicKey => privateKey.getPublic();

  /// Classic address, e.g. `r...`.
  String get address => publicKey.toClassicAddress().address;

  /// Testnet X-address, e.g. `T...` (includes the tag, if any).
  String get xAddress => publicKey.toXAddress(ChainType.testnet).address;

  String get pubHex => publicKey.toHex();

  /// Family seed, for importing the wallet into other tools.
  String get seed => XrpSeedUtils.encodeSeed(entropy, algorithm);

  /// The address type used for signing digests.
  XRPBaseAddress get src => XRPClassicAddress(address);

  @override
  String toString() => 'LocalWallet(${algorithm.name}, index $index, $address)';
}

/// Requests XRP from the testnet faucet.
///
/// The faucet tops up an existing account as well as creating a new one, and it
/// is rate limited, so [XrplTestnet.balanceOf] is checked first.
Future<void> fund(XrplTestnet net, LocalWallet wallet) async {
  if (await net.balanceOf(wallet.address) >= XRPHelper.xrpToDrop('10')) return;
  final res = await http
      .post(
        Uri.parse(XrplTestnet.faucetUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'destination': wallet.address,
          'userAgent': 'xrpl_dart-example',
        }),
      )
      .timeout(const Duration(seconds: 30));
  if (res.statusCode != 200) {
    throw StateError('faucet rejected ${wallet.address}: ${res.body}');
  }
  await waitForAccount(net, wallet.address);
}

/// Polls until [address] exists on a validated ledger.
Future<void> waitForAccount(
  XrplTestnet net,
  String address, {
  Duration timeout = const Duration(seconds: 40),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (true) {
    if (await net.balanceOf(address) > BigInt.zero) return;
    if (DateTime.now().isAfter(deadline)) {
      throw StateError('account $address was not funded in time');
    }
    await Future<void>.delayed(const Duration(seconds: 2));
  }
}

/// Fills fee, sequence and last-ledger-sequence, signs for [wallet], and
/// submits.
///
/// Returns the [SubmitResult] from the server; call [waitForValidation] to wait
/// for the ledger to validate it.
Future<SubmitResult> submit(
  XrplTestnet net,
  SubmittableTransaction transaction,
  LocalWallet wallet,
) async {
  await signInPlace(net, transaction, wallet);
  return submitSigned(net, transaction);
}

/// Submits a transaction that has already been filled and signed.
///
/// The public testnet occasionally times out on `submit`. A signed transaction
/// is idempotent — it has a fixed sequence, so replaying the same blob cannot
/// apply it twice — so the call is retried.
Future<SubmitResult> submitSigned(
  XrplTestnet net,
  SubmittableTransaction transaction,
) async {
  final txBlob = transaction.toTransactionBlob();
  for (var attempt = 0;; attempt++) {
    try {
      return await net.provider.request(XRPRequestSubmit(txBlob: txBlob));
    } catch (e) {
      if (attempt >= 2) rethrow;
      await Future<void>.delayed(const Duration(seconds: 2));
    }
  }
}

/// Fills fee, sequence and last-ledger-sequence of [transaction] and signs it
/// with [wallet], without submitting.
///
/// Used when a field has to be set before the transaction is signed, such as
/// the channel signature of a payment channel claim; call [submitSigned]
/// afterwards.
Future<void> signInPlace(
  XrplTestnet net,
  SubmittableTransaction transaction,
  LocalWallet wallet,
) async {
  await XRPHelper.autoFill(net.provider, transaction);
  final blob = transaction.toSigningBlobBytes(wallet.src);
  final signature = wallet.privateKey.sign(blob);
  blob.forceZero();
  transaction.setSignature(signature);
}

/// Polls `tx` until [hash] is validated, and returns its metadata.
Future<TxResult> waitForValidation(
  XrplTestnet net,
  String hash, {
  Duration timeout = const Duration(seconds: 45),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (true) {
    try {
      final tx = await net.provider.request(XRPRequestTx(transaction: hash));
      if (tx.validated == true) return tx;
    } on RPCError catch (e) {
      if (!e.message.contains('txnNotFound')) rethrow;
    }
    if (DateTime.now().isAfter(deadline)) {
      throw StateError('transaction $hash was not validated in time');
    }
    await Future<void>.delayed(const Duration(seconds: 2));
  }
}

/// Transaction result code of [tx], e.g. `tesSUCCESS`.
String? resultOf(TxResult tx) => tx.meta?.transactionResult;

/// Formats drops as an XRP amount, e.g. `1.5`.
String formatDrops(BigInt drops) {
  final negative = drops.isNegative;
  final abs = drops.abs();
  final whole = abs ~/ BigInt.from(1000000);
  final frac = (abs % BigInt.from(1000000)).toString().padLeft(6, '0');
  final trimmed = frac.replaceFirst(RegExp(r'0+$'), '');
  final body = trimmed.isEmpty ? '$whole' : '$whole.$trimmed';
  return negative ? '-$body' : body;
}

/// The explorer URL for [hash].
String explorerUrl(String hash) =>
    'https://testnet.xrpl.org/transactions/$hash';

/// A line of `label: value` output, aligned across an example.
String field(String label, String value) {
  return '  ${label.padRight(18)} $value';
}
