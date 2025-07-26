import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents a DIDSet transaction.
class DIDSet extends SubmittableTransaction {
  DIDSet.fromJson(super.json)
      : didDocument = json['did_document'],
        data = json['data'],
        uri = json['uri'],
        super.json();
  final String? didDocument;
  final String? data;
  final String? uri;
  DIDSet({
    required super.account,
    this.data,
    this.uri,
    this.didDocument,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
    super.accountTxId,
    super.delegate,
    super.networkId,
  }) : super(transactionType: SubmittableTransactionType.didSet);

  @override
  Map<String, dynamic> toJson() {
    return {
      'did_document': didDocument,
      'data': data,
      'uri': uri,
      ...super.toJson()
    }..removeWhere((_, v) => v == null);
  }
}
