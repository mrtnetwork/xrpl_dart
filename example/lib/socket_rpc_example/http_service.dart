import 'package:http/http.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

class RPCHttpService with XRPServiceProvider {
  RPCHttpService(this.url, this.client,
      {this.defaultTimeout = const Duration(seconds: 30)});

  @override
  final String url;
  final Client client;
  final Duration defaultTimeout;
  @override
  Future<XRPServiceResponse<T>> doRequest<T>(XRPRequestDetails params,
      {Duration? timeout}) async {
    if (params.type.isPostRequest) {
      final response = await client
          .post(params.toUri(url), headers: params.headers, body: params.body())
          .timeout(timeout ?? defaultTimeout);
      return params.toResponse(response.bodyBytes, response.statusCode);
    }
    final response = await client
        .get(params.toUri(url), headers: params.headers)
        .timeout(timeout ?? defaultTimeout);
    return params.toResponse(response.bodyBytes, response.statusCode);
  }
}
