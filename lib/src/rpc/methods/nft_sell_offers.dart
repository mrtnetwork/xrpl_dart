import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/on_chain_models/on_chain_models.dart';
import '../core/methods_impl.dart';

/// The [nft_sell_offers] method retrieves all of sell offers
/// for the specified NFToken.
class XRPRequestNFTSellOffers
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestNFTSellOffers({
    required this.nftId,
    super.ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.nftSellOffers;

  final String nftId;

  @override
  Map<String, dynamic> toJson() {
    return {'nft_id': nftId};
  }
}
