import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Delete an empty Automated Market Maker (AMM) instance that could not be fully
/// deleted automatically.
///
/// Tip: The AMMWithdraw transaction automatically tries to delete an AMM, along with
/// associated ledger entries such as empty trust lines, if it withdrew all the assets
/// from the AMM's pool. However, if there are too many trust lines to the AMM account
/// to remove in one transaction, it may stop before fully removing the AMM. Similarly,
/// an AMMDelete transaction removes up to a maximum number of trust lines; in extreme
/// cases, it may take several AMMDelete transactions to fully delete the trust lines
/// and the associated AMM. In all cases, the AMM ledger entry and AMM account are
/// deleted by the last such transaction.
class AMMDelete extends XRPTransaction {
  /// [asset] The definition for one of the assets in the AMM's pool
  final XRPCurrencies asset;

  /// [asset2] The definition for the other asset in the AMM's pool
  final XRPCurrencies asset2;

  AMMDelete({
    required super.account,
    required this.asset,
    required this.asset2,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: XRPLTransactionType.ammDelete);

  AMMDelete.fromJson(super.json)
      : asset = XRPCurrencies.fromJson(json['asset']),
        asset2 = XRPCurrencies.fromJson(json['asset2']),
        super.json();

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'asset': asset.toJson(),
      'asset2': asset2.toJson(),
      ...super.toJson()
    };
  }
}
