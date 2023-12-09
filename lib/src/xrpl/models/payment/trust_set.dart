import 'package:xrp_dart/src/xrpl/models/currencies/currencies.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// Transactions of the TrustSet type support additional values in the Flags field.
/// This enum represents those options.
enum TrustSetFlag {
  tfSetAuth(0x00010000),
  tfSetNoRipple(0x00020000),
  tfClearNoRipple(0x00040000),
  tfSetFreez(0x00100000),
  tfClearFreez(0x00200000);

  final int value;
  const TrustSetFlag(this.value);
}

/// Represents a TrustSet transaction on the XRP Ledger.
/// Creates or modifies a trust line linking two accounts.
/// See [TrustSet](https://xrpl.org/trustset.html)
class TrustSet extends XRPTransaction {
  TrustSet({
    required this.limitAmount,
    this.qualityIn,
    this.qualityOut,
    super.signingPubKey,
    super.sequence,
    super.memos,
    super.fee,
    super.lastLedgerSequence,
    required super.account,
  }) : super(transactionType: XRPLTransactionType.trustSet);
  final IssuedCurrencyAmount limitAmount;
  final int? qualityIn;
  final int? qualityOut;

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "limit_amount", limitAmount.toJson());
    addWhenNotNull(json, "quality_in", qualityIn);
    addWhenNotNull(json, "quality_out", qualityOut);
    return json;
  }

  TrustSet.fromJson(super.json)
      : limitAmount = IssuedCurrencyAmount.fromJson(json["limit_amount"]),
        qualityIn = json["quality_in"],
        qualityOut = json["quality_out"],
        super.json();
}
