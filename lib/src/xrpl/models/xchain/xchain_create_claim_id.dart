import 'package:blockchain_utils/utils/utils.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

class XChainCreateClaimId extends XRPTransaction {
  XChainCreateClaimId.fromJson(super.json)
      : xchainBridge = XChainBridge.fromJson(json['xchain_bridge']),
        signatureReward = BigintUtils.tryParse(json['signature_reward'])!,
        otherChainSource = json['other_chain_source'],
        super.json();

  /// Represents a XChainCreateClaimID transaction.
  /// The XChainCreateClaimID transaction creates a new cross-chain claim ID that
  /// is used for a cross-chain transfer. A cross-chain claim ID represents one
  /// cross-chain transfer of value.
  final XChainBridge xchainBridge;

  /// The bridge to create the claim ID for. This field is required.
  final BigInt signatureReward;

  /// The amount, in XRP, to reward the witness servers for providing signatures.
  /// This must match the amount on the Bridge ledger object. This field is
  /// required.
  final String otherChainSource;

  XChainCreateClaimId({
    required super.account,
    required this.xchainBridge,
    required this.signatureReward,
    required this.otherChainSource,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: XRPLTransactionType.xChainCreateClaimId);

  @override
  Map<String, dynamic> toJson() {
    return {
      'xchain_bridge': xchainBridge.toJson(),
      'signature_reward': signatureReward.toString(),
      'other_chain_source': otherChainSource,
      ...super.toJson()
    };
  }
}
