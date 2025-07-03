import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents a XChainCreateBridge transaction.
/// The XChainCreateBridge transaction creates a new Bridge ledger object and
/// defines a new cross-chain bridge entrance on the chain that the transaction
/// is submitted on. It includes information about door accounts and assets for
/// the bridge.
class XChainCreateBridge extends SubmittableTransaction {
  XChainCreateBridge.fromJson(super.json)
      : xchainBridge = XChainBridge.fromJson(json['xchain_bridge']),
        signatureReward = json['signature_reward'],
        minAccountCreateAmount = json['min_account_create_amount'],
        super.json();

  /// The bridge (door accounts and assets) to create. This field is required.
  final XChainBridge xchainBridge;

  /// The total amount to pay the witness servers for their signatures. This
  /// amount will be split among the signers. This field is required.
  final String signatureReward;

  /// The minimum amount, in XRP, required for a XChainAccountCreateCommit
  /// transaction. If this isn't present, the XChainAccountCreateCommit
  /// transaction will fail. This field can only be present on XRP-XRP bridges.
  final String? minAccountCreateAmount;

  XChainCreateBridge({
    required super.account,
    required this.xchainBridge,
    required this.signatureReward,
    this.minAccountCreateAmount,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: SubmittableTransactionType.xChainCreateBridge);

  @override
  Map<String, dynamic> toJson() {
    return {
      'xchain_bridge': xchainBridge.toJson(),
      'signature_reward': signatureReward,
      'min_account_create_amount': minAccountCreateAmount,
      ...super.toJson()
    }..removeWhere((_, v) => v == null);
  }

  @override
  String? get validate {
    if (xchainBridge.lockingChainDoor == xchainBridge.issuingChainDoor) {
      return 'xchainBridge Cannot have the same door accounts on the locking and issuing chain.';
    }
    if (!<String>[xchainBridge.lockingChainDoor, xchainBridge.issuingChainDoor]
        .contains(account)) {
      return 'account must be either locking chain door or issuing chain door.';
    }
    if (xchainBridge.issuingChainIssue.isXrp &&
        xchainBridge.lockingChainIssue.isXrp) {
      return super.validate;
    }
    if (!xchainBridge.issuingChainIssue.isXrp &&
        !xchainBridge.lockingChainIssue.isXrp) {
      return super.validate;
    }

    return 'issue Bridge must be XRP-XRP or IOU-IOU.';
  }
}
