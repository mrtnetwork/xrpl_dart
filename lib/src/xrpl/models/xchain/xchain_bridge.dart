import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

class XChainBridge extends XRPLBase {
  XChainBridge.fromJson(Map<String, dynamic> json)
      : lockingChainDoor = json['locking_chain_door'],
        lockingChainIssue = XRPCurrencies.fromJson(json['locking_chain_issue']),
        issuingChainDoor = json['issuing_chain_door'],
        issuingChainIssue = XRPCurrencies.fromJson(json['issuing_chain_issue']);

  XChainBridge(
      {required this.issuingChainDoor,
      required this.issuingChainIssue,
      required this.lockingChainDoor,
      required this.lockingChainIssue});

  /// A XChainBridge represents a cross-chain bridge.
  /// The door account on the locking chain.
  final String lockingChainDoor;

  /// The asset that is locked and unlocked on the locking chain.
  final XRPCurrencies lockingChainIssue;

  /// The door account on the issuing chain. For an XRP-XRP bridge, this must be
  /// the genesis account (the account that is created when the network is first
  /// started, which contains all of the XRP).
  final String issuingChainDoor;

  /// The asset that is minted and burned on the issuing chain. For an IOU-IOU
  /// bridge, the issuer of the asset must be the door account on the issuing
  /// chain, to avoid supply issues.
  final XRPCurrencies issuingChainIssue;

  @override
  Map<String, dynamic> toJson() {
    return {
      'locking_chain_door': lockingChainDoor,
      'locking_chain_issue': lockingChainIssue.toJson(),
      'issuing_chain_door': issuingChainDoor,
      'issuing_chain_issue': issuingChainIssue.toJson()
    };
  }
}
