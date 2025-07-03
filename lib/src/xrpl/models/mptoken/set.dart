import 'package:xrpl_dart/src/xrpl/models/base/base.dart';
import 'package:xrpl_dart/src/xrpl/models/base/submittable_transaction.dart';
import 'package:xrpl_dart/src/xrpl/models/base/transaction_types.dart';

class MPTokenIssuanceSetFlag implements FlagsInterface {
  static const MPTokenIssuanceSetFlag tfMptLock =
      MPTokenIssuanceSetFlag(0x00000001);
  static const MPTokenIssuanceSetFlag tfMptUnLock =
      MPTokenIssuanceSetFlag(0x00000002);

  // The integer value associated with each flag.
  final int value;

  const MPTokenIssuanceSetFlag(this.value);

  @override
  int get id => value;
}

/// The MPTokenIssuanceSet transaction is used to globally lock/unlock a
/// MPTokenIssuance, or lock/unlock an individual's MPToken.
class MPTokenIssuanceSet extends SubmittableTransaction {
  // The MPTokenIssuanceSet transaction is used to globally lock/unlock a
  // MPTokenIssuance, or lock/unlock an individual's MPToken.
  final String mptokenIssuanceId;

  /// An optional XRPL Address of an individual token holder balance to lock/unlock.
  /// If omitted, this transaction will apply to all any accounts holding MPTs.
  final String? holder;
  MPTokenIssuanceSet({
    required this.mptokenIssuanceId,
    this.holder,
    required super.account,
  }) : super(transactionType: SubmittableTransactionType.mpTokenIssuanceSet);

  MPTokenIssuanceSet.fromJson(super.json)
      : mptokenIssuanceId = json["mptoken_issuance_id"],
        holder = json["holder"],
        super.json();

  @override
  Map<String, dynamic> toJson() {
    return {
      "mptoken_issuance_id": mptokenIssuanceId,
      "holder": holder,
      ...super.toJson(),
    }..removeWhere((_, v) => v == null);
  }

  @override
  String? get validate {
    if (flags.contains(MPTokenIssuanceSetFlag.tfMptLock.value) &&
        flags.contains(MPTokenIssuanceSetFlag.tfMptUnLock.value)) {
      return "both `tfMptLock` and `tfMptUnLock` can't be set";
    }
    return super.validate;
  }
}
