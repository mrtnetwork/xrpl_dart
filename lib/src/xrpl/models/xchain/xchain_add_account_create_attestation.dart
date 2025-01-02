import 'package:blockchain_utils/utils/utils.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents a XChainAddAccountCreateAttestation transaction.
/// The XChainAddAccountCreateAttestation transaction provides an attestation
/// from a witness server that a XChainAccountCreateCommit transaction occurred
/// on the other chain.
class XChainAddAccountCreateAttestation extends XRPTransaction {
  XChainAddAccountCreateAttestation.fromJson(super.json)
      : xchainBridge = XChainBridge.fromJson(json['xchain_bridge']),
        amount = BigintUtils.tryParse(json['amount'])!,
        destination = json['destination'],
        signature = json['signature'],
        publicKey = json['public_key'],
        otherChainSource = json['other_chain_source'],
        attestationRewardAccount = json['attestation_reward_account'],
        attestationSignerAccount = json['attestation_reward_account'],
        wasLockingChainSend =
            json['was_locking_chain_send'] == 0 ? false : true,
        xChainAccountCreateCount = json['xchain_account_create_count'],
        signatureReward = BigintUtils.tryParse(json['signature_reward'])!,
        super.json();

  /// The bridge associated with the attestation. This field is required.
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

  /// The amount committed by the XChainAccountCreateCommit transaction on
  /// the source chain. This field is required.
  final BigInt amount;

  /// The account that should receive this signer's share of the
  /// SignatureReward. This field is required.
  final String attestationRewardAccount;

  /// The account on the door account's signer list that is signing the
  /// transaction. This field is required.
  final String attestationSignerAccount;

  /// A boolean representing the chain where the event occurred. This field is
  ///   required.
  final bool wasLockingChainSend;

  /// The destination account for the funds on the destination chain. This field
  /// is required.
  final String destination;

  /// The counter that represents the order that the claims must be processed in.
  /// This field is required.
  final int xChainAccountCreateCount;

  /// The signature reward paid in the XChainAccountCreateCommit transaction.
  /// This field is required.
  final BigInt signatureReward;

  XChainAddAccountCreateAttestation({
    required super.account,
    required this.xchainBridge,
    required this.destination,
    required this.signature,
    required this.otherChainSource,
    required this.publicKey,
    required this.wasLockingChainSend,
    required this.attestationRewardAccount,
    required this.attestationSignerAccount,
    required this.amount,
    required this.signatureReward,
    required this.xChainAccountCreateCount,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(
            transactionType:
                XRPLTransactionType.xChainAddAccountCreateAttestation);

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
      'destination': destination,
      'xchain_account_create_count': xChainAccountCreateCount,
      'signature_reward': signatureReward.toString(),
      ...super.toJson()
    };
  }
}
