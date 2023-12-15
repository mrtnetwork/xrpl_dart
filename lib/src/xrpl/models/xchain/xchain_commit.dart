import 'package:xrp_dart/src/number/number_parser.dart';
import 'package:xrp_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents a XChainCommit transaction.
/// The XChainCommit transaction is the second step in a cross-chain
/// transfer. It puts assets into trust on the locking chain so that they can
/// be wrapped on the issuing chain, or burns wrapped assets on the issuing
/// chain so that they can be returned on the locking chain.
class XChainCommit extends XRPTransaction {
  XChainCommit.fromJson(Map<String, dynamic> json)
      : xchainBridge = XChainBridge.fromJson(json["xchain_bridge"]),
        xchainClaimId = json["xchain_claim_id"],
        amount = parseBigInt(json["amount"])!,
        otherChainDestination = json["other_chain_destination"],
        super.json(json);

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

  XChainCommit(
      {required String account,
      required this.xchainBridge,
      required this.xchainClaimId,
      this.otherChainDestination,
      required this.amount,
      List<XRPLMemo>? memos = const [],
      String signingPubKey = "",
      int? ticketSequance,
      BigInt? fee,
      int? lastLedgerSequence,
      int? sequence,
      List<XRPLSigners>? signers,
      dynamic flags,
      int? sourceTag,
      List<String> multiSigSigners = const []})
      : super(
            account: account,
            fee: fee,
            lastLedgerSequence: lastLedgerSequence,
            memos: memos,
            sequence: sequence,
            signers: signers,
            sourceTag: sourceTag,
            flags: flags,
            ticketSequance: ticketSequance,
            signingPubKey: signingPubKey,
            multiSigSigners: multiSigSigners,
            transactionType: XRPLTransactionType.xChainCommit);

  @override
  Map<String, dynamic> toJson() {
    return {
      "xchain_bridge": xchainBridge.toJson(),
      "xchain_claim_id": xchainClaimId,
      "amount": amount.toString(),
      "other_chain_destination": otherChainDestination,
      ...super.toJson()
    };
  }
}
