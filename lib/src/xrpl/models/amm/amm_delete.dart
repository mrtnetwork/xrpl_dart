import 'package:xrp_dart/src/xrpl/models/currencies/currencies.dart';
import 'package:xrp_dart/src/xrpl/models/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

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
  /// [asset2] The definition for the other asset in the AMM's pool
  AMMDelete({
    required super.account,
    required this.asset,
    required this.asset2,
    super.memos,
    super.ticketSequance,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  })  : assert(() {
          if (asset is IssuedCurrencyAmount || asset2 is IssuedCurrencyAmount) {
            return false;
          }
          return true;
        }(), "use IssuedCurrency instead of IssuedCurrencyAmount"),
        super(transactionType: XRPLTransactionType.AMM_DELETE);
  final XRPCurrencies asset;
  final XRPCurrencies asset2;
  AMMDelete.fromJson(Map<String, dynamic> json)
      : asset = XRPCurrencies.fromJson(json["asset"]),
        asset2 = XRPCurrencies.fromJson(json["asset2"]),
        super.json(json);

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "asset", asset.toJson());
    addWhenNotNull(json, "asset2", asset2.toJson());
    return json;
  }
}
