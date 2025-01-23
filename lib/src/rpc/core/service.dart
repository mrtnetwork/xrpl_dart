library;

import 'dart:async';

import 'package:blockchain_utils/service/models/params.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

typedef XRPServiceResponse<T> = BaseServiceResponse<T>;
mixin XRPServiceProvider implements BaseServiceProvider<XRPRequestDetails> {
  String get url;

  /// Example:
  /// @override
  /// Future<`XRPServiceResponse<T>`> doRequest<`T`>(XRPRequestDetails params,
  ///     {Duration? timeout}) async {
  ///   final response = await client
  ///      .post(params.toUri(url), headers: params.headers, body: params.body())
  ///      .timeout(timeout ?? defaultTimeOut);
  ///   return params.toResponse(response.bodyBytes, response.statusCode);
  /// }
  @override
  Future<XRPServiceResponse<T>> doRequest<T>(XRPRequestDetails params,
      {Duration? timeout});
}
