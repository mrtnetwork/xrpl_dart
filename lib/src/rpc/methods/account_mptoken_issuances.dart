import 'package:xrpl_dart/src/rpc/methods/rpc_request_methods.dart';
import 'package:xrpl_dart/src/rpc/models/models.dart';

/// The account_mptoken_issuances method returns information about MPT
/// issuances created by an account. This method is only available on
/// Clio servers.
class XRPRequestAccountMPTokenIssuances
    extends
        XRPLedgerRequest<AccountMPTokenIssuancesResult, Map<String, dynamic>> {
  XRPRequestAccountMPTokenIssuances({
    required this.account,
    this.limit,
    this.marker,
    super.ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.accountMptokenIssuances;

  final String account;
  final int? limit;
  final dynamic marker;

  @override
  Map<String, dynamic> toJson() {
    return {'account': account, 'limit': limit, 'marker': marker};
  }

  @override
  AccountMPTokenIssuancesResult onResponse(Map<String, dynamic> result) {
    return AccountMPTokenIssuancesResult.fromJson(result);
  }
}
