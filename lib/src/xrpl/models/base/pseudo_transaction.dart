import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'package:xrpl_dart/src/crypto/crypto.dart';

/// The base class for all transaction types
/// [https://xrpl.org/transaction-types.html](https://xrpl.org/transaction-types.html). Represents fields common to all
/// transaction types [https://xrpl.org/transaction-common-fields.html](https://xrpl.org/transaction-common-fields.html).
class PseudoTransaction extends BaseTransaction {
  @override
  final BigInt? fee;

  /// [sequence] The sequence number of the transaction. Must match the
  /// sending account's next unused sequence number
  @override
  final int? sequence;

  /// [lastLedgerSequence] The highest ledger index this transaction can appear in
  @override
  final int? lastLedgerSequence;

  /// [multisigSigners] Signing data authorizing a multi-signed transaction. Added during multi-signing
  @override
  final List<XRPLSigners> multisigSigners;

  /// [signer] Signing data authorizing a signle-signed transaction.
  @override
  final XRPLSignature? signer;

  /// [networkId] The network id of the transaction.
  @override
  final int? networkId;

  @override
  String? get validate => null;

  @override
  final PseudoTransactionType transactionType;

  PseudoTransaction(
      {required super.account,
      this.fee,
      this.sequence,
      super.accountTxId,
      List<int>? flags,
      this.lastLedgerSequence,
      List<XRPLMemo>? memos = const [],
      List<XRPLSigners>? multisigSigners,
      this.signer,
      super.sourceTag,
      super.ticketSequance,
      this.networkId,
      super.delegate,
      required this.transactionType})
      : multisigSigners = List<XRPLSigners>.unmodifiable(multisigSigners ?? []),
        super(flags: flags = (flags ?? []).immutable, memos: memos ?? []);
  PseudoTransaction copyWith({
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
    PseudoTransactionType? transactionType,
  }) {
    return PseudoTransaction(
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

  PseudoTransaction.json(super.json)
      : lastLedgerSequence = json['last_ledger_sequence'],
        sequence = json['sequence'],
        signer = XRPLSignature.fromJson(json),
        fee = BigintUtils.tryParse(json['fee']),
        networkId = json['network_id'],
        transactionType =
            PseudoTransactionType.fromValue(json['transaction_type']),
        multisigSigners =
            ((json['signers'] as List?)?.map((e) => XRPLSigners.fromJson(e)) ??
                    [])
                .toImutableList,
        super.json();

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
    if (multisigSigners.isNotEmpty) {
      final allReady = multisigSigners.every((element) => element.isReady);
      if (allReady) {
        json['signers'] = multisigSigners.map((e) => e.toJson()).toList();
      }
    }

    return json..removeWhere((_, v) => v == null);
  }

  // factory PseudoTransaction.fromBlob(String hexBlob) {
  //   List<int> toBytes = BytesUtils.fromHexString(hexBlob);
  //   final prefix = toBytes.sublist(0, 4);
  //   if (BytesUtils.bytesEqual(
  //           prefix, TransactionUtils.transactionMultisigPrefix) ||
  //       BytesUtils.bytesEqual(
  //           prefix, TransactionUtils.transactionSignaturePrefix)) {
  //     toBytes = toBytes.sublist(4);
  //     if (BytesUtils.bytesEqual(
  //         prefix, TransactionUtils.transactionMultisigPrefix)) {
  //       toBytes = toBytes.sublist(0, toBytes.length - Hash160.lengthBytes);
  //     }
  //   }
  //   final data = STObject(toBytes);

  //   final toJson = data.toJson();

  //   final formatJson = TransactionUtils.formattedDict(toJson);
  //   return _findTransactionObject(formatJson);
  // }
  // factory PseudoTransaction.fromXrpl(Map<String, dynamic> json) {
  //   final formatJson = TransactionUtils.formattedDict(json);
  //   return _findTransactionObject(formatJson);
  // }
  // factory PseudoTransaction.fromJson(Map<String, dynamic> json) {
  //   return _findTransactionObject(json);
  // }
}
