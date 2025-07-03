import 'package:xrpl_dart/src/rpc/methods/rpc_request_methods.dart';
import 'package:xrpl_dart/src/rpc/models/models.dart'
    show XRPLLedgerIndex, LedgerEntryResult, LedgerEntry;
import 'package:xrpl_dart/src/rpc/models/models/params.dart';

/// The ledger_entry method returns a single ledger
/// object from the XRP Ledger in its raw format.
/// See ledger format for information on the
/// different types of objects you can retrieve.
/// See [ledger entry](https://xrpl.org/ledger_entry.html)
class XRPRequestLedgerEntry<T extends LedgerEntry>
    extends XRPLedgerRequest<LedgerEntryResult<T>, Map<String, dynamic>> {
  XRPRequestLedgerEntry(
      {this.index,
      this.mptIssuance,
      this.accountRoot,
      this.check,
      this.depositPreauth,
      this.did,
      this.directory,
      this.escrow,
      this.offer,
      this.paymentChannel,
      this.ticket,
      this.bridgeAccount,
      this.bridge,
      this.xChainOwnedClaimID,
      this.xChainOwnedCreateAccountClaimID,
      this.nftPage,
      this.amm,
      this.binary = false,
      this.credential,
      this.includeDeleted,
      this.mptoken,
      this.rippleState,
      this.delegate,
      super.ledgerIndex = XRPLLedgerIndex.validated});
  @override
  String get method => XRPRequestMethod.ledgerEntry;
  final String? mptIssuance;
  final MptokenParams? mptoken;
  final AMMParams? amm;
  final bool? includeDeleted;
  final bool binary;
  final String? index;
  final String? accountRoot;
  final String? check;
  final CredentialParams? credential;
  final DepositPreauthParams? depositPreauth;
  final String? did;
  final DirectoryParams? directory;
  final EscrowParams? escrow;
  final OfferParams? offer;
  final String? paymentChannel;
  final RippleStateParams? rippleState;
  final TicketParams? ticket;
  final String? bridgeAccount;
  final String? nftPage;
  final XChainBridgeParams? bridge;
  final XChainOwnedClaimIDParams? xChainOwnedClaimID;
  final XChainOwnedCreateAccountClaimIDParams? xChainOwnedCreateAccountClaimID;
  final DelegateParams? delegate;
  @override
  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'mpt_issuance': mptIssuance,
      'mptoken': mptoken?.toJson(),
      'amm': amm?.toJson(),
      'include_deleted': includeDeleted,
      'credential': credential?.toJson(),
      'delegate': delegate?.toJson(),
      'account_root': accountRoot,
      'check': check,
      'deposit_preauth': depositPreauth?.toJson(),
      'did': did,
      'directory': directory?.toJson(),
      'escrow': escrow?.toJson(),
      'offer': offer?.toJson(),
      'payment_channel': paymentChannel,
      'ticket': ticket?.toJson(),
      'bridge_account': bridgeAccount,
      'bridge': bridge?.toJson(),
      'xchain_owned_claim_id': xChainOwnedClaimID?.toJson(),
      'xchain_owned_create_account_claim_id':
          xChainOwnedCreateAccountClaimID?.toJson(),
      'nft_page': nftPage,
      'ripple_state': rippleState?.toJson(),
    };
  }

  @override
  LedgerEntryResult<T> onResonse(Map<String, dynamic> result) {
    return LedgerEntryResult.fromJson(result);
  }
}
