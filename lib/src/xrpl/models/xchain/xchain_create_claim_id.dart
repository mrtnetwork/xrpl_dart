import 'package:xrp_dart/src/number/number_parser.dart';
import 'package:xrp_dart/src/xrpl/models/xrp_transactions.dart';

class XChainCreateClaimId extends XRPTransaction {
  XChainCreateClaimId.fromJson(Map<String, dynamic> json)
      : xchainBridge = XChainBridge.fromJson(json["xchain_bridge"]),
        signatureReward = parseBigInt(json["signature_reward"])!,
        otherChainSource = json["other_chain_source"],
        super.json(json);

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

  XChainCreateClaimId(
      {required String account,
      required this.xchainBridge,
      required this.signatureReward,
      required this.otherChainSource,
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
            transactionType: XRPLTransactionType.xChainCreateClaimId);

  @override
  Map<String, dynamic> toJson() {
    return {
      "xchain_bridge": xchainBridge.toJson(),
      "signature_reward": signatureReward.toString(),
      "other_chain_source": otherChainSource,
      ...super.toJson()
    };
  }
}
