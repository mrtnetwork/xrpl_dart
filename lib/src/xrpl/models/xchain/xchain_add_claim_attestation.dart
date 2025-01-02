import 'package:blockchain_utils/utils/utils.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents a XChainAddClaimAttestation transaction.
/// The XChainAddClaimAttestation transaction provides proof from a witness
/// server, attesting to an XChainCommit transaction.
class XChainAddClaimAttestation extends XRPTransaction {
  XChainAddClaimAttestation.fromJson(super.json)
      : xchainBridge = XChainBridge.fromJson(json['xchain_bridge']),
        xchainClaimId = json['xchain_claim_id'],
        amount = BigintUtils.tryParse(json['amount'])!,
        destination = json['destination'],
        signature = json['signature'],
        publicKey = json['public_key'],
        otherChainSource = json['other_chain_source'],
        attestationRewardAccount = json['attestation_reward_account'],
        attestationSignerAccount = json['attestation_reward_account'],
        wasLockingChainSend =
            json['was_locking_chain_send'] == 0 ? false : true,
        super.json();

  /// The bridge to use to transfer funds. This field is required.
  final XChainBridge xchainBridge;

  /// The public key used to verify the signature. This field is required.
  final String publicKey;

  /// The signature attesting to the event on the other chain. This field is
  /// required.
  final String signature;

  /// The account on the source chain that submitted the XChainCommit
  /// transaction that triggered the event associated with the attestation. This
  /// field is required.
  final String otherChainSource;

  /// The amount committed by the XChainCommit transaction on the source
  /// chain. This field is required.
  final BigInt amount;

  /// The account that should receive this signer's share of the
  /// SignatureReward. This field is required.
  final String attestationRewardAccount;

  /// The account on the door account's signer list that is signing the
  /// transaction. This field is required.
  final String attestationSignerAccount;

  /// A boolean representing the chain where the event occurred. This field is
  /// required.
  final bool wasLockingChainSend;

  /// The XChainClaimID associated with the transfer, which was included in
  /// the XChainCommit transaction. This field is required.
  final int xchainClaimId;

  /// The destination account for the funds on the destination chain (taken from
  /// the XChainCommit transaction).
  final String? destination;

  XChainAddClaimAttestation({
    required super.account,
    required this.xchainBridge,
    required this.xchainClaimId,
    required this.destination,
    required this.signature,
    required this.otherChainSource,
    required this.publicKey,
    required this.wasLockingChainSend,
    required this.attestationRewardAccount,
    required this.attestationSignerAccount,
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
  }) : super(transactionType: XRPLTransactionType.xChainAddClaimAttestation);

  @override
  Map<String, dynamic> toJson() {
    return {
      'xchain_bridge': xchainBridge.toJson(),
      'public_key': publicKey,
      'signature': signature,
      'other_chain_source': otherChainSource,
      'amount': amount.toString(),
      'attestation_reward_account': attestationRewardAccount,
      'attestation_signer_account': attestationSignerAccount,
      'was_locking_chain_send': wasLockingChainSend ? 1 : 0,
      'xchain_claim_id': xchainClaimId,
      'destination': destination,
      ...super.toJson()
    };
  }
}
