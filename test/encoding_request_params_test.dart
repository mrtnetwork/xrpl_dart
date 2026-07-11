import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:test/test.dart';
import 'package:xrpl_dart/src/rpc/rpc.dart';

void main() {
  test('encodable provider params', () {
    final param = XRPRequestAccountCurrencies(account: "myaccount");
    final request = param.buildRequest(0);
    final deserialize = XRPRequestDetails.deserialize(
      bytes: request.toCbor().encode(),
    );
    expect(deserialize.path, request.path);
    expect(deserialize.encodeBody(), request.encodeBody());
    expect(
      deserialize.encodeBody(protocol: ServiceProtocol.websocket),
      request.encodeBody(protocol: ServiceProtocol.websocket),
    );
    expect(deserialize.successStatusCodes, request.successStatusCodes);
    expect(deserialize.errorStatusCodes, request.errorStatusCodes);
    expect(deserialize.network, BlockchainNetwork.xrpl);
    expect(deserialize.responseEncoding, request.responseEncoding);
    expect(deserialize.requestMethod, request.requestMethod);
  });
}
