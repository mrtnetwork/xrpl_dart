import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/rpc/rpc.dart';

class XRPRequestDetails extends BaseServiceRequestParams {
  final String method;
  final Map<String, dynamic> params;
  const XRPRequestDetails({
    required super.requestID,
    super.path,
    required super.responseEncoding,
    required super.headers,
    required this.method,
    required this.params,
    super.successStatusCodes,
    super.errorStatusCodes,
    required super.requestMethod,
  }) : super(
         network: BlockchainNetwork.xrpl,
         bodyBytes: null,
         bodyString: null,
       );
  factory XRPRequestDetails.deserialize({List<int>? bytes, CborObject? obj}) {
    final values = CborTagSerializable.decodeTaggedValue(
      identifier: BlockchainNetwork.xrpl.identifier,
      cborBytes: bytes,
      cborObject: obj,
    );
    final String? bodyStr = values.rawValueAt(8);
    return XRPRequestDetails(
      headers: values
          .mapAt<CborStringValue, CborStringValue>(0)
          .map((k, v) => MapEntry(k.value, v.value)),
      requestMethod: RequestMethod.fromValue(values.rawValueAt(1)),
      responseEncoding: ServiceReponseEncoding.fromValue(values.rawValueAt(2)),
      successStatusCodes:
          values
              .listAt<CborIntValue>(3)
              .map((e) => e.value)
              .toList()
              .emptyAsNull,
      errorStatusCodes:
          values
              .listAt<CborIntValue>(4)
              .map((e) => e.value)
              .toList()
              .emptyAsNull,
      path: values.rawValueAt(5),
      requestID: values.rawValueAt(6),
      method: values.rawValueAt(7),
      params:
          bodyStr == null
              ? {}
              : StringUtils.toJson<Map<String, dynamic>>(bodyStr),
    );
  }
  XRPRequestDetails copyWith({
    int? requestID,
    String? path,
    RequestMethod? requestMethod,
    Map<String, String>? headers,
    ServiceReponseEncoding? responseEncoding,
    List<int>? errorStatusCodes,
    List<int>? successStatusCodes,
    String? method,
    Map<String, dynamic>? params,
  }) {
    return XRPRequestDetails(
      requestID: requestID ?? this.requestID,
      headers: headers ?? this.headers,
      path: path ?? this.path,
      responseEncoding: responseEncoding ?? this.responseEncoding,
      requestMethod: requestMethod ?? this.requestMethod,
      errorStatusCodes: errorStatusCodes ?? this.errorStatusCodes,
      successStatusCodes: successStatusCodes ?? this.successStatusCodes,
      method: method ?? this.method,
      params: params ?? this.params,
    );
  }

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

  /// Converts the request details to WebSocket parameters.
  Map<String, dynamic> content({bool websocket = false}) {
    return websocket ? toWebsocketParams() : toJsonRpcParams();
  }

  @override
  List<int>? encodeBody({ServiceProtocol protocol = ServiceProtocol.http}) {
    assert(!protocol.isGrpc, "Unsupported protocol.");
    return StringUtils.encode(
      StringUtils.fromJson(
        protocol.isSocket ? toWebsocketParams() : toJsonRpcParams(),
      ),
    );
  }

  @override
  Uri encodeUrl(String uri) {
    return Uri.parse(uri);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': requestID,
      'method': method,
      'body': toJsonRpcParams(),
      'type': requestMethod.name,
    };
  }

  @override
  SerializationIdentifier get serializationIdentifier =>
      BlockchainNetwork.xrpl.identifier;

  @override
  List<CborObject?> get serializationItems => [
    CborMapValue.definite(
      headers.map((k, v) => MapEntry(CborStringValue(k), CborStringValue(v))),
    ),
    requestMethod.value.toCbor(),
    responseEncoding.value.toCbor(),
    CborTagSerializable.listFromDynamic(
      successStatusCodes?.map((e) => CborIntValue(e)).toList() ?? [],
    ),
    CborTagSerializable.listFromDynamic(
      errorStatusCodes?.map((e) => CborIntValue(e)).toList() ?? [],
    ),
    path?.toCbor(),
    requestID.toCbor(),
    method.toCbor(),
    CborStringValue(StringUtils.fromJson(params)),
  ];
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
      responseEncoding: ServiceReponseEncoding.map,
      headers: ServiceConst.defaultPostHeaders,
      requestMethod: requestMethod,
      path: null,
    );
  }

  @override
  RequestMethod get requestMethod => RequestMethod.post;
}
