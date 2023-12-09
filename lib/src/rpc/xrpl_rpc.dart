// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'dart:convert';
import 'package:blockchain_utils/bip/address/xrp_addr.dart';
import 'package:xrp_dart/src/rpc/types.dart';
import 'package:xrp_dart/src/xrpl/models/currencies/currencies.dart';
import 'package:xrp_dart/src/xrpl/models/path/path.dart';
import 'package:xrp_dart/src/xrpl/on_chain_models/ledger.dart';
import 'package:xrp_dart/src/xrpl/on_chain_models/path_found_sub_command.dart';
import 'package:xrp_dart/src/xrpl/on_chain_models/ripple.dart';
import 'package:xrp_dart/src/xrpl/on_chain_models/server_info.dart';
import 'package:xrp_dart/src/xrpl/on_chain_models/ledger_index.dart';
import 'package:xrp_dart/src/xrpl/on_chain_models/ripple_path_found.dart';
import 'package:xrp_dart/src/xrpl/on_chain_models/server_state.dart';
import 'package:xrp_dart/src/xrpl/on_chain_models/transaction_result.dart';

import '../xrpl/on_chain_models/account_info.dart';
import '../xrpl/on_chain_models/fee.dart';
import 'rpc_service.dart';

typedef OnGenerateRpc = RpcService Function(String uri);

class XrpRpcConst {
  static const String testnetUri = "https://s.altnet.rippletest.net:51234/";
  static const String mainetUri = "https://xrplcluster.com/";
  static const String devnetUri = "https://s.devnet.rippletest.net:51234/";
  static const String ammDevnetUri = "https://amm.devnet.rippletest.net:51234/";

  /// Constants related to XRPL networks and versions
  static const int _restrictedNetworks = 1024;
  static const String _requiredNetworkVersion = "1.11.0";
  static const int _hookTesnetId = 21338;

  /// Faucet URLs for different XRPL networks
  static const String testFaucetUrl =
      "https://faucet.altnet.rippletest.net/accounts";
  static const String devFaucetUrl =
      "https://faucet.devnet.rippletest.net/accounts";
  static const String ammDevFaucetUrl =
      "https://ammfaucet.devnet.rippletest.net/accounts";
  static const String hooksV3TestFaucetUrl =
      "https://hooks-testnet-v3.xrpl-labs.com/accounts";
  static const String sidechainDevnetFaucetUrl =
      "https://sidechain-faucet.devnet.rippletest.net/accounts";
}

/// XRPL RPC Client
///
/// This class provides access to the XRPL (XRP Ledger) network through JSON-RPC.
/// It supports different XRPL networks, including Testnet, Mainnet, Devnet, and AMM Devnet.
class XRPLRpc {
  final RpcService rpc;

  ServerInfo? _serverInfo;

  /// Create an XRPL RPC client for the Testnet network.
  XRPLRpc.testNet(OnGenerateRpc rpcGenerator)
      : rpc = rpcGenerator(XrpRpcConst.testnetUri);

  /// Create an XRPL RPC client for the Mainnet network.
  XRPLRpc.mainnet(OnGenerateRpc rpcGenerator)
      : rpc = rpcGenerator(XrpRpcConst.mainetUri);

  /// Create an XRPL RPC client for the Devnet network.
  XRPLRpc.devNet(OnGenerateRpc rpcGenerator)
      : rpc = rpcGenerator(XrpRpcConst.devnetUri);

  /// Create an XRPL RPC client for the AMM Devnet network.
  XRPLRpc.ammDevnet(OnGenerateRpc rpcGenerator)
      : rpc = rpcGenerator(XrpRpcConst.ammDevnetUri);

  /// Get the network ID for XRPL transactions.
  ///
  /// The network ID is determined based on the server's network version and ID.
  /// It ensures compatibility with the network and server version requirements.
  Future<int?> getTransactionNetworkId() async {
    _serverInfo ??= await getServerInfo();
    final int? networkId = _serverInfo?.info.networkId;
    final String? buildVersion = _serverInfo?.info.buildVersion;

    if (networkId != null && networkId > XrpRpcConst._restrictedNetworks) {
      if (buildVersion != null &&
              _isNotLaterRippledVersion(
                  XrpRpcConst._requiredNetworkVersion, buildVersion) ||
          networkId == XrpRpcConst._hookTesnetId) {
        return networkId;
      }
    }

    return null;
  }

  bool _isNotLaterRippledVersion(String source, String target) {
    if (source == target) {
      return true;
    }

    List<String> sourceDecomp = source.split(".");
    List<String> targetDecomp = target.split(".");
    int sourceMajor = int.parse(sourceDecomp[0]);
    int sourceMinor = int.parse(sourceDecomp[1]);
    int targetMajor = int.parse(targetDecomp[0]);
    int targetMinor = int.parse(targetDecomp[1]);

    /// Compare major version
    if (sourceMajor != targetMajor) {
      return sourceMajor < targetMajor;
    }

    /// Compare minor version
    if (sourceMinor != targetMinor) {
      return sourceMinor < targetMinor;
    }

    List<String> sourcePatch = sourceDecomp[2].split("-");
    List<String> targetPatch = targetDecomp[2].split("-");
    int sourcePatchVersion = int.parse(sourcePatch[0]);
    int targetPatchVersion = int.parse(targetPatch[0]);
    if (sourcePatchVersion != targetPatchVersion) {
      return sourcePatchVersion < targetPatchVersion;
    }
    if (sourcePatch.length != targetPatch.length) {
      return sourcePatch.length > targetPatch.length;
    }

    if (sourcePatch.length == 2) {
      sourcePatchVersion = int.parse(sourcePatch[1]);
      targetPatchVersion = int.parse(targetPatch[1]);
      if (!sourcePatch[1][0].startsWith(targetPatch[1][0])) {
        return sourcePatchVersion < targetPatchVersion;
      }
      if (sourcePatch[1].startsWith("b")) {
        return int.parse(sourcePatch[1].substring(1)) <
            int.parse(targetPatch[1].substring(1));
      }
      return int.parse(sourcePatch[1].substring(2)) <
          int.parse(targetPatch[1].substring(2));
    }
    return false;
  }

  /// Get Faucet URL
  ///
  /// This method returns the appropriate Faucet URL for funding an XRPL account
  /// based on the provided XRPL server URL. It handles different XRPL network URLs
  /// and selects the corresponding Faucet URL.
  ///
  /// Parameters:
  /// - [url]: The XRPL server URL.
  /// - [faucetHost]: (Optional) A custom Faucet host to use.
  ///
  /// Returns:
  /// A String representing the Faucet URL for funding the XRPL account.
  ///
  /// Throws:
  /// - [ArgumentError]: If the provided XRPL server URL is not recognized or
  ///   if it's not associated with a supported XRPL network.
  String getFaucetUrl(String url, [String? faucetHost]) {
    if (faucetHost != null) {
      return "https://$faucetHost/accounts";
    }
    if (url.contains("hooks-testnet-v3")) {
      return XrpRpcConst.hooksV3TestFaucetUrl;
    }
    if (url.contains("altnet") || url.contains("testnet")) {
      return XrpRpcConst.testFaucetUrl;
    }
    if (url.contains("amm")) {
      return XrpRpcConst.ammDevFaucetUrl;
    }
    if (url.contains("sidechain-net1")) {
      return XrpRpcConst.sidechainDevnetFaucetUrl;
    }
    if (url.contains("sidechain-net2")) {
      throw ArgumentError(
          "Cannot fund an account on an issuing chain. Accounts must be created via the bridge.");
    }
    if (url.contains("devnet")) {
      return XrpRpcConst.devFaucetUrl;
    }
    throw ArgumentError(
        "Cannot fund an account with a client that is not on the testnet or devnet.");
  }

  void _createRpcConfig(
      Map<String, dynamic> config, String key, dynamic value) {
    if (value != null) {
      config[key] = value;
    }
  }

  /// Make custom request
  Future<T> makeCustomCall<T>(
    String function, [
    List<dynamic>? params,
  ]) async {
    try {
      final data = await rpc.call(function, params);

      /// ignore: only_throw_errors
      if (data is Error || data is Exception) throw data;

      return data.result as T;

      /// ignore: avoid_catches_without_on_clauses
    } catch (e) {
      rethrow;
    }
  }

  /// The fee command reports the current state of the open-ledger requirements
  /// for the transaction cost. This requires the FeeEscalation amendment to be
  /// enabled.
  /// This is a public command available to unprivileged users.
  Future<LedgerInfo> getFee() async {
    final response = await makeCustomCall<Map<String, dynamic>>("fee");
    return LedgerInfo.fromJson(response);
  }

  /// The server_state command asks the server for various
  /// machine-readable information about the rippled server's
  /// current state. The response is almost the same as the
  /// server_info method, but uses units that are easier to
  /// process instead of easier to read. (For example, XRP
  /// values are given in integer drops instead of scientific
  /// notation or decimal values, and time is given in
  /// milliseconds instead of seconds.)
  Future<XRPLedgerState> serverState() async {
    final response = await makeCustomCall<Map<String, dynamic>>("server_state");
    return XRPLedgerState.fromJson(response);
  }

  /// The server_info command asks the server for a
  /// human-readable version of various information
  /// about the rippled server being queried.
  Future<ServerInfo> getServerInfo() async {
    final response = await makeCustomCall<Map<String, dynamic>>("server_info");
    return ServerInfo.fromJson(response);
  }

  /// This request retrieves information about an account, its activity, and its XRP
  /// balance.
  /// All information retrieved is relative to a particular version of the ledger.
  /// See [account_info](https://xrpl.org/account_info.html)
  Future<AccountInfo> getAccountInfo(String address,
      {bool queue = false,
      bool signersList = false,
      bool strict = false,
      String? ledgerHash,
      XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated}) async {
    final Map<String, dynamic> configParams = {
      "account": XRPAddressUtils.ensureClassicAddress(address)
    };
    _createRpcConfig(configParams, "signersList", signersList);
    _createRpcConfig(configParams, "queue", queue);
    _createRpcConfig(configParams, "strict", strict);
    _createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    _createRpcConfig(configParams, "ledger_hash", ledgerHash);
    _createRpcConfig(configParams, "signersList", signersList);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "account_info", [configParams]);
    return AccountInfo.fromJson(response);
  }

  /// The ripple_path_find method is a simplified version of the
  /// path_find method that provides a single response with a payment
  /// path you can use right away. It is available in both the WebSocket
  /// and JSON-RPC APIs. However, the results tend to become outdated as
  /// time passes. Instead of making multiple calls to stay updated, you
  /// should instead use the path_find method to subscribe to continued
  /// updates where possible.
  /// Although the rippled server tries to find the cheapest path or
  /// combination of paths for making a payment, it is not guaranteed that
  /// the paths returned by this method are, in fact, the best paths.
  Future<RipplePathFound> getRipplePathFound(
      {required String sourceAccount,
      required String destinationAccount,
      required CurrencyAmount destinationAmount,
      CurrencyAmount? sendMax,
      List<XRPCurrencies>? currencies}) async {
    final Map<String, dynamic> configParams = {
      "source_account": sourceAccount,
      "destination_account": destinationAccount,
      "destination_amount": destinationAmount.toJson(),
    };
    _createRpcConfig(configParams, "send_max", sendMax?.toJson());
    _createRpcConfig(configParams, "source_currencies",
        currencies?.map((e) => e.toJson()).toList());

    final response = await makeCustomCall<Map<String, dynamic>>(
        "ripple_path_find", [configParams]);
    return RipplePathFound.fromJson(response);
  }

  /// This request returns the raw ledger format for all objects owned by an account.
  /// For a higher-level view of an account's trust lines and balances, see
  /// AccountLinesRequest instead.
  Future<Map<String, dynamic>> getAccountObjects(
    String address, {
    AccountObjectType? type,
    bool? deletionBlockersOnly,
    int? limit,
  }) async {
    final Map<String, dynamic> configParams = {"account": address};
    _createRpcConfig(
        configParams, "deletion_blockers_only", deletionBlockersOnly);
    _createRpcConfig(configParams, "type", type?.value);
    _createRpcConfig(configParams, "limit", limit);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "account_objects", [configParams]);
    return response;
  }

  /// Retrieve information about the public ledger.
  /// See [ledger](https://xrpl.org/ledger.html)
  Future<LedgerData> getLedger(
      {bool queue = false,
      bool full = false,
      bool accounts = false,
      bool transactions = false,
      bool expand = false,
      bool ownerFunds = false,
      bool binary = false,
      String? ledgerHash,
      XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
      LedgerEntryType? type}) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "full", full);
    _createRpcConfig(configParams, "queue", queue);
    _createRpcConfig(configParams, "accounts", accounts);
    _createRpcConfig(configParams, "transactions", transactions);
    _createRpcConfig(configParams, "expand", expand);
    _createRpcConfig(configParams, "owner_funds", ownerFunds);
    _createRpcConfig(configParams, "binary", false);
    _createRpcConfig(configParams, "type", type?.name);
    _createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    _createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "ledger", configParams.isEmpty ? [] : [configParams]);

    return LedgerData.fromJson(response);
  }

  /// WARNING: This object should never be created. You should create an object of type
  /// `SignAndSubmit` or `SubmitOnly` instead.

  /// The submit method applies a transaction and sends it to the network to be confirmed
  /// and included in future ledgers.

  /// This command has two modes:
  /// * Submit-only mode takes a signed, serialized transaction as a binary blob, and
  /// submits it to the network as-is. Since signed transaction objects are immutable, no
  /// part of the transaction can be modified or automatically filled in after submission.
  /// * Sign-and-submit mode takes a JSON-formatted Transaction object, completes and
  /// signs the transaction in the same manner as the sign method, and then submits the
  /// signed transaction. We recommend only using this mode for testing and development.

  /// To send a transaction as robustly as possible, you should construct and sign it in
  /// advance, persist it somewhere that you can access even after a power outage, then
  /// submit it as a tx_blob. After submission, monitor the network with the tx method
  /// command to see if the transaction was successfully applied; if a restart or other
  /// problem occurs, you can safely re-submit the tx_blob transaction: it won't be
  /// applied twice since it has the same sequence number as the old transaction.

  /// `See submit <https://xrpl.org/submit.html>`_
  Future<XRPLTransactionResult> submit(String txBlob,
      {bool failHard = false}) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "tx_blob", txBlob);
    _createRpcConfig(configParams, "fail_hard", failHard);
    final response =
        await makeCustomCall<Map<String, dynamic>>("submit", [configParams]);

    return XRPLTransactionResult.fromJson(response);
  }

  /// get fucent in specify node
  Future<Map<String, dynamic>> getFucent(String address) async {
    final fucentUrl = getFaucetUrl(rpc.url);
    final requestPayload = {'destination': address, 'userAgent': "xrpl-dart"};

    final response = await rpc.post(
      fucentUrl,
      json.encode(requestPayload),
      header: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 30));
    return json.decode(response);
  }

  /// This request returns information about an account's Payment Channels. This includes
  /// only channels where the specified account is the channel's source, not the
  /// destination. (A channel's "source" and "owner" are the same.)
  /// All information retrieved is relative to a particular version of the ledger.
  /// `See [account_channels](https://xrpl.org/account_channels.html)
  Future<Map<String, dynamic>> getAccountChannels(
    String address, {
    String? destinationAmount,
    int limit = 200,
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "account", address);
    _createRpcConfig(configParams, "destination_account", destinationAmount);
    _createRpcConfig(configParams, "limit", limit);
    _createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    _createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "account_channels", [configParams]);

    return response;
  }

  /// This request retrieves a list of currencies that an account can send or receive,
  /// based on its trust lines.
  /// This is not a thoroughly confirmed list, but it can be used to populate user
  /// interfaces.
  /// See [account_currencies](https://xrpl.org/account_currencies.html)
  Future<Map<String, dynamic>> getAccountCurrencies(
    String address, {
    bool strict = false,
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "account", address);
    _createRpcConfig(configParams, "strict", strict);
    _createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    _createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "account_currencies", [configParams]);
    return response;
  }

  /// This request returns information about an account's trust lines, including balances
  /// in all non-XRP currencies and assets. All information retrieved is relative to a
  /// particular version of the ledger.
  /// See [account_lines](https://xrpl.org/account_lines.html)
  Future<Map<String, dynamic>> getAccountLines(
    String address, {
    String? peer,
    int? limit,
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "account", address);
    _createRpcConfig(configParams, "limit", limit);
    _createRpcConfig(configParams, "peer", peer);
    _createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    _createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "account_lines", [configParams]);
    return response;
  }

  /// This method retrieves all of the NFTs currently owned
  /// by the specified account.
  Future<Map<String, dynamic>> getAccountNFTS(
    String address, {
    int? limit,
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "account", address);
    _createRpcConfig(configParams, "limit", limit);
    _createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    _createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "account_nfts", [configParams]);
    return response;
  }

  /// This request retrieves a list of offers made by a given account that are
  /// outstanding as of a particular ledger version.
  Future<Map<String, dynamic>> getAccountOffer(
    String address, {
    int? limit,
    bool strict = false,
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "account", address);
    _createRpcConfig(configParams, "limit", limit);
    _createRpcConfig(configParams, "strict", strict);
    _createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    _createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "account_offers", [configParams]);
    return response;
  }

  /// This request retrieves from the ledger a list of transactions that involved the
  /// specified account.
  Future<Map<String, dynamic>> getAccountTX(
    String address, {
    int? ledgerIndexMin,
    int? ledgerIndexMax,
    bool binary = false,
    bool forward = false,
    int? limit,
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "account", address);
    _createRpcConfig(configParams, "limit", limit);
    _createRpcConfig(configParams, "ledger_index_min", ledgerIndexMin);
    _createRpcConfig(configParams, "ledger_index_max", ledgerIndexMax);
    _createRpcConfig(configParams, "forward", forward);
    _createRpcConfig(configParams, "binary", binary);
    _createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    _createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "account_tx", [configParams]);
    return response;
  }

  /// The `amm_info` method gets information about an Automated Market Maker
  /// (AMM) instance.
  Future<Map<String, dynamic>> getAMMInfo(
      XRPCurrencies asset, XRPCurrencies asset2) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "asset", asset.toJson());
    _createRpcConfig(configParams, "asset2", asset.toJson());
    final response =
        await makeCustomCall<Map<String, dynamic>>("amm_info", [configParams]);
    return response;
  }

  /// The book_offers method retrieves a list of offers, also known
  /// as the order book, between two currencies.
  Future<Map<String, dynamic>> getBookOffer(
    XRPCurrencies takerGets,
    XRPCurrencies takerPays, {
    String? taker,
    int? limit,
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "taker_gets", takerGets.toJson());
    _createRpcConfig(configParams, "taker_pays", takerPays.toJson());
    _createRpcConfig(configParams, "limit", limit);
    _createRpcConfig(configParams, "taker", taker);
    _createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    _createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "book_offers", [configParams]);
    return response;
  }

  /// The channel_authorize method creates a signature that can
  /// be used to redeem a specific amount of XRP from a payment channel.

  /// Warning: Do not send secret keys to untrusted servers or through unsecured network
  /// connections. (This includes the secret, seed, seed_hex, or passphrase fields of
  /// this request.) You should only use this method on a secure, encrypted network
  /// connection to a server you run or fully trust with your funds. Otherwise,
  /// eavesdroppers could use your secret key to sign claims and take all the money from
  /// this payment channel and anything else using the same key pair.
  Future<Map<String, dynamic>> channelAutorize(
    String channelId,
    BigInt amount, {
    String? secret,
    String? seed,
    String? seedHex,
    String? passphrase,
    int? keyType,
  }) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "channel_id", channelId);
    _createRpcConfig(configParams, "amount", amount.toString());
    _createRpcConfig(configParams, "secret", secret);
    _createRpcConfig(configParams, "seed", seed);
    _createRpcConfig(configParams, "seed_hex", seedHex);
    _createRpcConfig(configParams, "passphrase", passphrase);
    _createRpcConfig(configParams, "key_type", keyType);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "channel_authorize", [configParams]);
    return response;
  }

  /// The channel_verify method checks the validity of a
  /// signature that can be used to redeem a specific amount of
  /// XRP from a payment channel.
  Future<Map<String, dynamic>> channelVerify(String channelId, BigInt amount,
      String publicKey, String signature) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "channel_id", channelId);
    _createRpcConfig(configParams, "amount", amount.toString());
    _createRpcConfig(configParams, "signature", signature);
    _createRpcConfig(configParams, "public_key", publicKey);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "channel_verify", [configParams]);
    return response;
  }

  /// The deposit_authorized command indicates whether one account
  /// is authorized to send payments directly to another. See
  /// Deposit Authorization for information on how to require
  /// authorization to deliver money to your account.
  Future<Map<String, dynamic>> depositAutorize(
    String sourceAccount,
    BigInt destinationAmount, {
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "source_account", sourceAccount);
    _createRpcConfig(
        configParams, "destination_account", destinationAmount.toString());
    _createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    _createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "deposit_authorized", [configParams]);
    return response;
  }

  /// This request calculates the total balances issued by a given account, optionally
  /// excluding amounts held by operational addresses.
  Future<Map<String, dynamic>> getwayBalance(
    String account, {
    bool strict = false,
    dynamic hotwallet,
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "account", account);
    _createRpcConfig(configParams, "strict", strict);
    _createRpcConfig(configParams, "hotwallet", hotwallet);
    _createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    _createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "gateway_balances", [configParams]);
    return response;
  }

  /// The ledger_closed method returns the unique
  /// identifiers of the most recently closed ledger.
  /// (This ledger is not necessarily validated and
  /// immutable yet.)
  Future<Map<String, dynamic>> ledgerClosed() async {
    final response =
        await makeCustomCall<Map<String, dynamic>>("ledger_closed");
    return response;
  }

  /// The ledger_current method returns the unique
  /// identifiers of the current in-progress ledger.
  /// This command is mostly useful for testing,
  /// because the ledger returned is still in flux.
  Future<Map<String, dynamic>> ledgerCurrent() async {
    final response =
        await makeCustomCall<Map<String, dynamic>>("ledger_current");
    return response;
  }

  /// The ledger_data method retrieves contents of
  /// the specified ledger. You can iterate through
  /// several calls to retrieve the entire contents
  /// of a single ledger version.
  /// See [ledger data](https://xrpl.org/ledger_data.html)
  Future<Map<String, dynamic>> ledgerData(
      {bool binary = false,
      int? limit,
      String? ledgerHash,
      XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
      LedgerEntryType? type}) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "binary", binary);
    _createRpcConfig(configParams, "limit", limit);
    _createRpcConfig(configParams, "type", type?.value);
    _createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    _createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "ledger_data", [configParams]);
    return response;
  }

  /// The manifest method reports the current
  /// "manifest" information for a given validator
  /// public key. The "manifest" is the public portion
  /// of that validator's configured token.
  Future<Map<String, dynamic>> manifest(String publicKey) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "public_key", publicKey);
    final response =
        await makeCustomCall<Map<String, dynamic>>("manifest", [configParams]);
    return response;
  }

  /// The `nft_buy_offers` method retrieves all of buy offers
  /// for the specified NFToken.
  Future<Map<String, dynamic>> NFTBuyOffers(
    String nftId, {
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "nft_id", nftId);
    _createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    _createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "nft_buy_offers", [configParams]);
    return response;
  }

  /// The `nft_history` method retreives a list of transactions that involved the
  /// specified NFToken.
  Future<Map<String, dynamic>> NFTHistory(
    String nftId, {
    int? ledgerIndexMin,
    int? ledgerIndexMax,
    bool binary = false,
    bool forward = false,
    int? limit,
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "nft_id", nftId);
    _createRpcConfig(configParams, "ledger_index_min", ledgerIndexMin);
    _createRpcConfig(configParams, "ledger_index_max", ledgerIndexMax);
    _createRpcConfig(configParams, "binary", binary);
    _createRpcConfig(configParams, "forward", ledgerIndexMax);
    _createRpcConfig(configParams, "limit", limit);
    _createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    _createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "nft_history", [configParams]);
    return response;
  }

  /// The `nft_info` method retrieves all the information about the
  /// NFToken
  Future<Map<String, dynamic>> NFTInfo(
    String nftId, {
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "nft_id", nftId);
    _createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    _createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response =
        await makeCustomCall<Map<String, dynamic>>("nft_info", [configParams]);
    return response;
  }

  /// The `nft_sell_offers` method retrieves all of sell offers
  /// for the specified NFToken.
  Future<Map<String, dynamic>> NFTSellOffers(
    String nftId, {
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "nft_id", nftId);
    _createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    _createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "nft_sell_offers", [configParams]);
    return response;
  }

  /// This request provides a quick way to check the status of the Default Ripple field
  /// for an account and the No Ripple flag of its trust lines, compared with the
  /// recommended settings.
  Future<Map<String, dynamic>> noRippleCheck(
    String account,
    NoRippleCheckRole role, {
    bool transactions = false,
    int? limit = 300,
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "account", account);
    _createRpcConfig(configParams, "role", role.value);
    _createRpcConfig(configParams, "transactions", transactions);
    _createRpcConfig(configParams, "limit", limit);
    _createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    _createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "noripple_check", [configParams]);
    return response;
  }

  /// WebSocket API only! The path_find method searches for a
  /// path along which a transaction can possibly be made, and
  /// periodically sends updates when the path changes over time.
  /// For a simpler version that is supported by JSON-RPC, see the
  /// ripple_path_find method. For payments occurring strictly in XRP,
  /// it is not necessary to find a path, because XRP can be sent
  /// directly to any account.

  /// Although the rippled server tries to find the cheapest path or combination
  /// of paths for making a payment, it is not guaranteed that the paths returned
  /// by this method are, in fact, the best paths. Due to server load,
  /// pathfinding may not find the best results. Additionally, you should be
  /// careful with the pathfinding results from untrusted servers. A server
  /// could be modified to return less-than-optimal paths to earn money for its
  /// operators. If you do not have your own server that you can trust with
  /// pathfinding, you should compare the results of pathfinding from multiple
  /// servers run by different parties, to minimize the risk of a single server
  /// returning poor results. (Note: A server returning less-than-optimal
  /// results is not necessarily proof of malicious behavior; it could also be
  /// a symptom of heavy server load.)
  Future<Map<String, dynamic>> pathFind(
    PathFindSubcommand subcommand,
    String sourceAccount,
    String destinationAccount,
    XRP destinationAmount, {
    List<List<PathStep>>? paths,
    XRP? sendMax,
  }) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "subcommand", subcommand.value);
    _createRpcConfig(configParams, "source_account", sourceAccount);
    _createRpcConfig(configParams, "destination_account", destinationAccount);
    _createRpcConfig(
        configParams, "destination_amount", destinationAmount.toJson());
    _createRpcConfig(configParams, "send_max", sendMax?.toJson());
    _createRpcConfig(configParams, "paths",
        paths?.map((e) => e.map((e) => e.toJson()).toList()).toList());
    final response =
        await makeCustomCall<Map<String, dynamic>>("path_find", [configParams]);
    return response;
  }

  /// The ping command returns an acknowledgement, so that
  /// clients can test the connection status and latency.
  Future<Map<String, dynamic>> ping() async {
    final response = await makeCustomCall<Map<String, dynamic>>("ping");
    return response;
  }

  /// The submit method applies a transaction and sends it to the network to be confirmed
  /// and included in future ledgers.
  /// This command has two modes:
  /// * Submit-only mode takes a signed, serialized transaction as a binary blob, and
  /// submits it to the network as-is. Since signed transaction objects are immutable, no
  /// part of the transaction can be modified or automatically filled in after submission.
  /// * Sign-and-submit mode takes a JSON-formatted Transaction object, completes and
  /// signs the transaction in the same manner as the sign method, and then submits the
  /// signed transaction. We recommend only using this mode for testing and development.
  /// To send a transaction as robustly as possible, you should construct and sign it in
  /// advance, persist it somewhere that you can access even after a power outage, then
  /// submit it as a tx_blob. After submission, monitor the network with the tx method
  /// command to see if the transaction was successfully applied; if a restart or other
  /// problem occurs, you can safely re-submit the tx_blob transaction: it won't be
  /// applied twice since it has the same sequence number as the old transaction.
  /// See [submit](https://xrpl.org/submit.html)
  Future<XRPLTransactionResult> submitOnly(String txBlob,
      {bool failHard = false}) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "tx_blob", txBlob);
    _createRpcConfig(configParams, "fail_hard", failHard);
    final response =
        await makeCustomCall<Map<String, dynamic>>("submit", [configParams]);
    return XRPLTransactionResult.fromJson(response);
  }

  /// The transaction_entry method retrieves information on a single transaction from a
  /// specific ledger version. (The tx method, by contrast, searches all ledgers for the
  /// specified transaction. We recommend using that method instead.)
  /// See [transaction_entry](https://xrpl.org/transaction_entry.html)
  Future<Map<String, dynamic>> transactionEntry(
    String txHash, {
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "tx_hash", txHash);
    _createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    _createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "transaction_entry", [configParams]);
    return response;
  }

  /// The tx method retrieves information on a single transaction.
  /// See [tx](https://xrpl.org/tx.html)
  Future<Map<String, dynamic>> tx(
    String txHash, {
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    _createRpcConfig(configParams, "tx_hash", txHash);
    _createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    _createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response =
        await makeCustomCall<Map<String, dynamic>>("tx", [configParams]);
    return response;
  }
}
