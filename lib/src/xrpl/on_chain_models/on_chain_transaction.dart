import 'package:xrp_dart/src/formating/bytes_num_formating.dart';

class TransactionData {
  String account;
  int fee;
  int flags;
  int? offerSequence;
  int sequence;
  String signingPubKey;
  String transactionType;
  String txnSignature;
  String hash;
  Map<String, dynamic> metaData;

  TransactionData({
    required this.account,
    required this.fee,
    required this.flags,
    required this.offerSequence,
    required this.sequence,
    required this.signingPubKey,
    required this.transactionType,
    required this.txnSignature,
    required this.hash,
    required this.metaData,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      account: json['Account'],
      fee: parseInt(json['Fee'])!,
      flags: parseInt(json['Flags'])!,
      offerSequence: parseInt(json['OfferSequence']),
      sequence: parseInt(json['Sequence'])!,
      signingPubKey: json['SigningPubKey'],
      transactionType: json['TransactionType'],
      txnSignature: json['TxnSignature'],
      hash: json['hash'],
      metaData: json['metaData'],
    );
  }
}
