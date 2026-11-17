library;

import 'dart:async';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/rpc/core/methods_impl.dart';

typedef XRPServiceResponse = BaseServiceResponse;
mixin XRPServiceProvider
    implements
        IServiceProvider<XRPRequestDetails, BaseGRPCServiceRequestParams> {
  String get url;

  @override
  Future<XRPServiceResponse> doRequest(
    XRPRequestDetails params, {
    Duration? timeout,
  });

  @override
  Future<BaseServiceSubscribtionResponse> doSubscribtionRequest({
    required XRPRequestDetails params,
    required BaseServiceSubscribtionRequest<
      dynamic,
      dynamic,
      BaseSubscribtionEvent<dynamic>,
      XRPRequestDetails
    >
    request,
    Duration? timeout,
  }) {
    throw const BuError(
      DefaultErrorType.unsupported,
      "Subscription requests are not supported by this service.",
    );
  }

  @override
  Future<List<int>> doGrpcRequest(
    BaseGRPCServiceRequestParams params, {
    Duration? timeout,
  }) {
    throw const BuError(
      DefaultErrorType.unsupported,
      "gRPC requests are not supported by this service.",
    );
  }

  @override
  Stream<List<int>> doGrpcRequestStream(
    BaseGRPCServiceRequestParams params, {
    Duration? timeout,
  }) {
    throw const BuError(
      DefaultErrorType.unsupported,
      "gRPC requests are not supported by this service.",
    );
  }

  @override
  Future<Stream<List<int>>> doGrpcRequestStreamAsync(
    BaseGRPCServiceRequestParams params, {
    Duration? timeout,
  }) {
    throw const BuError(
      DefaultErrorType.unsupported,
      "gRPC requests are not supported by this service.",
    );
  }
}
