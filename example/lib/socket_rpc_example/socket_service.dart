import 'dart:async';
import 'dart:convert';
import 'package:xrp_dart/xrp_dart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum WebsocketStatus { connecting, connect, discounnect }

typedef OnResponse = void Function(Map<String, dynamic>);
typedef OnClose = void Function(Object?);

class WebsockerRequestCompeleter {
  WebsockerRequestCompeleter(this.request);
  final Completer<Map<String, dynamic>> completer = Completer();
  final RPCRequestDetails request;
}

class RPCWebSocketService with RpcService {
  RPCWebSocketService._(this.url, WebSocketChannel channel,
      {this.defaultRequestTimeOut = const Duration(seconds: 30),
      this.onClose,
      this.onEvents})
      : _socket = channel {
    _subscription = channel.stream
        .cast<String>()
        .listen(_onMessge, onError: _onClose, onDone: _onDone);
  }
  WebSocketChannel? _socket;
  StreamSubscription<String>? _subscription;
  final Duration defaultRequestTimeOut;
  OnClose? onClose;
  OnResponse? onEvents;
  Map<int, WebsockerRequestCompeleter> requests = {};
  bool _isDiscounnect = false;

  bool get isConnected => _isDiscounnect;

  @override
  final String url;

  void add(RPCRequestDetails params) {
    if (_isDiscounnect) {
      throw StateError("socket has beed discounected");
    }
    _socket?.sink.add(json.encode(params.toWebsocketParams()));
  }

  void _onClose(Object? error) {
    _isDiscounnect = true;
    _socket?.sink.close().catchError((e) => null);
    _socket = null;
    _subscription?.cancel().catchError((e) {});
    _subscription = null;
    onClose?.call(error);

    onClose = null;
    onEvents = null;
  }

  void _onDone() {
    _onClose(null);
  }

  void discounnect() {
    _onClose(null);
  }

  static Future<RPCWebSocketService> connect(
    String url, {
    Iterable<String>? protocols,
    Duration defaultRequestTimeOut = const Duration(seconds: 30),
    OnClose? onClose,
    OnResponse? onEvents,
    final Duration connectionTimeOut = const Duration(seconds: 30),
  }) async {
    final channel =
        WebSocketChannel.connect(Uri.parse(url), protocols: protocols);
    await channel.ready.timeout(connectionTimeOut);
    return RPCWebSocketService._(url, channel,
        defaultRequestTimeOut: defaultRequestTimeOut,
        onClose: onClose,
        onEvents: onEvents);
  }

  void _onMessge(String event) {
    final Map<String, dynamic> decode = json.decode(event);
    if (decode.containsKey("id")) {
      final int id = decode["id"];
      final request = requests.remove(id);
      request?.completer.complete(decode);
    } else {
      onEvents?.call(decode);
    }
  }

  @override
  Future<Map<String, dynamic>> call(RPCRequestDetails params,
      [Duration? timeout]) async {
    final WebsockerRequestCompeleter compeleter =
        WebsockerRequestCompeleter(params);
    try {
      requests[params.id] = compeleter;
      add(params);
      final result = await compeleter.completer.future
          .timeout(timeout ?? defaultRequestTimeOut);
      return result;
    } finally {
      requests.remove(params.id);
    }
  }

  @override
  Future<String> post(String url, String body, {Map<String, String>? header}) {
    throw UnimplementedError();
  }
}
