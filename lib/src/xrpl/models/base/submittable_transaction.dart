import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/xrpl/address/xrpl.dart';
import 'package:xrpl_dart/src/xrpl/exception/exceptions.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'package:xrpl_dart/src/crypto/crypto.dart';
import 'package:xrpl_dart/src/xrpl/utils/utils.dart';

/// The base class for all transaction types
/// [https://xrpl.org/transaction-types.html](https://xrpl.org/transaction-types.html). Represents fields common to all
/// transaction types [https://xrpl.org/transaction-common-fields.html](https://xrpl.org/transaction-common-fields.html).
class SubmittableTransaction extends BaseTransaction {
  @override
  BigInt? get fee => _fee;
  BigInt? _fee;

  @override
  int? get sequence => _sequence;
  int? _sequence;

  int? _lastLedgerSequence;

  @override
  int? get lastLedgerSequence => _lastLedgerSequence;

  List<XRPLSigners> _multisigSigners;
  @override
  List<XRPLSigners> get multisigSigners => _multisigSigners;

  @override
  XRPLSignature? get signer => _signer;
  XRPLSignature? _signer;

  int? _networkId;

  @override
  int? get networkId => _networkId;
  @override
  String? get validate => null;
  @override
  final SubmittableTransactionType transactionType;

  SubmittableTransaction(
      {required super.account,
      BigInt? fee,
      int? sequence,
      super.accountTxId,
      List<int>? flags,
      int? lastLedgerSequence,
      List<XRPLMemo>? memos = const [],
      List<XRPLSigners>? multisigSigners,
      XRPLSignature? signer,
      super.sourceTag,
      super.ticketSequance,
      int? networkId,
      super.delegate,
      required this.transactionType})
      : _multisigSigners =
            List<XRPLSigners>.unmodifiable(multisigSigners ?? []),
        _signer = signer,
        _fee = fee,
        _sequence = sequence,
        _lastLedgerSequence = lastLedgerSequence,
        _networkId = networkId,
        super(flags: flags = (flags ?? []).immutable, memos: memos ?? []) {
    if (_multisigSigners.isNotEmpty && _signer != null) {
      throw const XRPLTransactionException(
          'Utilize multisigSigners for multisig transactions, or signer for single-signature transactions.');
    }
  }
  SubmittableTransaction.json(super.json)
      : _lastLedgerSequence = json['last_ledger_sequence'],
        _sequence = json['sequence'],
        _signer = XRPLSignature.fromJson(json),
        _fee = BigintUtils.tryParse(json['fee']),
        _networkId = json['network_id'],
        transactionType =
            SubmittableTransactionType.fromValue(json['transaction_type']),
        _multisigSigners =
            ((json['signers'] as List?)?.map((e) => XRPLSigners.fromJson(e)) ??
                    [])
                .toImutableList,
        super.json();
  factory SubmittableTransaction.fromBytes(List<int> txBlob) {
    final tx = BaseTransaction.fromBlobBytes(txBlob);
    return tx.cast<SubmittableTransaction>();
  }
  factory SubmittableTransaction.fromBlob(String hexBlob) {
    final tx = BaseTransaction.fromBlob(hexBlob);
    return tx.cast<SubmittableTransaction>();
  }
  factory SubmittableTransaction.fromXrpl(Map<String, dynamic> json) {
    final formatJson = TransactionUtils.formattedDict(json);
    return SubmittableTransaction._findTx(formatJson);
  }
  factory SubmittableTransaction.fromJson(Map<String, dynamic> json) {
    return SubmittableTransaction._findTx(json);
  }
  factory SubmittableTransaction._findTx(Map<String, dynamic> json) {
    final tx = BaseTransaction.fromJson(json);
    return tx.cast<SubmittableTransaction>();
  }
  SubmittableTransaction copyWith({
    String? account,
    BigInt? fee,
    int? sequence,
    String? accountTxId,
    List<int>? flags,
    int? lastLedgerSequence,
    List<XRPLMemo>? memos,
    List<XRPLSigners>? multisigSigners,
    XRPLSignature? signer,
    int? sourceTag,
    int? ticketSequance,
    int? networkId,
    SubmittableTransactionType? transactionType,
  }) {
    return SubmittableTransaction(
      account: account ?? this.account,
      fee: fee ?? this.fee,
      sequence: sequence ?? this.sequence,
      accountTxId: accountTxId ?? this.accountTxId,
      flags: flags ?? this.flags,
      lastLedgerSequence: lastLedgerSequence ?? this.lastLedgerSequence,
      memos: memos ?? this.memos,
      multisigSigners: multisigSigners ?? this.multisigSigners,
      signer: signer ?? this.signer,
      sourceTag: sourceTag ?? this.sourceTag,
      ticketSequance: ticketSequance ?? this.ticketSequance,
      networkId: networkId ?? this.networkId,
      transactionType: transactionType ?? this.transactionType,
    );
  }

  void setNetworkId(int? network) {
    _networkId = network;
  }

  void setSequence(int? newSequance) {
    _sequence = newSequance;
  }

  void setLastLedgerSequence(int? newSequance) {
    _lastLedgerSequence = newSequance;
  }

  void setFee(BigInt? newFee) {
    _fee = newFee;
  }

  void setSignature(XRPLSignature? signature) {
    if (isMultisig) {
      throw const XRPLTransactionException(
          'use setMultiSigSignature method for multi-signature transactions');
    }
    _signer = signature;
  }

  void setMultiSigSignature(List<XRPLSigners> sigs) {
    if (_signer != null) {
      throw const XRPLTransactionException(
          'Please avoid setting setMultiSigSignature for non-multi-sig transactions');
    }
    _multisigSigners = List<XRPLSigners>.unmodifiable(sigs
      ..sort((a, b) {
        final addressA = XRPAddress(a.account).toBytes();
        final addressB = XRPAddress(b.account).toBytes();
        return BytesUtils.compareBytes(addressA, addressB);
      }));
  }

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'account': account,
      if (flags.isNotEmpty) 'flags': flags.fold<int>(0, (p, c) => p | c),
      'signing_pub_key': signer?.signingPubKey ?? '',
      'last_ledger_sequence': lastLedgerSequence,
      'sequence': sequence,
      'txn_signature': signer?.signature,
      'fee': fee?.toString(),
      'transaction_type': transactionType.value,
      'network_id': networkId,
      'ticket_sequence': ticketSequance,
      'source_tag': sourceTag,
      'account_txn_id': accountTxId,
      'signers': null,
      'memos': (memos.isEmpty) ? null : memos.map((e) => e.toJson()).toList()
    };
    if (_multisigSigners.isNotEmpty) {
      final allReady = multisigSigners.every((element) => element.isReady);
      if (allReady) {
        json['signers'] = _multisigSigners.map((e) => e.toJson()).toList();
      }
    }

    return json..removeWhere((_, v) => v == null);
  }

  bool isSigned() {
    if (transactionType == SubmittableTransactionType.batch) {
      final batchTx = cast<Batch>();
      final signers = batchTx.batchSigners;
      if (signers == null) return false;
      final currentSigners = {
        XRPAddress(account).address,
        ...batchTx.rawTransactions.map((e) => XRPAddress(e.account).address)
      };
      if (currentSigners.length != signers.length) {
        return false;
      }
      return signers.any((e) => e.isReady);
    }
    if (_multisigSigners.isNotEmpty) {
      for (final signer in _multisigSigners) {
        if (!signer.isReady) {
          return false;
        }
      }
      return true;
    }

    return signer?.isReady ?? false;
  }
}
