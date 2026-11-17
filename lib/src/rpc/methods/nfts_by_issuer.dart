import 'package:xrpl_dart/src/rpc/methods/rpc_request_methods.dart';
import 'package:xrpl_dart/src/rpc/models/models.dart';

/// `nfts_by_issuer` returns a list of NFTokens issued by the specified
/// account. This method is only available on Clio servers.
class XRPRequestNFTsByIssuer
    extends XRPLedgerRequest<NFTsByIssuerResult, Map<String, dynamic>> {
  XRPRequestNFTsByIssuer({
    required this.issuer,
    this.nftTaxon,
    this.limit,
    this.marker,
    super.ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.nftsByIssuer;

  final String issuer;
  final int? nftTaxon;
  final int? limit;
  final dynamic marker;

  @override
  Map<String, dynamic> toJson() {
    return {
      'issuer': issuer,
      'nft_taxon': nftTaxon,
      'limit': limit,
      'marker': marker,
    };
  }

  @override
  NFTsByIssuerResult onResponse(Map<String, dynamic> result) {
    return NFTsByIssuerResult.fromJson(result);
  }
}
