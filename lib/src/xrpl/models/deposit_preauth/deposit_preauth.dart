import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// Represents a [DepositPreauth](https://xrpl.org/depositpreauth.html)
/// transaction, which gives another account pre-approval to deliver payments to
/// the sender of this transaction, if this account is using
/// [Deposit Authorization](https://xrpl.org/depositauth.html).
class DepositPreauth extends XRPTransaction {
  final String? authorize;
  final String? unauthorize;

  /// [authorize] Grant preauthorization to this address. You must provide this OR
  /// ``unauthorize`` but not both.
  ///
  /// [unauthorize] Revoke preauthorization from this address. You must provide this OR
  /// ``authorize`` but not both.
  DepositPreauth({
    required super.account,
    this.authorize,
    this.unauthorize,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  }) : super(transactionType: XRPLTransactionType.DEPOSIT_PREAUTH) {
    final err = _getError();
    assert(err == null, err);
  }
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "authorize", authorize);
    addWhenNotNull(json, "unauthorize", unauthorize);
    return json;
  }

  DepositPreauth.fromJson(Map<String, dynamic> json)
      : authorize = json["authorize"],
        unauthorize = json["unauthorize"],
        super.json(json);

  String? _getError() {
    if (authorize != null && unauthorize != null) {
      return "One of authorize and unauthorize must be set, not both.";
    }
    if (authorize == null && unauthorize == null) {
      return "One of authorize and unauthorize must be set.";
    }
    return null;
  }
}
