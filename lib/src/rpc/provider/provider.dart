import 'dart:async';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/exception/exceptions.dart';
import 'package:xrpl_dart/src/rpc/core/methods_impl.dart';
import 'package:xrpl_dart/src/rpc/core/service.dart';
import 'package:xrpl_dart/src/rpc/methods/server_info.dart';
import 'package:xrpl_dart/src/rpc/models/models/server_info.dart';

typedef CbOnGenerateRpc =
    Future<XRPServiceProvider> Function(String httpUri, String websocketUri);

class XRPProviderConst {
  static const String testnetUri = 'https://s.altnet.rippletest.net:51234/';
  static const String mainetUri = 'https://xrplcluster.com/';
  static const String devnetUri = 'https://s.devnet.rippletest.net:51234/';

  static const String devnetWebsocketUri =
      'wss://s.devnet.rippletest.net:51233';
  static const String testnetWebsocketUri =
      'wss://s.altnet.rippletest.net:51233';
  static const String mainetWebsocketUri = 'wss://xrplcluster.com/';

  /// Constants related to XRPL networks and versions
  static const int _restrictedNetworks = 1024;
  static const String _requiredNetworkVersion = '1.11.0';
  static const int _hookTesnetId = 21338;

  /// Faucet URLs for different XRPL networks
  static const String testFaucetUrl =
      'https://faucet.altnet.rippletest.net/accounts';
  static const String devFaucetUrl =
      'https://faucet.devnet.rippletest.net/accounts';
  static const String ammDevFaucetUrl =
      'https://ammfaucet.devnet.rippletest.net/accounts';
  static const String hooksV3TestFaucetUrl =
      'https://hooks-testnet-v3.xrpl-labs.com/accounts';
  static const String sidechainDevnetFaucetUrl =
      'https://sidechain-faucet.devnet.rippletest.net/accounts';
}

/// XRPL RPC Client
///
/// This class provides access to the XRPL (XRP Ledger) network through JSON-RPC.
/// It supports different XRPL networks, including Testnet, Mainnet, Devnet, and AMM Devnet.
class XRPProvider<SERVICE extends IServiceProvider>
    extends IProvider<SERVICE, XRPRequestDetails> {
  @override
  final SERVICE service;
  XRPProvider(this.service);
  ServerInfoResult? _serverInfo;

  /// Create an XRPL RPC client for the Testnet network.
  static Future<XRPProvider> testnet(CbOnGenerateRpc rpcGenerator) async {
    final rpc = await rpcGenerator(
      XRPProviderConst.testnetUri,
      XRPProviderConst.testnetWebsocketUri,
    );
    return XRPProvider(rpc);
  }

  /// Create an XRPL RPC client for the Mainnet network.
  static Future<XRPProvider> mainnet(CbOnGenerateRpc rpcGenerator) async {
    final rpc = await rpcGenerator(
      XRPProviderConst.mainetUri,
      XRPProviderConst.mainetWebsocketUri,
    );
    return XRPProvider(rpc);
  }

  /// Create an XRPL RPC client for the Devnet network.
  static Future<XRPProvider> devnet(CbOnGenerateRpc rpcGenerator) async {
    final rpc = await rpcGenerator(
      XRPProviderConst.devnetUri,
      XRPProviderConst.devnetWebsocketUri,
    );
    return XRPProvider(rpc);
  }

  /// Get the network ID for XRPL transactions.
  ///
  /// The network ID is determined based on the server's network version and ID.
  /// It ensures compatibility with the network and server version requirements.
  Future<int?> getTransactionNetworkId() async {
    _serverInfo ??= await request(XRPRequestServerInfo());
    final int? networkId = _serverInfo?.info.networkId;
    final String? buildVersion = _serverInfo?.info.buildVersion;

    if (networkId != null && networkId > XRPProviderConst._restrictedNetworks) {
      if (buildVersion != null &&
              _isNotLaterRippledVersion(
                XRPProviderConst._requiredNetworkVersion,
                buildVersion,
              ) ||
          networkId == XRPProviderConst._hookTesnetId) {
        return networkId;
      }
    }

    return null;
  }

  bool _isNotLaterRippledVersion(String source, String target) {
    if (source == target) {
      return true;
    }

    final List<String> sourceDecomp = source.split('.');
    final List<String> targetDecomp = target.split('.');
    final int sourceMajor = int.parse(sourceDecomp[0]);
    final int sourceMinor = int.parse(sourceDecomp[1]);
    final int targetMajor = int.parse(targetDecomp[0]);
    final int targetMinor = int.parse(targetDecomp[1]);

    /// Compare major version
    if (sourceMajor != targetMajor) {
      return sourceMajor < targetMajor;
    }

    /// Compare minor version
    if (sourceMinor != targetMinor) {
      return sourceMinor < targetMinor;
    }

    final List<String> sourcePatch = sourceDecomp[2].split('-');
    final List<String> targetPatch = targetDecomp[2].split('-');
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
      if (sourcePatch[1].startsWith('b')) {
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
  static String getFaucetUrl(String url, [String? faucetHost]) {
    if (faucetHost != null) {
      return 'https://$faucetHost/accounts';
    }
    if (url.contains('hooks-testnet-v3')) {
      return XRPProviderConst.hooksV3TestFaucetUrl;
    }
    if (url.contains('altnet') || url.contains('testnet')) {
      return XRPProviderConst.testFaucetUrl;
    }
    if (url.contains('amm')) {
      return XRPProviderConst.ammDevFaucetUrl;
    }
    if (url.contains('sidechain-net1')) {
      return XRPProviderConst.sidechainDevnetFaucetUrl;
    }
    if (url.contains('sidechain-net2')) {
      throw XRPLPluginException(
        'Cannot fund an account on an issuing chain. Accounts must be created via the bridge.',
      );
    }
    if (url.contains('devnet')) {
      return XRPProviderConst.devFaucetUrl;
    }
    throw XRPLPluginException(
      'Cannot fund an account with a client that is not on the testnet or devnet.',
    );
  }

  /// Recursively searches for errors in the RPC response data.
  ///
  /// The [response] parameter represents the response data from the RPC call.
  /// The [params] parameter is the details of the original RPC request.
  /// Returns the parsed result or throws an [RPCError] if an error is detected.
  SERVICERESPONSE _findError<SERVICERESPONSE>({
    required BaseServiceResponse response,
    required XRPRequestDetails params,
  }) {
    final data = params.toEncodingResponse<Map<String, dynamic>>(response);
    final result = StringUtils.tryToJson<Map<String, dynamic>>(data['result']);
    if (result != null) {
      final error = result['error'];
      if (error != null) {
        throw RPCError(
          message: error.toString(),
          relatedNetwork: BlockchainNetwork.xrpl,
          errorCode: IntUtils.tryParse(result["error_code"]),
          jsonRpcErrpr: result,
          request:
              StringUtils.tryToJson<Map<String, dynamic>>(result['request']) ??
              params.toJson(),
        );
      }
      return ServiceProviderUtils.toResponse<SERVICERESPONSE>(
        object: result,
        params: params,
      );
    }
    final message = data['error'];
    throw RPCError(
      relatedNetwork: BlockchainNetwork.xrpl,
      errorCode: IntUtils.tryParse(data["error_code"]),
      jsonRpcErrpr: data,
      message: (message is String ? message : ServiceConst.defaultError),
      request:
          StringUtils.tryToJson<Map<String, dynamic>>(data['request']) ??
          params.toJson(),
    );
  }

  int _id = 0;

  /// Sends a request to the ripple network (XRP) using the specified [request] parameter.
  ///
  /// The [timeout] parameter, if provided, sets the maximum duration for the request.
  /// Whatever is received will be returned
  @override
  Future<RESULT> request<RESULT, SERVICERESPONSE>(
    IServiceRequest<RESULT, SERVICERESPONSE, XRPRequestDetails> request, {
    Duration? timeout,
  }) async {
    final r = await requestDynamic<RESULT, SERVICERESPONSE>(
      request,
      timeout: timeout,
    );
    return request.onResonse(r);
  }

  /// Sends a request to the ripple network (XRP) using the specified [request] parameter.
  ///
  /// The [timeout] parameter, if provided, sets the maximum duration for the request.
  /// Whatever is received will be returned
  @override
  Future<SERVICERESPONSE> requestDynamic<RESULT, SERVICERESPONSE>(
    IServiceRequest<RESULT, SERVICERESPONSE, XRPRequestDetails> request, {
    Duration? timeout,
  }) async {
    final id = ++_id;
    final params = request.buildRequest(id);
    final response = await service.doRequest(params, timeout: timeout);
    return _findError<SERVICERESPONSE>(params: params, response: response);
  }
}
