import 'package:xrpl_dart/src/rpc/rpc.dart';

enum LedgerEntryFilter {
  account('account'),
  amendments('amendments'),
  amm('amm'),
  bridge('bridge'),
  check('check'),
  credential('credential'),
  delegate('delegate'),
  depositPreauth('deposit_preauth'),
  did('did'),
  directory('directory'),
  escrow('escrow'),
  fee('fee'),
  hashes('hashes'),
  mptIssuance('mpt_issuance'),
  mptoken('mptoken'),
  nftOffer('nft_offer'),
  nftPage('nft_page'),
  offer('offer'),
  oracle('oracle'),
  paymentChannel('payment_channel'),
  permissionedDomain('permissioned_domain'),
  signerList('signer_list'),
  state('state'),
  ticket('ticket'),
  xchainOwnedCreateAccountClaimId('xchain_owned_create_account_claim_id'),
  xchainOwnedClaimId('xchain_owned_claim_id');

  final String value;
  const LedgerEntryFilter(this.value);

  @override
  String toString() => value;

  static LedgerEntryFilter? fromString(String str) {
    return LedgerEntryFilter.values.firstWhere((e) => e.value == str);
  }
}

/// The ledger_data method retrieves contents of
/// the specified ledger. You can iterate through
/// several calls to retrieve the entire contents
/// of a single ledger version.
/// See [ledger data](https://xrpl.org/ledger_data.html)
class XRPRequestLedgerData
    extends XRPLedgerRequest<LedgerDataResult, Map<String, dynamic>> {
  XRPRequestLedgerData({
    this.type,
    this.limit,
    this.marker,
    this.binary = false,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.ledgerData;

  final int? limit;
  final dynamic marker;
  final bool binary;
  final LedgerEntryFilter? type;

  @override
  Map<String, dynamic> toJson() {
    return {
      'limit': limit,
      'marker': marker,
      'binary': binary,
      'type': type?.value
    };
  }

  @override
  LedgerDataResult onResonse(Map<String, dynamic> result) {
    return LedgerDataResult.fromJson(result, binary: binary);
  }
}
