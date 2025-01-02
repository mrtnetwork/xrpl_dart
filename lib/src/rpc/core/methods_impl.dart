import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/rpc/rpc.dart';

/// Represents details of an RPC (Remote Procedure Call) request.
class XRPRequestDetails extends BaseServiceRequestParams {
  /// Creates an instance of [XRPRequestDetails].
  ///
  /// The [requestID] parameter represents the unique identifier for the request.
  /// The [method] parameter is the name of the RPC method.
  /// The [params] parameter holds the parameters for the RPC call.
  const XRPRequestDetails(
      {required super.requestID,
      required super.headers,
      required super.type,
      required this.method,
      required this.params,
      this.url});

  /// The name of the RPC method.
  final String method;

  final String? url;

  /// The parameters for the RPC call.
  final Map<String, dynamic> params;

  /// Converts the request details to JSON-RPC parameters.
  Map<String, dynamic> toJsonRpcParams() {
    return ServiceProviderUtils.buildJsonRPCParams(
      requestId: requestID,
      method: method,
      params: params.isEmpty ? [] : [params],
    );
  }

  /// Converts the request details to WebSocket parameters.
  Map<String, dynamic> toWebsocketParams() {
    return {'command': method, 'id': requestID, ...params};
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': requestID,
      'method': method,
      'body': toJsonRpcParams(),
      'type': type.name
    };
  }

  @override
  List<int>? body({bool websoket = false}) {
    if (url != null) {
      return StringUtils.encode(StringUtils.fromJson(params));
    }
    return StringUtils.encode(StringUtils.fromJson(
        websoket ? toWebsocketParams() : toJsonRpcParams()));
  }

  @override
  Uri toUri(String uri) {
    return Uri.parse(url ?? uri);
  }
}

/// An abstract class representing an XRPLedgerRequest.
abstract class XRPLedgerRequest<RESULT, RESPONSE>
    extends BaseServiceRequest<RESULT, RESPONSE, XRPRequestDetails> {
  /// The ledger index for the lookup.
  final XRPLLedgerIndex? ledgerIndex;

  /// Creates an instance of [XRPLedgerRequest].
  ///
  /// The [ledgerIndex] parameter specifies the ledger index for the request.
  XRPLedgerRequest({this.ledgerIndex});

  /// The RPC method associated with the request.
  ///
  /// Subclasses must implement this property to specify the RPC method for the request.
  abstract final String method;

  /// Converts the request parameters to a JSON representation.
  ///
  /// Subclasses must implement this method to define how the request parameters are serialized to JSON.
  Map<String, dynamic> toJson();

  /// Converts the request to an [XRPRequestDetails] object.
  @override
  XRPRequestDetails buildRequest(int requestID) {
    final inJson = toJson();
    inJson.addAll(ledgerIndex?.toJson() ?? {});
    inJson.removeWhere((key, value) => value == null);
    return XRPRequestDetails(
        requestID: requestID,
        params: inJson,
        method: method,
        headers: ServiceConst.defaultPostHeaders,
        type: requestType);
  }

  @override
  RequestServiceType get requestType => RequestServiceType.post;
}
