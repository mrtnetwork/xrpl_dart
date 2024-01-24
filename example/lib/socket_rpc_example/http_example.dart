// ignore_for_file: unused_local_variable

import 'package:example/socket_rpc_example/http_service.dart';
import 'package:xrpl_dart/xrpl_dart.dart';
import 'package:http/http.dart' as http;

void httpApiExample() async {
  /// see http_service for how to create http service
  RPCHttpService? service;
  final rpc = await XRPLRpc.devNet((httpUri, websocketUri) async {
    service = RPCHttpService(httpUri, http.Client());
    return service!;
  });

  /// sync
  final syncRpc = XRPLRpc(RPCHttpService(RPCConst.devFaucetUrl, http.Client()));

  try {
    await rpc.request(RPCFee());
    await rpc.request(RPCServerInfo());
    await rpc.request(RPCAccountInfo(account: "..."));
    await rpc.request(RPCServerState());
    await rpc.request(RPCServerDefinitions());

    /// catch rpc errors
  } on RPCError catch (e) {
    e.request;
    e.message;
    e.errorCode;
  }
}

class RPCAccountNftOffersIDs extends XRPLedgerRequest<List<String>> {
  RPCAccountNftOffersIDs({
    required this.account,
    this.limit,
    this.marker,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.accountNfts;

  final String account;
  final int? limit;

  final dynamic marker;

  @override
  Map<String, dynamic> toJson() {
    return {"account": account, "limit": limit, "marker": marker};
  }

  /// override on response to handle rpc result with what you want
  @override
  List<String> onResonse(Map<String, dynamic> result) {
    final List<dynamic> nfts = result["account_nfts"];
    return nfts.map<String>((e) => e["nft_offer_index"]).toList();
  }
}

void customRpc() async {
  final syncRpc = XRPLRpc(RPCHttpService(RPCConst.devFaucetUrl, http.Client()));
  final List<String> nftOfferIds =
      await syncRpc.request(RPCAccountNftOffersIDs(account: "..."));
}
