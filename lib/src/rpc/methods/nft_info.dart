import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/on_chain_models/on_chain_models.dart';
import '../core/methods_impl.dart';

/// The `nft_info` method retrieves all the information about the
/// NFToken
class RPCNFTInfo extends XRPLedgerRequest<Map<String, dynamic>> {
  RPCNFTInfo({
    required this.nftId,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) : super(ledgerIndex: ledgerIndex);
  @override
  String get method => XRPRequestMethod.nftInfo;

  final String nftId;

  @override
  Map<String, dynamic> toJson() {
    return {"nft_id": nftId};
  }
}
