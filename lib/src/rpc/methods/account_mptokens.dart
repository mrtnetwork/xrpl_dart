import 'package:xrpl_dart/src/rpc/methods/rpc_request_methods.dart';
import 'package:xrpl_dart/src/rpc/models/models.dart';

/// The account_mptokens method returns information about the MPTs held by
/// an account, including their balance. This method is only available on
/// Clio servers.
class XRPRequestAccountMPTokens
    extends XRPLedgerRequest<AccountMPTokensResult, Map<String, dynamic>> {
  XRPRequestAccountMPTokens({
    required this.account,
    this.limit,
    this.marker,
    super.ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.accountMptokens;

  final String account;
  final int? limit;
  final dynamic marker;

  @override
  Map<String, dynamic> toJson() {
    return {'account': account, 'limit': limit, 'marker': marker};
  }

  @override
  AccountMPTokensResult onResponse(Map<String, dynamic> result) {
    return AccountMPTokensResult.fromJson(result);
  }
}
