import 'package:xrpl_dart/src/rpc/methods/rpc_request_methods.dart';
import 'package:xrpl_dart/src/rpc/models/models.dart';

/// This method retrieves all of the NFTs currently owned
/// by the specified account.
class XRPRequestAccountNFTs
    extends XRPLedgerRequest<AccountNFTsResult, Map<String, dynamic>> {
  XRPRequestAccountNFTs({
    required this.account,
    this.limit,
    this.marker,
    super.ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.accountNfts;

  final String account;
  final int? limit;

  final dynamic marker;

  @override
  Map<String, dynamic> toJson() {
    return {'account': account, 'limit': limit, 'marker': marker};
  }

  @override
  AccountNFTsResult onResonse(Map<String, dynamic> result) {
    return AccountNFTsResult.fromJson(result);
  }
}
