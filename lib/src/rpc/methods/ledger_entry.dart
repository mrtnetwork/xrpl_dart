import 'package:xrpl_dart/xrpl_dart.dart';

/// The ledger_entry method returns a single ledger
/// object from the XRP Ledger in its raw format.
/// See ledger format for information on the
/// different types of objects you can retrieve.
/// See [ledger entry](https://xrpl.org/ledger_entry.html)
class XRPRequestLedgerEntry
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestLedgerEntry(
      {this.index,
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
      this.xChainClaimID,
      this.xChainCreateAccountClaimID,
      this.nftPage,
      this.binary = false,
      this.rippleState,
      super.ledgerIndex = XRPLLedgerIndex.validated});
  @override
  String get method => XRPRequestMethod.ledgerEntry;

  final String? index;
  final String? accountRoot;
  final String? check;
  final LedgerDepositPreauth? depositPreauth;
  final String? did;
  final LedgerDirectory? directory;
  final LedgerEscrow? escrow;
  final LedgerOffer? offer;
  final String? paymentChannel;
  final LedgerTicket? ticket;
  final String? bridgeAccount;
  final XChainBridge? bridge;
  final LedgerXChainClaimID? xChainClaimID;
  final LedgerXChainCreateAccountClaimID? xChainCreateAccountClaimID;
  final String? nftPage;
  final LedgerRippleState? rippleState;
  final bool binary;
  @override
  Map<String, dynamic> toJson() {
    return {
      'index': index,
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
      'xchain_claim_id': xChainClaimID?.toJson(),
      'xchain_create_account_claim_id': xChainCreateAccountClaimID?.toJson(),
      'nft_page': nftPage,
      'ripple_state': rippleState?.toJson()
    };
  }
}
