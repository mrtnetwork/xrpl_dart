import 'dart:convert';

import 'package:http/http.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

class RPCHttpService with RpcService {
  RPCHttpService(this.url, this.client);

  @override
  final String url;
  final Client client;
  @override
  Future<Map<String, dynamic>> call(RPCRequestDetails params) async {
    final response = await client
        .post(Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(params.toJsonRpcParams()))
        .timeout(const Duration(seconds: 30));
    final data = json.decode(response.body) as Map<String, dynamic>;
    return data;
  }

  @override
  Future<String> post(String url, String body,
      {Map<String, String>? header}) async {
    final response = await client
        .post(Uri.parse(url),
            headers: header ?? {'Content-Type': 'application/json'}, body: body)
        .timeout(const Duration(seconds: 30));
    return response.body;
  }
}
