import 'package:example/example_rpc_service.dart';
import 'package:example/transactions/single_transaction_test2.dart';
import 'package:flutter/material.dart';
import 'package:xrp_dart/xrp_dart.dart';

import 'package:http/http.dart' as http;

final rpc = XRPLRpc.testNet((uri) => JsonRPC(uri, http.Client()));

void main() async {
  runApp(MaterialApp(
    home: Scaffold(
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  simpleTransaction();
                },
                child: const Text("WEB"))
          ],
        ),
      ),
    ),
  ));
}
