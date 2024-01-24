import 'package:example/socket_rpc_example/socket_service.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void websocketMethodsExample() async {
  RPCWebSocketService? service;
  final rpc = await XRPLRpc.devNet((httpUri, websocketUri) async {
    service = await RPCWebSocketService.connect(websocketUri);
    return service!;
  });

  await rpc.request(RPCFee());
  await rpc.request(RPCServerInfo());
  await rpc.request(RPCAccountInfo(account: "..."));
  await rpc.request(RPCServerState());
  await rpc.request(RPCServerDefinitions());
  service?.discounnect();

  /// ...
  /// see requset_params for list of requests
}

void websocketStream() async {
  /// stream event
  void onEnvet(Map<String, dynamic> event) {}

  void onClose(Object? err) {}

  /// see socket_service for how to create http service
  RPCWebSocketService? service;
  final rpc = await XRPLRpc.mainnet((httpUri, websocketUri) async {
    service = await RPCWebSocketService.connect(websocketUri,
        onClose: onClose, onEvents: onEnvet);
    return service!;
  });

  /// subscribe
  await rpc.request(RPCSubscribe(streams: [
    StreamParameter.ledger,
  ]));
  await Future.delayed(const Duration(seconds: 20));

  /// unsubscribe
  await rpc.request(RPCUnSubscribe(streams: [StreamParameter.ledger]));
  await Future.delayed(const Duration(minutes: 1));

  /// discounnect websocket
  service?.discounnect();
}
