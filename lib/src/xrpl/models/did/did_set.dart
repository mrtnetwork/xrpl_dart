import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'package:xrpl_dart/src/crypto/crypto.dart';

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
  DIDSet({
    required String account,
    this.data,
    this.uri,
    this.didDocument,
    List<XRPLMemo>? memos = const [],
    XRPLSignature? signer,
    int? ticketSequance,
    BigInt? fee,
    int? lastLedgerSequence,
    int? sequence,
    List<XRPLSigners>? multisigSigners,
    int? flags,
    int? sourceTag,
  }) : super(
            account: account,
            fee: fee,
            lastLedgerSequence: lastLedgerSequence,
            memos: memos,
            sequence: sequence,
            multisigSigners: multisigSigners,
            sourceTag: sourceTag,
            flags: flags,
            ticketSequance: ticketSequance,
            signer: signer,
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
