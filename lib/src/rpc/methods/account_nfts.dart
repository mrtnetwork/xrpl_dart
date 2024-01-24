import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/on_chain_models/on_chain_models.dart';
import '../core/methods_impl.dart';

/// This method retrieves all of the NFTs currently owned
/// by the specified account.
class RPCAccountNFTs extends XRPLedgerRequest<Map<String, dynamic>> {
  RPCAccountNFTs({
    required this.account,
    this.limit,
    this.marker,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) : super(ledgerIndex: ledgerIndex);
  @override
  String get method => XRPRequestMethod.accountNfts;

  final String account;
  final int? limit;

  final dynamic marker;

  @override
  Map<String, dynamic> toJson() {
    return {"account": account, "limit": limit, "marker": marker};
  }
}
