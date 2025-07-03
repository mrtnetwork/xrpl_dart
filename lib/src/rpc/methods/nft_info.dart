import 'package:xrpl_dart/src/rpc/methods/rpc_request_methods.dart';
import 'package:xrpl_dart/src/rpc/models/models.dart';

/// The `nft_info` method retrieves all the information about the
/// NFToken
class XRPRequestNFTInfo
    extends XRPLedgerRequest<NFTokenResult, Map<String, dynamic>> {
  XRPRequestNFTInfo({
    required this.nftId,
    super.ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.nftInfo;

  final String nftId;

  @override
  Map<String, dynamic> toJson() {
    return {'nft_id': nftId};
  }

  @override
  NFTokenResult onResonse(Map<String, dynamic> result) {
    return NFTokenResult.fromJson(result);
  }
}
