import 'package:xrpl_dart/src/xrpl/models/base/pseudo_transaction.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

abstract class SetFee extends PseudoTransaction {
  SetFee({
    required super.account,
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
  }) : super(transactionType: PseudoTransactionType.setFee);

  SetFee._json(super.json) : super.json();
  factory SetFee.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("base_fee_drops")) {
      return SetFeePostAmendment.fromJson(json);
    }
    return SetFeePreAmendment.fromJson(json);
  }
}

class SetFeePostAmendment extends SetFee {
  /// The charge, in drops of XRP, for the reference transaction.
  /// (This is the transaction cost before scaling for load.)
  final String baseFeeDrops;

  /// The base reserve, in drops
  final String reserveBaseDrops;

  /// The incremental reserve, in drops
  final String reserveIncrementDrops;

  SetFeePostAmendment({
    required super.account,
    required this.baseFeeDrops,
    required this.reserveBaseDrops,
    required this.reserveIncrementDrops,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  });

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'base_fee_drops': baseFeeDrops,
      'reserve_base_drops': reserveBaseDrops,
      'reserve_increment_drops': reserveBaseDrops,
      ...super.toJson()
    }..removeWhere((_, v) => v == null);
  }

  SetFeePostAmendment.fromJson(super.json)
      : baseFeeDrops = json["base_fee_drops"],
        reserveBaseDrops = json["reserve_base_drops"],
        reserveIncrementDrops = json["reserve_increment_drops"],
        super._json();
}

class SetFeePreAmendment extends SetFee {
  final String baseFee;
  final int referenceFeeUnits;
  final int reserveBase;
  final int reserveIncrement;

  SetFeePreAmendment({
    required super.account,
    required this.baseFee,
    required this.referenceFeeUnits,
    required this.reserveBase,
    required this.reserveIncrement,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  });

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'base_fee': baseFee,
      'reference_fee_units': referenceFeeUnits,
      'reserve_base': reserveBase,
      'reserve_increment': reserveIncrement,
      ...super.toJson()
    }..removeWhere((_, v) => v == null);
  }

  SetFeePreAmendment.fromJson(super.json)
      : baseFee = json["base_fee"],
        referenceFeeUnits = json["reference_fee_units"],
        reserveBase = json["reserve_base"],
        reserveIncrement = json["reserve_increment"],
        super._json();
}
