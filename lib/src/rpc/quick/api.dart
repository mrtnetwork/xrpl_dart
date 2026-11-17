import 'dart:async';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/crypto/keypair/xrpl_private_key.dart';
import 'package:xrpl_dart/src/rpc/methods/rpc_request_methods.dart';
import 'package:xrpl_dart/src/rpc/models/models.dart';
import 'package:xrpl_dart/src/rpc/provider/provider.dart';
import 'package:xrpl_dart/src/xrpl/address/xrpl.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

import 'models.dart';

/// Quick client API: one method per top request used by the wallet and the
/// swap client, plus the top network reads.
///
/// Consumers depend on this mixin instead of raw request classes. XRPL has a
/// single JSON-RPC backend, so there is one [provider].
///
/// Wallet/swap parity notes (base-native adaptations):
/// - Balances return raw drops (`BigInt`); the wallet token/`APPImage` store
///   wrappers stay in the wallet.
/// - `getAccountTokensStream`, xrplmeta metadata lookup and
///   `validateNetworkId`/`verifyService` (genesis checks, store infra) stay in
///   the wallet: they are wallet-interaction methods, not provider calls.
/// - Multisig-aware fee scaling (`XRPHelper.calcuateTransactionFee`) stays in
///   the wallet; [applyFee] sets the open-ledger fee.
/// - `transactionStatus` takes the tx hash directly (the wallet only used
///   `transaction.txId`) and returns [XRPQuickTxStatus].
mixin XRPQuickClientApi {
  /// XRPL JSON-RPC provider (testnet, devnet or mainnet).
  IProvider<IServiceProvider, XRPRequestDetails> get provider;

  /// rippled `actNotFound` error code: the account does not exist (yet).
  static const int accountNotFoundErrorCode = 19;

  /// Account record of [address], or null when the account does not exist
  /// (wallet parity).
  Future<BaseAccountInfoResponse?> getAccountInfo(String address) async {
    try {
      return await provider.request(XRPRequestAccountInfo(account: address));
    } on RPCError catch (e) {
      if (e.errorCode == accountNotFoundErrorCode ||
          e.message.contains('actNotFound')) {
        return null;
      }
      rethrow;
    }
  }

  /// XRP balance of [address] in drops (zero when the account is missing).
  Future<BigInt> getAccountBalance(String address) async {
    final account = await getAccountInfo(address);
    if (account == null) return BigInt.zero;
    return BigintUtils.parse(account.accountData.balance);
  }

  /// Current sequence of [address] (wallet `getAccountSequence` parity).
  Future<int> getAccountSequence(String address) async {
    final account = await provider.request(
      XRPRequestAccountInfo(
        account: address,
        ledgerIndex: XRPLLedgerIndex.current,
      ),
    );
    return account.accountData.sequence;
  }

  /// Current in-progress ledger index. Tolerant to servers answering either
  /// `ledger_current_index` or `ledger_index`.
  Future<int> ledgerCurrent() {
    return provider.request(XRPRequestLedgerCurrent());
  }

  /// Most recently closed ledger (not necessarily validated yet).
  Future<LedgerClosedResult> ledgerClosed() {
    return provider.request(XRPRequestLedgerClosed());
  }

  /// Fee state of the open ledger (wallet `getFeeData` parity).
  Future<FeeResult> feeData() {
    return provider.request(XRPRequestFee());
  }

  /// Suggested fee in drops (open-ledger fee; wallet parity for the
  /// single-signer case — multisig/escrow scaling stays in the wallet).
  Future<BigInt> suggestedFee({XrplFeeType type = XrplFeeType.open}) async {
    final fee = await feeData();
    return fee.getFeeType(type: type);
  }

  /// Server descriptor (amendments, network id, versions).
  Future<ServerInfoResult> serverInfo() {
    return provider.request(XRPRequestServerInfo());
  }

  /// Network id for transactions, or null when the server does not enforce
  /// one (wallet `getNetworkId` parity).
  Future<int?> transactionNetworkId() async {
    final serverInfo = await provider.request(XRPRequestServerInfo());
    final int? networkId = serverInfo.info.networkId;
    final String? buildVersion = serverInfo.info.buildVersion;

    if (networkId != null && networkId > XRPProviderConst.restrictedNetworks) {
      if (buildVersion != null &&
              XRPProvider.isNotLaterRippledVersion(
                XRPProviderConst.requiredNetworkVersion,
                buildVersion,
              ) ||
          networkId == XRPProviderConst.hookTesnetId) {
        return networkId;
      }
    }

    return null;
  }

  /// Canonical type/field table served by the node. Used as the drift
  /// detector: the live table must contain every type the codec knows about
  /// (e.g. `NFTokenModify`, `CredentialIDs`).
  Future<ServerDefinitionsResult> serverDefinitions() {
    return provider.request(XRPRequestServerDefinitions());
  }

  /// Fills sequence, network id and last-ledger-sequence of [transaction]
  /// (swap `filledTransactionRequirment` parity). The default offset matches
  /// the wallet (`ledger_current + 100`).
  Future<T> fillTransactionRequirements<T extends SubmittableTransaction>(
    T transaction, {
    int lastLedgerOffset = 100,
    bool force = true,
  }) async {
    if (transaction.networkId == null || force) {
      transaction.setNetworkId(await transactionNetworkId());
    }
    if (transaction.ticketSequance == null || force) {
      transaction.setSequence(await getAccountSequence(transaction.account));
    }
    final current = await ledgerCurrent();
    transaction.setLastLedgerSequence(current + lastLedgerOffset);
    return transaction;
  }

  /// Sets the open-ledger fee on [transaction] (swap fee-step parity).
  Future<T> applyFee<T extends SubmittableTransaction>(
    T transaction, {
    XrplFeeType type = XrplFeeType.open,
  }) async {
    transaction.setFee(await suggestedFee(type: type));
    return transaction;
  }

  /// Runs the `simulate` check on [transaction] (wallet/swap parity).
  Future<SimulateResult> simulateTx(SubmittableTransaction transaction) {
    return provider.request(
      XRPRequestSimulateTx(txBlob: transaction.toTransactionBlob()),
    );
  }

  /// Fill + fee + simulate; throws when simulation fails (swap
  /// `simulateTransactionFee` parity: the returned transaction is ready to
  /// sign).
  Future<T> prepareTransaction<T extends SubmittableTransaction>(
    T transaction, {
    XrplFeeType feeType = XrplFeeType.open,
    int lastLedgerOffset = 100,
  }) async {
    await fillTransactionRequirements(
      transaction,
      lastLedgerOffset: lastLedgerOffset,
    );
    await applyFee(transaction, type: feeType);
    final result = await simulateTx(transaction);
    if (!result.isSuccess) {
      throw BuError(DefaultErrorType.invalidArgument, 
        'Transaction simulation failed: ${result.engineResult}',
      );
    }
    return transaction;
  }

  /// Signs [transaction] locally with [key] (single signature).
  /// The transaction must already carry fee, sequence and
  /// last-ledger-sequence (see [prepareTransaction]).
  T signTransaction<T extends SubmittableTransaction>(
    T transaction,
    XRPPrivateKey key,
  ) {
    final signer = XRPBaseAddress(transaction.account);
    final payload = transaction.toSigningBlobBytes(signer);
    try {
      transaction.setSignature(key.sign(payload));
    } finally {
      payload.forceZero();
    }
    return transaction;
  }

  /// Submits a signed transaction blob (wallet `sendTransaction` parity).
  Future<SubmitResult> submitBlob(String txBlob) {
    return provider.request(XRPRequestSubmit(txBlob: txBlob));
  }

  /// Submits a signed [transaction].
  Future<SubmitResult> submitTransaction(SubmittableTransaction transaction) {
    return submitBlob(transaction.toTransactionBlob());
  }

  /// Signs with [key] and submits (swap broadcast parity).
  Future<SubmitResult> signAndSubmit(
    SubmittableTransaction transaction,
    XRPPrivateKey key,
  ) {
    return submitTransaction(signTransaction(transaction, key));
  }

  /// Looks up a transaction by hash; null when unknown.
  Future<TxResult?> transaction(String hash) async {
    try {
      return await provider.request(XRPRequestTx(transaction: hash));
    } on RPCError catch (e) {
      if (e.message.contains('txnNotFound')) return null;
      rethrow;
    }
  }

  /// Status of a transaction by hash (wallet `transactionStatus` parity).
  Future<XRPQuickTxStatus> transactionStatus(String hash) async {
    final tx = await transaction(hash);
    if (tx == null || tx.validated != true) return XRPQuickTxStatus.pending;
    final meta = tx.meta;
    final result = meta?.transactionResult;
    if (result != null && result.startsWith('tes')) {
      return XRPQuickTxStatus.block;
    }
    return XRPQuickTxStatus.failed;
  }

  /// Polls `tx` until [hash] validates (or fails), throwing on timeout.
  Future<TxResult> pollTransaction(
    String hash, {
    Duration timeout = const Duration(minutes: 2),
    Duration interval = const Duration(seconds: 4),
  }) async {
    final deadline = DateTime.now().add(timeout);
    for (;;) {
      final tx = await transaction(hash);
      if (tx != null && tx.validated == true) return tx;
      if (DateTime.now().isAfter(deadline)) {
        throw BuError(DefaultErrorType.invalidState, 
          'Transaction $hash not validated within $timeout.',
        );
      }
      await Future<void>.delayed(interval);
    }
  }

  // ---- Top network reads (single page; pass `marker` through for paging).
  // Paginated iteration, token-metadata and store streaming stay in the
  // wallet; these are thin typed passthroughs.

  /// Recent transactions of [account] (wallet `getAccountTxes` page parity).
  Future<AccountTxResult> accountTx({
    required String account,
    int? ledgerIndexMin,
    int? ledgerIndexMax,
    int? limit,
    dynamic marker,
  }) {
    return provider.request(
      XRPRequestAccountTx(
        account: account,
        ledgerIndexMin: ledgerIndexMin,
        ledgerIndexMax: ledgerIndexMax,
        limit: limit,
        marker: marker,
      ),
    );
  }

  /// NFTs owned by [account].
  Future<AccountNFTsResult> accountNFTs({
    required String account,
    int? limit,
    dynamic marker,
  }) {
    return provider.request(
      XRPRequestAccountNFTs(account: account, limit: limit, marker: marker),
    );
  }

  /// Buy offers for [nftId].
  Future<NFTBuyOffersResult> nftBuyOffers(String nftId) {
    return provider.request(XRPRequestNFTBuyOffers(nftId: nftId));
  }

  /// Sell offers for [nftId].
  Future<NFTSellOffersResult> nftSellOffers(String nftId) {
    return provider.request(XRPRequestNFTSellOffers(nftId: nftId));
  }

  /// Trust lines of [account].
  Future<AccountLinesResult> accountLines({
    required String account,
    int? limit,
    dynamic marker,
  }) {
    return provider.request(
      XRPRequestAccountLines(account: account, limit: limit, marker: marker),
    );
  }

  /// Outstanding offers of [account].
  Future<AccountOffersResult> accountOffers({
    required String account,
    int? limit,
    dynamic marker,
  }) {
    return provider.request(
      XRPRequestAccountOffer(account: account, limit: limit, marker: marker),
    );
  }

  /// Objects owned by [account].
  Future<AccountObjectsResult> accountObjects({
    required String account,
    AccountObjectType? type,
    int? limit,
    dynamic marker,
  }) {
    return provider.request(
      XRPRequestAccountObjectType(
        account: account,
        type: type,
        limit: limit,
        marker: marker,
      ),
    );
  }

  /// Gateway balances of [account]: assets issued by others and held by
  /// [account], plus [account]'s own obligations (wallet `XRPRPCFetchTokens`
  /// parity minus wallet-type mapping).
  Future<GatewayBalancesResult> gatewayBalances({
    required String account,
    dynamic hotWallet,
    bool strict = false,
  }) {
    return provider.request(
      XRPRequestGatewayBalances(
        account: account,
        hotWallet: hotWallet,
        strict: strict,
      ),
    );
  }

  /// Ledger by index/hash.
  Future<Ledger> ledger(XRPLLedgerIndex ledgerIndex) {
    return provider.request(XRPRequestLedger(ledgerIndex: ledgerIndex));
  }
}
