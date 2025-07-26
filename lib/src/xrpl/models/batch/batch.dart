import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';
import 'package:xrpl_dart/src/xrpl/exception/exceptions.dart';
import 'package:xrpl_dart/src/xrpl/models/account/signers.dart';
import 'package:xrpl_dart/src/xrpl/models/base/base.dart';
import 'package:xrpl_dart/src/xrpl/models/base/submittable_transaction.dart';
import 'package:xrpl_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrpl_dart/src/xrpl/utils/utils.dart';

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

  const BatchSigner(
      {required this.account,
      this.signingPubKey,
      this.txnSignature,
      this.signers});

  BatchSigner.fromJson(Map<String, dynamic> json)
      : account = json["batch_signer"]["account"],
        signingPubKey = json["batch_signer"]["signing_pub_key"],
        txnSignature = json["batch_signer"]["txn_signature"],
        signers = (json["batch_signer"]['signers'] as List?)
            ?.map((e) => XRPLSigners.fromJson(e))
            .toList();

  @override
  Map<String, dynamic> toJson() {
    return {
      "batch_signer": {
        'account': account,
        'signing_pub_key': signingPubKey,
        'txn_signature': txnSignature,
        'signers': signers?.map((e) => e.toJson()).toList(),
      }..removeWhere((_, v) => v == null)
    };
  }

  bool get isReady {
    final signers = this.signers;
    if (signers == null || signers.isEmpty) {
      return txnSignature != null && signingPubKey != null;
    }
    return signers.every((e) => e.isReady);
  }
}

class Batch extends SubmittableTransaction {
  final List<SubmittableTransaction> rawTransactions;
  List<BatchSigner>? _batchSigners;
  List<BatchSigner>? get batchSigners => _batchSigners;
  Batch({
    required List<SubmittableTransaction> rawTransactions,
    List<BatchSigner>? batchSigners,
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
  })  : rawTransactions = rawTransactions.immutable,
        _batchSigners = batchSigners?.immutable,
        super(transactionType: SubmittableTransactionType.batch);
  Batch.fromJson(super.json)
      : rawTransactions = (json["raw_transactions"] as List)
            .map((e) => SubmittableTransaction.fromJson(e["raw_transaction"]))
            .toImutableList,
        _batchSigners = (json["batch_signers"] as List?)
            ?.map((e) => BatchSigner.fromJson(e))
            .toImutableList,
        super.json();
  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "raw_transactions":
          rawTransactions.map((e) => {"raw_transaction": e.toJson()}).toList(),
      "batch_signers": _batchSigners?.map((e) => e.toJson()).toList()
    }..removeWhere((_, v) => v == null);
  }

  void setBatchSignure(List<BatchSigner> signatures) {
    _batchSigners = signatures;
  }

  List<int> toBatchSigningBloblBytes() {
    final batchTx = cast<Batch>();
    for (final i in batchTx.rawTransactions) {
      if (i.fee != BigInt.zero) {
        throw XRPLTransactionException(
            "Inner transactions must have a fee of 0.");
      }
      final signer = i.signer;
      if (signer != null && (signer.hasSignature || signer.hasSigningPubKey)) {
        throw XRPLTransactionException(
            "Inner transactions must not include a signer (signingPubKey, signature).");
      }
      if (i.isMultisig) {
        throw XRPLTransactionException(
            "Inner transactions must not include multisig signers.");
      }
      if (i.sequence == null && i.ticketSequance == null) {
        throw XRPLTransactionException(
            "Either 'sequence' or 'ticketSequence' must be included in an inner transaction.");
      }
      if (i.lastLedgerSequence != null) {
        throw XRPLTransactionException(
            "Inner transactions must not include last ledger sequence.");
      }
    }
    final flag = flags.fold<int>(0, (p, c) => p | c);
    final flagBytes = UInt32.fromValue(flag).toBytes();
    final length = UInt32.fromValue(batchTx.rawTransactions.length).toBytes();
    final txIds = batchTx.rawTransactions.expand(
        (e) => Hash256.fromValue(e.getHash(forBatchTx: true)).toBytes());
    return [...TransactionUtils.batchPrefix, ...flagBytes, ...length, ...txIds];
  }
}
