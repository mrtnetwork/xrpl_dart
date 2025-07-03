import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

class BatchFlag {
  static const BatchFlag tfAllOrNothing = BatchFlag._(0x00010000);

  static const BatchFlag tfOnlyOne = BatchFlag._(0x00020000);

  static const BatchFlag tfUntilFailure = BatchFlag._(0x00040000);

  static const BatchFlag tfIndependent = BatchFlag._(0x00080000);

  final int value;

  const BatchFlag._(this.value);
}

class BatchSigner extends XRPLBase {
  final String account;
  final String? signingPubKey;
  final String? txnSignature;
  final List<XRPLSigners>? signers;

  const BatchSigner({
    required this.account,
    this.signingPubKey,
    this.txnSignature,
    this.signers,
  });

  BatchSigner.fromJson(Map<String, dynamic> json)
      : account = json["batch_signers"]["account"],
        signingPubKey = json["batch_signers"]["signing_pub_key"],
        txnSignature = json["batch_signers"]["txn_signature"],
        signers = (json["batch_signers"]['signers'] as List?)
            ?.map((e) => XRPLSigners.fromJson(e))
            .toList();

  @override
  Map<String, dynamic> toJson() {
    return {
      "batch_signers": {
        'account': account,
        'signing_pub_key': signingPubKey,
        'txn_signature': txnSignature,
        'signers': signers?.map((e) => e.toJson()).toList(),
      }
    };
  }
}

class Batch extends SubmittableTransaction {
  final List<SubmittableTransaction> rawTransactions;
  final List<BatchSigner>? batchSigners;

  Batch(
      {required List<SubmittableTransaction> rawTransactions,
      List<BatchSigner>? batchSigners,
      required super.account})
      : rawTransactions = rawTransactions.immutable,
        batchSigners = batchSigners?.immutable,
        super(transactionType: SubmittableTransactionType.batch);
  Batch.fromJson(super.json)
      : rawTransactions = (json["raw_transactions"] as List)
            .map((e) => SubmittableTransaction.fromJson(e["raw_transaction"]))
            .toImutableList,
        batchSigners = (json["batch_signers"] as List?)
            ?.map((e) => BatchSigner.fromJson(e))
            .toImutableList,
        super.json();
  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "raw_transactions":
          rawTransactions.map((e) => {"raw_transaction": e.toJson()}).toList(),
      "batch_signers": batchSigners?.map((e) => e.toJson()).toList()
    }..removeWhere((_, v) => v == null);
  }
}
