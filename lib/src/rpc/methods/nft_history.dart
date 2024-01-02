import 'package:xrp_dart/src/rpc/methods/methods.dart';
import 'package:xrp_dart/src/rpc/on_chain_models/on_chain_models.dart';
import '../core/methods_impl.dart';

/// The [nft_history] method retreives a list of transactions that involved the
/// specified NFToken.
class RPCNFTHistory extends XRPLedgerRequest<Map<String, dynamic>> {
  RPCNFTHistory({
    required this.nftId,
    this.limit,
    this.marker,
    this.ledgerIndexMax,
    this.ledgerIndexMin,
    this.binary = false,
    this.forward = false,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) : super(ledgerIndex: ledgerIndex);
  @override
  String get method => XRPRequestMethod.nftHistory;

  final String nftId;
  final int? limit;
  final dynamic marker;
  final int? ledgerIndexMin;
  final int? ledgerIndexMax;
  final bool binary;
  final bool forward;

  @override
  Map<String, dynamic> toJson() {
    return {
      "nft_id": nftId,
      "limit": limit,
      "marker": marker,
      "ledger_index_min": ledgerIndexMin,
      "ledger_index_max": ledgerIndexMax,
      "binary": binary,
      "forward": forward
    };
  }
}
