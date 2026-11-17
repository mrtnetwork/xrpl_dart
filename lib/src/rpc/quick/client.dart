import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/rpc/core/methods_impl.dart';
import 'package:xrpl_dart/src/rpc/core/service.dart';
import 'package:xrpl_dart/src/rpc/provider/provider.dart';

import 'api.dart';

/// Default [XRPQuickClientApi]: one XRPL JSON-RPC endpoint (testnet, devnet
/// or mainnet) for reads, submission and polling.
class DefaultXRPQuickClient with XRPQuickClientApi {
  DefaultXRPQuickClient(this._provider);
  final XRPProvider _provider;

  @override
  XRPProvider get provider => _provider;

  /// Creates a client from a service (e.g. an HTTP JSON-RPC service built
  /// with [XRPServiceProvider]).
  factory DefaultXRPQuickClient.fromService(
    IServiceProvider<XRPRequestDetails, BaseGRPCServiceRequestParams> service,
  ) {
    return DefaultXRPQuickClient(XRPProvider(service));
  }
}
