import 'package:xrpl_dart/src/rpc/methods/rpc_request_methods.dart';
import 'package:xrpl_dart/src/rpc/models/models.dart';

/// For a given MPTokenIssuanceID, `mpt_holders` returns all holders of that
/// MPT and their balance. This method is only available on Clio servers.
class XRPRequestMPTHolders
    extends XRPLedgerRequest<MPTHoldersResult, Map<String, dynamic>> {
  XRPRequestMPTHolders({
    required this.mptIssuanceId,
    this.limit,
    this.marker,
    super.ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.mptHolders;

  final String mptIssuanceId;
  final int? limit;
  final dynamic marker;

  @override
  Map<String, dynamic> toJson() {
    return {'mpt_issuance_id': mptIssuanceId, 'limit': limit, 'marker': marker};
  }

  @override
  MPTHoldersResult onResponse(Map<String, dynamic> result) {
    return MPTHoldersResult.fromJson(result);
  }
}
