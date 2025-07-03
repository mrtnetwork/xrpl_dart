import 'package:xrpl_dart/src/rpc/rpc.dart';

/// The server_info command asks the server for a
/// human-readable version of various information
/// about the rippled server being queried.
class XRPRequestServerInfo
    extends XRPLedgerRequest<ServerInfoResult, Map<String, dynamic>> {
  XRPRequestServerInfo();
  @override
  String get method => XRPRequestMethod.serverInfo;

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  ServerInfoResult onResonse(Map<String, dynamic> result) {
    return ServerInfoResult.fromJson(result);
  }
}
