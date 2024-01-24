import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents a CheckCancel [https://xrpl.org/checkcancel.html](https://xrpl.org/checkcancel.html) transaction,
/// which cancels an unredeemed Check, removing it from the ledger
/// without sending any money. The source or the destination of the check
/// can cancel a Check at any time using this transaction type. If the
/// Check has expired, any address can cancel it.
class CheckCancel extends XRPTransaction {
  /// [checkId] The ID of the Check ledger object. to cash, as a 64-character
  final String checkId;

  CheckCancel(
      {required String account,
      required this.checkId,
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
            transactionType: XRPLTransactionType.checkCancel);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {"check_id": checkId, ...super.toJson()};
  }

  CheckCancel.fromJosn(Map<String, dynamic> json)
      : checkId = json["check_id"],
        super.json(json);
}
