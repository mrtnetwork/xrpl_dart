import 'package:xrpl_dart/src/number/number_parser.dart';

class TransactionData {
  final String account;
  final int fee;
  final int flags;
  final int? offerSequence;
  final int sequence;
  final String signingPubKey;
  final String transactionType;
  final String txnSignature;
  final String hash;
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
