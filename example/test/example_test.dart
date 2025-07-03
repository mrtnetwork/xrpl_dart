import 'package:example/socket_rpc_example/http_service.dart';
import 'package:xrpl_dart/xrpl_dart.dart';
import 'package:http/http.dart' as http;

void main() async {
  await t(mainnet);
}

Future<void> t(XRPProvider provider) async {}

final testnet =
    XRPProvider(RPCHttpService(XRPProviderConst.testnetUri, http.Client()));

final devnet =
    XRPProvider(RPCHttpService(XRPProviderConst.devnetUri, http.Client()));

final mainnet =
    XRPProvider(RPCHttpService(XRPProviderConst.mainetUri, http.Client()));
