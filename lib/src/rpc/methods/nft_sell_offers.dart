import 'package:xrp_dart/src/rpc/methods/methods.dart';
import 'package:xrp_dart/src/rpc/on_chain_models/on_chain_models.dart';
import '../core/methods_impl.dart';

/// The [nft_sell_offers] method retrieves all of sell offers
/// for the specified NFToken.
class RPCNFTSellOffers extends XRPLedgerRequest<Map<String, dynamic>> {
  RPCNFTSellOffers({
    required this.nftId,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.nftSellOffers;

  final String nftId;

  @override
  Map<String, dynamic> toJson() {
    return {"nft_id": nftId};
  }
}
