library rpc_service;

import 'dart:async';
import 'dart:convert';

abstract class RpcService {
  String get url;

  /// Performs an RPC request, asking the server to execute the function with
  /// the given name and the associated parameters, which need to be encodable
  /// with the [json] class of dart:convert.
  ///
  /// When the request is successful, an [RPCResponse] with the request id and
  /// the data from the server will be returned. If not, an RPCError will be
  /// thrown. Other errors might be thrown if an IO-Error occurs.
  Future<RPCResponse> call(
    String function, [
    List<dynamic>? params,
  ]);
  Future<void> dispose();

  Future<String> post(String url, String body, {Map<String, String>? header});
}

/// Represents a response object for a Remote Procedure Call (RPC) request.
class RPCResponse {
  /// Constructor for creating a new RPCResponse with a given ID and result.
  const RPCResponse(this.id, this.result);

  /// The ID of the RPC request associated with this response.
  final int? id;

  /// The result of the RPC request, which can be of any type.
  final dynamic result;
}
