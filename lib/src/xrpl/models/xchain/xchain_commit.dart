import 'package:blockchain_utils/utils/utils.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents a XChainCommit transaction.
/// The XChainCommit transaction is the second step in a cross-chain
/// transfer. It puts assets into trust on the locking chain so that they can
/// be wrapped on the issuing chain, or burns wrapped assets on the issuing
/// chain so that they can be returned on the locking chain.
class XChainCommit extends XRPTransaction {
  XChainCommit.fromJson(super.json)
      : xchainBridge = XChainBridge.fromJson(json['xchain_bridge']),
        xchainClaimId = json['xchain_claim_id'],
        amount = BigintUtils.tryParse(json['amount'])!,
        otherChainDestination = json['other_chain_destination'],
        super.json();

  /// The bridge to use to transfer funds. This field is required.
  final XChainBridge xchainBridge;

  /// The unique integer ID for a cross-chain transfer. This must be acquired on
  /// the destination chain (via a XChainCreateClaimID transaction) and
  /// checked from a validated ledger before submitting this transaction. If an
  /// incorrect sequence number is specified, the funds will be lost. This field
  /// is required.
  final int xchainClaimId;

  /// The asset to commit, and the quantity. This must match the door account's
  /// LockingChainIssue (if on the locking chain) or the door account's
  /// IssuingChainIssue (if on the issuing chain). This field is required.
  final BigInt amount;

  /// The destination account on the destination chain. If this is not specified,
  /// the account that submitted the XChainCreateClaimID transaction on the
  /// destination chain will need to submit a XChainClaim transaction to
  final String? otherChainDestination;

  XChainCommit({
    required super.account,
    required this.xchainBridge,
    required this.xchainClaimId,
    this.otherChainDestination,
    required this.amount,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: XRPLTransactionType.xChainCommit);

  @override
  Map<String, dynamic> toJson() {
    return {
      'xchain_bridge': xchainBridge.toJson(),
      'xchain_claim_id': xchainClaimId,
      'amount': amount.toString(),
      'other_chain_destination': otherChainDestination,
      ...super.toJson()
    };
  }
}
