import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/models/models.dart';
import '../core/methods_impl.dart';

/// The [nft_history] method retreives a list of transactions that involved the
/// specified NFToken.
class XRPRequestNFTHistory
    extends XRPLedgerRequest<NFTHistoryResult, Map<String, dynamic>> {
  XRPRequestNFTHistory({
    required this.nftId,
    this.limit,
    this.marker,
    this.ledgerIndexMax,
    this.ledgerIndexMin,
    this.binary = false,
    this.forward = false,
    super.ledgerIndex = XRPLLedgerIndex.validated,
  });
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
      'nft_id': nftId,
      'limit': limit,
      'marker': marker,
      'ledger_index_min': ledgerIndexMin,
      'ledger_index_max': ledgerIndexMax,
      'binary': binary,
      'forward': forward
    };
  }

  @override
  NFTHistoryResult onResonse(Map<String, dynamic> result) {
    return NFTHistoryResult.fromJson(result);
  }
}
