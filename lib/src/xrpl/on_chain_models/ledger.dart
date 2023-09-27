// ignore_for_file: constant_identifier_names

import 'package:xrp_dart/src/formating/bytes_num_formating.dart';

import 'on_chain_transaction.dart';

enum LedgerEntryType {
  ACCOUNT("account"),
  AMENDMENTS("amendments"),
  CHECK("check"),
  DEPOSIT_PREAUTH("deposit_preauth"),
  DIRECTORY("directory"),
  ESCROW("escrow"),
  FEE("fee"),
  HASHES("hashes"),
  OFFER("offer"),
  PAYMENT_CHANNEL("payment_channel"),
  SIGNER_LIST("signer_list"),
  STATE("state"),
  TICKET("ticket"),
  NFT_OFFER("nft_offer");

  final String value;
  const LedgerEntryType(this.value);
}

class LedgerData {
  String accountHash;
  int closeFlags;
  int closeTime;
  String closeTimeHuman;
  int closeTimeResolution;
  bool closed;

  /// String hash;
  String ledgerHash;
  int ledgerIndex;
  int parentCloseTime;
  String parentHash;
  int? seqNum;
  BigInt totalCoins;
  final List<TransactionData> transactions;

  String transactionHash;

  LedgerData(
      {required this.accountHash,
      required this.closeFlags,
      required this.closeTime,
      required this.closeTimeHuman,
      required this.closeTimeResolution,
      required this.closed,
      required this.ledgerHash,
      required this.ledgerIndex,
      required this.parentCloseTime,
      required this.parentHash,
      required this.seqNum,
      required this.totalCoins,
      required this.transactionHash,
      required this.transactions});

  factory LedgerData.fromJson(Map<String, dynamic> json) {
    return LedgerData(
        accountHash: json['ledger']['account_hash'],
        closeFlags: parseInt(json['ledger']['close_flags'])!,
        closeTime: parseInt(json['ledger']['close_time'])!,
        closeTimeHuman: json['ledger']['close_time_human'],
        closeTimeResolution: parseInt(json['ledger']['close_time_resolution'])!,
        closed: json['ledger']['closed'],
        ledgerHash: json['ledger']['ledger_hash'],
        ledgerIndex: parseInt(json['ledger']['ledger_index'])!,
        parentCloseTime: parseInt(json['ledger']['parent_close_time'])!,
        parentHash: json['ledger']['parent_hash'],
        seqNum: parseInt(json['ledger']['seqNum']),
        totalCoins: parseBigInt(json['ledger']['total_coins'])!,
        transactionHash: json['ledger']['transaction_hash'],
        transactions: (json['ledger']["transactions"] as List?)
                ?.map((e) => TransactionData.fromJson(e))
                .toList() ??
            <TransactionData>[]);
  }
}
