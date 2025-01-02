import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/on_chain_models/on_chain_models.dart';
import '../core/methods_impl.dart';

/// The [nft_buy_offers] method retrieves all of buy offers
/// for the specified NFToken.
class XRPRequestNFTBuyOffers
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestNFTBuyOffers(
      {required this.nftId,
      XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated});
  @override
  String get method => XRPRequestMethod.nftBuyOffers;

  final String nftId;

  @override
  Map<String, dynamic> toJson() {
    return {'nft_id': nftId};
  }
}
