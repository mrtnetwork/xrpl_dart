import 'package:xrpl_dart/src/xrpl/models/base/base.dart';
import 'package:xrpl_dart/src/xrpl/models/base/submittable_transaction.dart';
import 'package:xrpl_dart/src/xrpl/models/base/transaction_types.dart';

class MPTokenAuthorizeFlag implements FlagsInterface {
  static const MPTokenAuthorizeFlag tfMptUnAuthorize =
      MPTokenAuthorizeFlag(0x00000001);

  // The integer value associated with each flag.
  final int value;

  const MPTokenAuthorizeFlag(this.value);

  @override
  int get id => value;
}

/// The MPTokenAuthorize transaction is used to globally lock/unlock a MPTokenIssuance,
/// or lock/unlock an individual's MPToken.
class MPTokenAuthorize extends SubmittableTransaction {
  /// Identifies the MPTokenIssuance
  final String mptokenIssuanceId;

  /// An optional XRPL Address of an individual token holder balance to lock/unlock.
  /// If omitted, this transaction will apply to all any accounts holding MPTs.
  final String? holder;
  MPTokenAuthorize({
    required this.mptokenIssuanceId,
    this.holder,
    required super.account,
    super.lastLedgerSequence,
    super.flags,
    super.fee,
    super.accountTxId,
    super.delegate,
    super.memos,
    super.multisigSigners,
    super.networkId,
    super.sequence,
    super.signer,
    super.sourceTag,
    super.ticketSequance,
  }) : super(transactionType: SubmittableTransactionType.mpTokenAuthorize);

  MPTokenAuthorize.fromJson(super.json)
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
}
