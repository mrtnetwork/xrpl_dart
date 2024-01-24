import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents a DIDDelete transaction.
class DIDDelete extends XRPTransaction {
  DIDDelete.fromJson(Map<String, dynamic> json) : super.json(json);

  DIDDelete(
      {required String account,
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
            transactionType: XRPLTransactionType.didDelete);

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    return json;
  }
}
