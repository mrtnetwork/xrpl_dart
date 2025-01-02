import 'package:blockchain_utils/utils/utils.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents a XChainAccountCreateCommit transaction on the XRP Ledger.
/// The XChainAccountCreateCommit transaction creates a new account on one of
/// the chains a bridge connects, which serves as the bridge entrance for that
/// chain.
class XChainAccountCreateCommit extends XRPTransaction {
  XChainAccountCreateCommit.fromJson(super.json)
      : xchainBridge = XChainBridge.fromJson(json['xchain_bridge']),
        amount = BigintUtils.tryParse(json['amount'])!,
        destination = json['destination'],
        signatureReward = BigintUtils.tryParse(json['signature_reward'])!,
        super.json();

  /// The bridge to create accounts for. This field is required.
  final XChainBridge xchainBridge;

  /// The amount, in XRP, to use for account creation. This must be greater than
  /// or equal to the MinAccountCreateAmount specified in the Bridge
  /// ledger object. This field is required.
  final BigInt amount;

  /// The destination account on the destination chain. This field is required.
  final String destination;

  /// The amount, in XRP, to be used to reward the witness servers for providing
  /// signatures. This must match the amount on the Bridge ledger object. This
  /// field is required.
  final BigInt signatureReward;

  XChainAccountCreateCommit({
    required super.account,
    required this.xchainBridge,
    required this.destination,
    required this.amount,
    required this.signatureReward,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: XRPLTransactionType.xChainAccountCreateCommit);

  @override
  Map<String, dynamic> toJson() {
    return {
      'xchain_bridge': xchainBridge.toJson(),
      'amount': amount.toString(),
      'destination': destination,
      'signature_reward': signatureReward.toString(),
      ...super.toJson()
    };
  }
}
