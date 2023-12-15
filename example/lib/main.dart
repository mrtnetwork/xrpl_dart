// ignore_for_file: avoid_print

import 'package:example/socket_rpc_example/socket_service.dart';
import 'package:example/examples/xchain/xchain_modify_bridge.dart';
import 'package:flutter/material.dart';
import 'package:xrp_dart/xrp_dart.dart';

late XRPLRpc rpcccc;
void main() async {
  rpcccc = await XRPLRpc.devNet((httpUri, websocketUri) async {
    final c = await RPCWebSocketService.connect(
      websocketUri,
      onClose: (p0) {},
    );
    return c;
  });
  runApp(MaterialApp(
    home: Scaffold(
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  xChainModifyBridge();
                },
                child: const Text("WEB"))
          ],
        ),
      ),
    ),
  ));
}
