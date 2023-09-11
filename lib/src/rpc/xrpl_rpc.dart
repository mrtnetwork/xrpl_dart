// ignore_for_file: non_constant_identifier_names, avoid_print, unused_local_variable

import 'dart:convert';
import 'package:xrp_dart/src/rpc/types.dart';
import 'package:xrp_dart/src/xrpl/address_utilities.dart';
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
import 'package:http/http.dart' as http;

import '../xrpl/on_chain_models/account_info.dart';
import '../xrpl/on_chain_models/fee.dart';
import 'rpc_service.dart';

class XRPLRpc {
  XRPLRpc(this.rpc);
  XRPLRpc.testNet()
      : rpc = JsonRPC("https://s.altnet.rippletest.net:51234/", http.Client());
  XRPLRpc.mainnet() : rpc = JsonRPC("https://xrplcluster.com/", http.Client());
  XRPLRpc.devNet()
      : rpc = JsonRPC("https://s.devnet.rippletest.net:51234/", http.Client());
  XRPLRpc.ammDevnet()
      : rpc =
            JsonRPC("https://amm.devnet.rippletest.net:51234/", http.Client());
  final JsonRPC rpc;

  final int RESTRICTED_NETWORKS = 1024;
  final String _requiredNetworkVersion = "1.11.0";
  final int _hookTesnetId = 21338;
  final String _testFaucetUrl = "https://faucet.altnet.rippletest.net/accounts";
  final String _devFaucetUrl = "https://faucet.devnet.rippletest.net/accounts";
  final String _ammDevFaucetUrl =
      "https://ammfaucet.devnet.rippletest.net/accounts";
  final String _hooksV3TestFaucetUrl =
      "https://hooks-testnet-v3.xrpl-labs.com/accounts";
  final String _sidechainDevnetFaucetUrl =
      "https://sidechain-faucet.devnet.rippletest.net/accounts";
  ServerInfo? _serverInfo;
  Future<int?> getTransactionNetworkId() async {
    _serverInfo ??= await getServerInfo();
    final int? networkId = _serverInfo?.info.networkId;
    final String? buildVersion = _serverInfo?.info.buildVersion;
    if (networkId != null && networkId > RESTRICTED_NETWORKS) {
      if (buildVersion != null &&
              _isNotLaterRippledVersion(
                  _requiredNetworkVersion, buildVersion) ||
          networkId == _hookTesnetId) {
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

    // Compare major version
    if (sourceMajor != targetMajor) {
      return sourceMajor < targetMajor;
    }

    // Compare minor version
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

  String getFaucetUrl(String url, [String? faucetHost]) {
    if (faucetHost != null) {
      return "https://$faucetHost/accounts";
    }
    if (url.contains("hooks-testnet-v3")) {
      return _hooksV3TestFaucetUrl;
    }
    if (url.contains("altnet") || url.contains("testnet")) {
      return _testFaucetUrl;
    }
    if (url.contains("amm")) {
      return _ammDevFaucetUrl;
    }
    if (url.contains("sidechain-net1")) {
      return _sidechainDevnetFaucetUrl;
    }
    if (url.contains("sidechain-net2")) {
      throw ArgumentError(
          "Cannot fund an account on an issuing chain. Accounts must be created via the bridge.");
    }
    if (url.contains("devnet")) {
      return _devFaucetUrl;
    }
    throw ArgumentError(
        "Cannot fund an account with a client that is not on the testnet or devnet.");
  }

  void createRpcConfig(Map<String, dynamic> config, String key, dynamic value) {
    if (value != null) {
      config[key] = value;
    }
  }

  Future<T> makeCustomCall<T>(
    String function, [
    List<dynamic>? params,
  ]) async {
    try {
      final data = await rpc.call(function, params);

      // ignore: only_throw_errors
      if (data is Error || data is Exception) throw data;

      return data.result as T;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      rethrow;
    }
  }

  Future<LedgerInfo> getFee() async {
    final response = await makeCustomCall<Map<String, dynamic>>("fee");
    return LedgerInfo.fromJson(response);
  }

  Future<XRPLedgerState> serverState() async {
    final response = await makeCustomCall<Map<String, dynamic>>("server_state");
    return XRPLedgerState.fromJson(response);
  }

  Future<ServerInfo> getServerInfo() async {
    final response = await makeCustomCall<Map<String, dynamic>>("server_info");
    return ServerInfo.fromJson(response);
  }

  Future<AccountInfo> getAccountInfo(String address,
      {bool queue = false,
      bool signersList = false,
      bool strict = false,
      String? ledgerHash,
      XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated}) async {
    final Map<String, dynamic> configParams = {
      "account": XRPAddressUtilities.toCalssicAddress(address)
    };
    createRpcConfig(configParams, "signersList", signersList);
    createRpcConfig(configParams, "queue", queue);
    createRpcConfig(configParams, "strict", strict);
    createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    createRpcConfig(configParams, "ledger_hash", ledgerHash);
    createRpcConfig(configParams, "signersList", signersList);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "account_info", [configParams]);
    return AccountInfo.fromJson(response);
  }

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
    createRpcConfig(configParams, "send_max", sendMax?.toJson());
    createRpcConfig(configParams, "source_currencies",
        currencies?.map((e) => e.toJson()).toList());

    final response = await makeCustomCall<Map<String, dynamic>>(
        "ripple_path_find", [configParams]);
    print("response $response");
    // return AccountInfo.fromJson(response);
    return RipplePathFound.fromJson(response);
  }

  Future<Map<String, dynamic>> getAccountObjects(
    String address, {
    AccountObjectType? type,
    bool? deletionBlockersOnly,
    int? limit,
  }) async {
    final Map<String, dynamic> configParams = {"account": address};
    createRpcConfig(
        configParams, "deletion_blockers_only", deletionBlockersOnly);
    createRpcConfig(configParams, "type", type?.value);
    createRpcConfig(configParams, "limit", limit);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "account_objects", [configParams]);
    print("response $response");
    return response;
    // return AccountInfo.fromJson(response);
  }

  /// https://xrpl.org/ledger.html
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
    createRpcConfig(configParams, "full", full);
    createRpcConfig(configParams, "queue", queue);
    createRpcConfig(configParams, "accounts", accounts);
    createRpcConfig(configParams, "transactions", transactions);
    createRpcConfig(configParams, "expand", expand);
    createRpcConfig(configParams, "owner_funds", ownerFunds);
    createRpcConfig(configParams, "binary", false);
    createRpcConfig(configParams, "type", type?.name);
    createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "ledger", configParams.isEmpty ? [] : [configParams]);

    return LedgerData.fromJson(response);
  }

  Future<XRPLTransactionResult> submit(String txBlob,
      {bool failHard = false}) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "tx_blob", txBlob);
    createRpcConfig(configParams, "fail_hard", failHard);
    final response =
        await makeCustomCall<Map<String, dynamic>>("submit", [configParams]);

    return XRPLTransactionResult.fromJson(response);
  }

  Future<Map<String, dynamic>> getFucent(String address) async {
    final client = http.Client();
    try {
      final fucentUrl = getFaucetUrl(rpc.url);
      final requestPayload = {'destination': address, 'userAgent': "xrpl-dart"};

      final response = await client
          .post(Uri.parse(fucentUrl),
              headers: {'Content-Type': 'application/json'},
              body: json.encode(requestPayload))
          .timeout(const Duration(seconds: 30));
      return json.decode(response.body);
    } finally {
      client.close();
    }
  }

  Future<Map<String, dynamic>> getAccountChannels(
    String address, {
    String? destinationAmount,
    int limit = 200,
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "account", address);
    createRpcConfig(configParams, "destination_account", destinationAmount);
    createRpcConfig(configParams, "limit", limit);
    createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "account_channels", [configParams]);
    print("got respinse $response");
    return response;
  }

  Future<Map<String, dynamic>> getAccountCurrencies(
    String address, {
    bool strict = false,
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "account", address);
    createRpcConfig(configParams, "strict", strict);
    createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "account_currencies", [configParams]);
    return response;
  }

  Future<Map<String, dynamic>> getAccountLines(
    String address, {
    String? peer,
    int? limit,
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "account", address);
    createRpcConfig(configParams, "limit", limit);
    createRpcConfig(configParams, "peer", peer);
    createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "account_lines", [configParams]);
    return response;
  }

  Future<Map<String, dynamic>> getAccountNFTS(
    String address, {
    int? limit,
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "account", address);
    createRpcConfig(configParams, "limit", limit);
    createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "account_nfts", [configParams]);
    return response;
  }

  Future<Map<String, dynamic>> getAccountOffer(
    String address, {
    int? limit,
    bool strict = false,
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "account", address);
    createRpcConfig(configParams, "limit", limit);
    createRpcConfig(configParams, "strict", strict);
    createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "account_offers", [configParams]);
    return response;
  }

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
    createRpcConfig(configParams, "account", address);
    createRpcConfig(configParams, "limit", limit);
    createRpcConfig(configParams, "ledger_index_min", ledgerIndexMin);
    createRpcConfig(configParams, "ledger_index_max", ledgerIndexMax);
    createRpcConfig(configParams, "forward", forward);
    createRpcConfig(configParams, "binary", binary);
    createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "account_tx", [configParams]);
    return response;
  }

  Future<Map<String, dynamic>> getAMMInfo(
      XRPCurrencies asset, XRPCurrencies asset2) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "asset", asset.toJson());
    createRpcConfig(configParams, "asset2", asset.toJson());
    final response =
        await makeCustomCall<Map<String, dynamic>>("amm_info", [configParams]);
    return response;
  }

  Future<Map<String, dynamic>> getBookOffer(
    XRPCurrencies takerGets,
    XRPCurrencies takerPays, {
    String? taker,
    int? limit,
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "taker_gets", takerGets.toJson());
    createRpcConfig(configParams, "taker_pays", takerPays.toJson());
    createRpcConfig(configParams, "limit", limit);
    createRpcConfig(configParams, "taker", taker);
    createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "book_offers", [configParams]);
    return response;
  }

  Future<Map<String, dynamic>> channelAutorize(
    String channelId,
    BigInt amount, {
    String? secret,
    String? seed,
    String? seedHex,
    String? passphrase,
    CryptoAlgorithm? keyType,
  }) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "channel_id", channelId);
    createRpcConfig(configParams, "amount", amount.toString());
    createRpcConfig(configParams, "secret", secret);
    createRpcConfig(configParams, "seed", seed);
    createRpcConfig(configParams, "seed_hex", seedHex);
    createRpcConfig(configParams, "passphrase", passphrase);
    createRpcConfig(configParams, "key_type", keyType?.value);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "channel_authorize", [configParams]);
    return response;
  }

  Future<Map<String, dynamic>> channelVerify(String channelId, BigInt amount,
      String publicKey, String signature) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "channel_id", channelId);
    createRpcConfig(configParams, "amount", amount.toString());
    createRpcConfig(configParams, "signature", signature);
    createRpcConfig(configParams, "public_key", publicKey);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "channel_verify", [configParams]);
    return response;
  }

  Future<Map<String, dynamic>> depositAutorize(
    String sourceAccount,
    BigInt destinationAmount, {
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "source_account", sourceAccount);
    createRpcConfig(
        configParams, "destination_account", destinationAmount.toString());
    createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "deposit_authorized", [configParams]);
    return response;
  }

  Future<Map<String, dynamic>> getwayBalance(
    String account, {
    bool strict = false,
    dynamic hotwallet,
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "account", account);
    createRpcConfig(configParams, "strict", strict);
    createRpcConfig(configParams, "hotwallet", hotwallet);
    createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "gateway_balances", [configParams]);
    return response;
  }

  Future<Map<String, dynamic>> ledgerClosed() async {
    final response =
        await makeCustomCall<Map<String, dynamic>>("ledger_closed");
    return response;
  }

  Future<Map<String, dynamic>> ledgerCurrent() async {
    final response =
        await makeCustomCall<Map<String, dynamic>>("ledger_current");
    return response;
  }

  Future<Map<String, dynamic>> ledgerData(
      {bool binary = false,
      int? limit,
      String? ledgerHash,
      XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
      LedgerEntryType? type}) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "binary", binary);
    createRpcConfig(configParams, "limit", limit);
    createRpcConfig(configParams, "type", type?.value);
    createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "ledger_data", [configParams]);
    return response;
  }

  Future<Map<String, dynamic>> manifest(String publicKey) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "public_key", publicKey);
    final response =
        await makeCustomCall<Map<String, dynamic>>("manifest", [configParams]);
    return response;
  }

  Future<Map<String, dynamic>> NFTBuyOffers(
    String nftId, {
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "nft_id", nftId);
    createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "nft_buy_offers", [configParams]);
    return response;
  }

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
    createRpcConfig(configParams, "nft_id", nftId);
    createRpcConfig(configParams, "ledger_index_min", ledgerIndexMin);
    createRpcConfig(configParams, "ledger_index_max", ledgerIndexMax);
    createRpcConfig(configParams, "binary", binary);
    createRpcConfig(configParams, "forward", ledgerIndexMax);
    createRpcConfig(configParams, "limit", limit);
    createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "nft_history", [configParams]);
    return response;
  }

  Future<Map<String, dynamic>> NFTInfo(
    String nftId, {
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "nft_id", nftId);
    createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response =
        await makeCustomCall<Map<String, dynamic>>("nft_info", [configParams]);
    return response;
  }

  Future<Map<String, dynamic>> NFTSellOffers(
    String nftId, {
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "nft_id", nftId);
    createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "nft_sell_offers", [configParams]);
    return response;
  }

  Future<Map<String, dynamic>> noRippleCheck(
    String account,
    NoRippleCheckRole role, {
    bool transactions = false,
    int? limit = 300,
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "account", account);
    createRpcConfig(configParams, "role", role.value);
    createRpcConfig(configParams, "transactions", transactions);
    createRpcConfig(configParams, "limit", limit);
    createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "noripple_check", [configParams]);
    return response;
  }

  Future<Map<String, dynamic>> pathFind(
    PathFindSubcommand subcommand,
    String sourceAccount,
    String destinationAccount,
    XRP destinationAmount, {
    List<List<PathStep>>? paths,
    XRP? sendMax,
  }) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "subcommand", subcommand.value);
    createRpcConfig(configParams, "source_account", sourceAccount);
    createRpcConfig(configParams, "destination_account", destinationAccount);
    createRpcConfig(
        configParams, "destination_amount", destinationAmount.toJson());
    createRpcConfig(configParams, "send_max", sendMax?.toJson());
    createRpcConfig(configParams, "paths",
        paths?.map((e) => e.map((e) => e.toJson()).toList()).toList());
    final response =
        await makeCustomCall<Map<String, dynamic>>("path_find", [configParams]);
    return response;
  }

  Future<Map<String, dynamic>> ping() async {
    final response = await makeCustomCall<Map<String, dynamic>>("ping");
    return response;
  }

  Future<XRPLTransactionResult> submitOnly(String txBlob,
      {bool failHard = false}) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "tx_blob", txBlob);
    createRpcConfig(configParams, "fail_hard", failHard);
    final response =
        await makeCustomCall<Map<String, dynamic>>("submit", [configParams]);
    return XRPLTransactionResult.fromJson(response);
  }

  Future<Map<String, dynamic>> transactionEntry(
    String txHash, {
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "tx_hash", txHash);
    createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response = await makeCustomCall<Map<String, dynamic>>(
        "transaction_entry", [configParams]);
    return response;
  }

  Future<Map<String, dynamic>> tx(
    String txHash, {
    String? ledgerHash,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) async {
    final Map<String, dynamic> configParams = {};
    createRpcConfig(configParams, "tx_hash", txHash);
    createRpcConfig(configParams, "ledger_index", ledgerIndex?.value);
    createRpcConfig(configParams, "ledger_hash", ledgerHash);
    final response =
        await makeCustomCall<Map<String, dynamic>>("tx", [configParams]);
    return response;
  }
}
