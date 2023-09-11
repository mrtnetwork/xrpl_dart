library rpc_service;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

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
}

class JsonRPC extends RpcService {
  JsonRPC(this.url, this.client);

  @override
  final String url;
  final Client client;

  int _currentRequestId = 1;

  /// When the request is successful, an [RPCResponse] with the request id and
  /// the data from the server will be returned. If not, an RPCError will be
  /// thrown. Other errors might be thrown if an IO-Error occurs.
  @override
  Future<RPCResponse> call(
    String function, [
    List<dynamic>? params,
  ]) async {
    params ??= [];
    final requestPayload = {
      'jsonrpc': '2.0',
      'method': function,
      'params': params,
      'id': _currentRequestId++,
    };

    final response = await client
        .post(Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(requestPayload))
        .timeout(const Duration(seconds: 30));
    final data = json.decode(response.body) as Map<String, dynamic>;
    final id = (data['id'] ?? 0) as int;
    if (data["error"] != null) {
      final error = data['error'];

      final code = (error['code'] ?? 0) as int;
      final message = error['message'] as String?;
      final errorData = error['data'];
      throw RPCError(code, message ?? "", errorData, request: requestPayload);
    }

    final result = data['result'];
    if (result["error"] != null) {
      final error = result['error'];
      final code = (result['error_code'] ?? 0) as int;
      final message = result['error_message'] as String?;
      final requestData = result['request'];
      throw RPCError(code, message ?? error ?? "", requestData,
          request: requestPayload);
    }

    return RPCResponse(id, result);
  }

  @override
  Future<void> dispose() async {
    try {
      client.close();
      // ignore: empty_catches
    } catch (e) {}
  }
}

class RPCResponse {
  const RPCResponse(this.id, this.result);

  final int id;
  final dynamic result;
}

class RPCError implements Exception {
  const RPCError(this.errorCode, this.message, this.data, {this.request});

  final int errorCode;
  final String message;
  final dynamic data;
  final Map<String, dynamic>? request;
  Map<String, dynamic> serialize() {
    dynamic modifiedData;
    if (data is Map && !(data as Map).containsKey('request')) {
      modifiedData = Map.from(data as Map);
      modifiedData['request'] = request;
    } else if (data == null) {
      modifiedData = {'request': request};
    } else {
      modifiedData = data;
    }

    var id = request == null ? null : request!['id'];
    if (id is! String && id is! num) id = null;
    return {
      'jsonrpc': '2.0',
      'error': {'code': errorCode, 'message': message, 'data': modifiedData},
      'id': id
    };
  }

  @override
  String toString() {
    return 'RPCError: got code $errorCode with msg "$message".';
  }
}
