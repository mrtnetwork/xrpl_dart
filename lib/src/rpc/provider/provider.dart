import 'dart:async';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

typedef OnGenerateRpc = Future<RpcService> Function(
    String httpUri, String websocketUri);

class RPCConst {
  static const String testnetUri = "https://s.altnet.rippletest.net:51234/";
  static const String mainetUri = "https://xrplcluster.com/";
  static const String devnetUri = "https://s.devnet.rippletest.net:51234/";

  static const String devnetWebsocketUri =
      "wss://s.devnet.rippletest.net:51233";
  static const String testnetWebsocketUri =
      "wss://s.altnet.rippletest.net:51233";
  static const String mainetWebsocketUri = "wss://xrplcluster.com/";

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
  XRPLRpc(this.rpc);
  ServerInfo? _serverInfo;

  /// Create an XRPL RPC client for the Testnet network.
  static Future<XRPLRpc> testNet(OnGenerateRpc rpcGenerator) async {
    final rpc =
        await rpcGenerator(RPCConst.testnetUri, RPCConst.testnetWebsocketUri);
    return XRPLRpc(rpc);
  }

  /// Create an XRPL RPC client for the Mainnet network.
  static Future<XRPLRpc> mainnet(OnGenerateRpc rpcGenerator) async {
    final rpc =
        await rpcGenerator(RPCConst.mainetUri, RPCConst.mainetWebsocketUri);
    return XRPLRpc(rpc);
  }

  /// Create an XRPL RPC client for the Devnet network.
  static Future<XRPLRpc> devNet(OnGenerateRpc rpcGenerator) async {
    final rpc =
        await rpcGenerator(RPCConst.devnetUri, RPCConst.devnetWebsocketUri);
    return XRPLRpc(rpc);
  }

  /// Get the network ID for XRPL transactions.
  ///
  /// The network ID is determined based on the server's network version and ID.
  /// It ensures compatibility with the network and server version requirements.
  Future<int?> getTransactionNetworkId() async {
    _serverInfo ??= await request(RPCServerInfo());
    final int? networkId = _serverInfo?.info.networkId;
    final String? buildVersion = _serverInfo?.info.buildVersion;

    if (networkId != null && networkId > RPCConst._restrictedNetworks) {
      if (buildVersion != null &&
              _isNotLaterRippledVersion(
                  RPCConst._requiredNetworkVersion, buildVersion) ||
          networkId == RPCConst._hookTesnetId) {
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
      return RPCConst.hooksV3TestFaucetUrl;
    }
    if (url.contains("altnet") || url.contains("testnet")) {
      return RPCConst.testFaucetUrl;
    }
    if (url.contains("amm")) {
      return RPCConst.ammDevFaucetUrl;
    }
    if (url.contains("sidechain-net1")) {
      return RPCConst.sidechainDevnetFaucetUrl;
    }
    if (url.contains("sidechain-net2")) {
      throw ArgumentError(
          "Cannot fund an account on an issuing chain. Accounts must be created via the bridge.");
    }
    if (url.contains("devnet")) {
      return RPCConst.devFaucetUrl;
    }
    throw ArgumentError(
        "Cannot fund an account with a client that is not on the testnet or devnet.");
  }

  /// Make custom request
  Future<T> _makeCustomCall<T>(RPCRequestDetails params) async {
    try {
      final data = await rpc.call(params);
      return _paraseResult(data, params) as T;

      /// ignore: avoid_catches_without_on_clauses
    } catch (e) {
      rethrow;
    }
  }

  /// Parses the result of an RPC call and handles errors.
  ///
  /// The [data] parameter represents the response data from the RPC call.
  /// The [request] parameter is the details of the original RPC request.
  /// Returns a map representing the parsed result or throws an [RPCError] if an error is detected
  Map<String, dynamic> _paraseResult(
      Map<String, dynamic> data, RPCRequestDetails request) {
    // Check if the status is "success"
    if (data["status"] == "success") {
      return _findError(data["result"], request);
    }
    // If status is not "success", check for errors in the response
    return _findError(data, request);
  }

  /// Recursively searches for errors in the RPC response data.
  ///
  /// The [data] parameter represents the response data from the RPC call.
  /// The [request] parameter is the details of the original RPC request.
  /// Returns the parsed result or throws an [RPCError] if an error is detected.
  Map<String, dynamic> _findError(
      Map<String, dynamic> data, RPCRequestDetails request) {
    // Check if an error is present in the response
    if (data["error"] != null) {
      final code = (int.tryParse((data['error_code']?.toString()) ?? "0") ?? 0);
      final message = (data['error_message'] ?? data["error"]) ?? "";
      // Throw an RPCError with the error details
      throw RPCError(
          errorCode: code,
          message: message.toString(),
          data: data,
          request: data["request"] ?? request.params);
    }
    // If no error is present, check for the existence of a "result" field
    if (data.containsKey("result")) {
      return _findError(data["result"], request);
    }
    // If no error and no "result" field, return the data as-is
    return data;
  }

  /// get fucent in specify node
  Future<Map<String, dynamic>> getFucent(String address) async {
    final fucentUrl = getFaucetUrl(rpc.url);
    final requestPayload = {'destination': address, 'userAgent': "xrpl-dart"};

    final response = await rpc.post(
      fucentUrl,
      StringUtils.fromJson(requestPayload),
      header: {'Content-Type': 'application/json'},
    ).timeout(const Duration(seconds: 30));
    return StringUtils.toJson(response);
  }

  /// The unique identifier for each RPC request.
  int _requestId = 0;

  /// Sends an XRPLedgerRequest and returns the parsed response.
  ///
  /// The [request] parameter represents an XRPLedgerRequest instance to be sent.
  /// Generates a unique identifier for the request and sends it using [_makeCustomCall].
  /// Returns the parsed response after invoking the [onResponse] method of the XRPLedgerRequest.
  Future<T> request<T>(XRPLedgerRequest<T> request) async {
    _requestId += 1;
    final resp = await _makeCustomCall<Map<String, dynamic>>(
        request.toRequest(_requestId));

    return request.onResonse(resp);
  }
}
