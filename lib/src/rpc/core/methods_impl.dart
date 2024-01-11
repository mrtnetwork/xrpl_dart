import 'package:xrp_dart/src/rpc/rpc.dart';

/// Represents details of an RPC (Remote Procedure Call) request.
class RPCRequestDetails {
  /// Creates an instance of [RPCRequestDetails].
  ///
  /// The [id] parameter represents the unique identifier for the request.
  /// The [method] parameter is the name of the RPC method.
  /// The [params] parameter holds the parameters for the RPC call.
  const RPCRequestDetails({
    required this.id,
    required this.method,
    required this.params,
  });

  /// The unique identifier for the RPC request.
  final int id;

  /// The name of the RPC method.
  final String method;

  /// The parameters for the RPC call.
  final Map<String, dynamic> params;

  /// Converts the request details to JSON-RPC parameters.
  Map<String, dynamic> toJsonRpcParams() {
    return {
      "jsonrpc": "2.0",
      "method": method,
      "params": params.isEmpty ? [] : [params],
      "id": id,
    };
  }

  /// Converts the request details to WebSocket parameters.
  Map<String, dynamic> toWebsocketParams() {
    return {"command": method, "id": id, ...params};
  }
}

/// An abstract class representing a request that can be looked up by ledger index.
abstract class LookupByLedgerRequest {
  /// Creates an instance of [LookupByLedgerRequest].
  ///
  /// The [ledgerIndex] parameter specifies the ledger index for the lookup (default is XRPLLedgerIndex.validated).
  LookupByLedgerRequest({this.ledgerIndex = XRPLLedgerIndex.validated});

  /// The ledger index for the lookup.
  final XRPLLedgerIndex? ledgerIndex;

  /// Converts the request to JSON representation.
  Map<String, dynamic> toJson();
}

/// An abstract class representing an XRPLedgerRequest.
abstract class XRPLedgerRequest<T> extends LookupByLedgerRequest
    implements XRPRequestParams {
  /// Creates an instance of [XRPLedgerRequest].
  ///
  /// The [ledgerIndex] parameter specifies the ledger index for the request.
  XRPLedgerRequest({XRPLLedgerIndex? ledgerIndex})
      : super(ledgerIndex: ledgerIndex);

  /// Gets the validation status for the request (default is null == params is valid).
  String? get validate => null;

  /// Converts the request to JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return ledgerIndex?.toJson() ?? {};
  }

  /// Handles the response received from the RPC call.
  T onResonse(Map<String, dynamic> result) {
    return result as T;
  }

  /// Converts the request to an [RPCRequestDetails] object.
  RPCRequestDetails toRequest(int requestId) {
    final inJson = toJson();
    inJson.addAll(ledgerIndex?.toJson() ?? {});
    inJson.removeWhere((key, value) => value == null);
    return RPCRequestDetails(id: requestId, params: inJson, method: method);
  }
}
