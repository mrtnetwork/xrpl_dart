import 'package:xrp_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents a DIDSet transaction.
class DIDSet extends XRPTransaction {
  DIDSet.fromJson(Map<String, dynamic> json)
      : didDocument = json["did_document"],
        data = json["data"],
        uri = json["uri"],
        super.json(json);
  final String? didDocument;
  final String? data;
  final String? uri;
  DIDSet(
      {required String account,
      this.data,
      this.uri,
      this.didDocument,
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
            transactionType: XRPLTransactionType.didSet);

  @override
  Map<String, dynamic> toJson() {
    return {
      "did_document": didDocument,
      "data": data,
      "uri": uri,
      ...super.toJson()
    };
  }
}
