library rpc_service;

import 'dart:async';

import 'package:xrpl_dart/xrpl_dart.dart';

/// A mixin representing an RPC (Remote Procedure Call) service.
mixin RpcService {
  /// Gets the base URL of the RPC service.
  String get url;

  /// Makes an RPC call with the provided parameters.
  ///
  /// The [params] parameter represents the details of the RPC request.
  /// Returns a Future that completes with the response data.
  Future<Map<String, dynamic>> call(RPCRequestDetails params);

  /// Sends an HTTP POST request to the specified [url] with the given [body].
  ///
  /// Optionally, you can provide additional [header] parameters for the request.
  /// Returns a Future that completes with the response body as a String.
  ///
  /// Note: This method is intended for use in RPC services that might need
  /// additional HTTP interactions beyond the standard RPC calls.
  Future<String> post(String url, String body, {Map<String, String>? header});
}
