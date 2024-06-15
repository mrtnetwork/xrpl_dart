import 'package:blockchain_utils/utils/utils.dart';

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
      fee: IntUtils.tryParse(json['Fee'])!,
      flags: IntUtils.tryParse(json['Flags'])!,
      offerSequence: IntUtils.tryParse(json['OfferSequence']),
      sequence: IntUtils.tryParse(json['Sequence'])!,
      signingPubKey: json['SigningPubKey'],
      transactionType: json['TransactionType'],
      txnSignature: json['TxnSignature'],
      hash: json['hash'],
      metaData: json['metaData'],
    );
  }
}
