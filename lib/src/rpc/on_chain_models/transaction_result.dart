import 'package:blockchain_utils/utils/utils.dart';

class OnChainXRPLMemo {
  final String? memoData;
  final String? memoFormat;
  final String? memoType;

  OnChainXRPLMemo({
    required this.memoData,
    required this.memoFormat,
    required this.memoType,
  });

  factory OnChainXRPLMemo.fromJson(Map<String, dynamic> json) {
    return OnChainXRPLMemo(
      memoData: json['MemoData'],
      memoFormat: json['MemoFormat'],
      memoType: json['MemoType'],
    );
  }
}

class XRPLTxJson {
  final String account;
  final BigInt fee;
  final int flags;
  final int lastLedgerSequence;
  final List<OnChainXRPLMemo> memos;

  /// Include the List of Memos
  final int nFTokenTaxon;
  final int sequence;
  final String signingPubKey;
  final String transactionType;
  final String txnSignature;
  final String hash;

  XRPLTxJson({
    required this.account,
    required this.fee,
    required this.flags,
    required this.lastLedgerSequence,
    required this.memos,
    required this.nFTokenTaxon,
    required this.sequence,
    required this.signingPubKey,
    required this.transactionType,
    required this.txnSignature,
    required this.hash,
  });

  factory XRPLTxJson.fromJson(Map<String, dynamic> json) {
    final memosList = (json['Memos'] as List<dynamic>?)
            ?.map((memo) => OnChainXRPLMemo.fromJson(
                Map<String, dynamic>.from(memo['Memo'])))
            .toList() ??
        [];
    return XRPLTxJson(
      account: json['Account'] ?? '',
      fee: BigintUtils.tryParse(json['Fee']) ?? BigInt.zero,
      flags: IntUtils.tryParse(json['Flags']) ?? 0,
      lastLedgerSequence: IntUtils.tryParse(json['LastLedgerSequence']) ?? 0,
      memos: memosList,
      nFTokenTaxon: IntUtils.tryParse(json['NFTokenTaxon']) ?? 0,
      sequence: IntUtils.tryParse(json['Sequence']) ?? 0,
      signingPubKey: json['SigningPubKey'] ?? '',
      transactionType: json['TransactionType'] ?? '',
      txnSignature: json['TxnSignature'] ?? '',
      hash: json['hash'] ?? '',
    );
  }
}

class XRPLTransactionResult {
  final bool accepted;
  final int accountSequenceAvailable;
  final int accountSequenceNext;
  final bool applied;
  final bool broadcast;
  final String engineResult;
  final int engineResultCode;
  final String engineResultMessage;
  final bool kept;
  final int openLedgerCost;
  final bool queued;
  final String? status;
  final String txBlob;
  final XRPLTxJson txJson;
  final int validatedLedgerIndex;

  bool get isSuccess => engineResult == 'tesSUCCESS';

  XRPLTransactionResult({
    required this.accepted,
    required this.accountSequenceAvailable,
    required this.accountSequenceNext,
    required this.applied,
    required this.broadcast,
    required this.engineResult,
    required this.engineResultCode,
    required this.engineResultMessage,
    required this.kept,
    required this.openLedgerCost,
    required this.queued,
    required this.status,
    required this.txBlob,
    required this.txJson,
    required this.validatedLedgerIndex,
  });

  factory XRPLTransactionResult.fromJson(Map<String, dynamic> json) {
    return XRPLTransactionResult(
      accepted: json['accepted'] ?? false,
      accountSequenceAvailable:
          IntUtils.tryParse(json['account_sequence_available']) ?? 0,
      accountSequenceNext:
          IntUtils.tryParse(json['account_sequence_next']) ?? 0,
      applied: json['applied'] ?? false,
      broadcast: json['broadcast'] ?? false,
      engineResult: json['engine_result'] ?? '',
      engineResultCode: IntUtils.tryParse(json['engine_result_code']) ?? 0,
      engineResultMessage: json['engine_result_message'] ?? '',
      kept: json['kept'] ?? false,
      openLedgerCost: IntUtils.tryParse(json['open_ledger_cost']) ?? 0,
      queued: json['queued'] ?? false,
      status: json['status'],
      txBlob: json['tx_blob'] ?? '',
      txJson: XRPLTxJson.fromJson(json['tx_json'] ?? {}),
      validatedLedgerIndex:
          IntUtils.tryParse(json['validated_ledger_index']) ?? 0,
    );
  }
}
