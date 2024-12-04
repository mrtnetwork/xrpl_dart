import 'dart:math' as math;
import 'package:blockchain_utils/utils/utils.dart';

enum XrplFeeType { open, minimum, dynamic }

class LedgerInfo {
  final int currentLedgerSize;
  final int currentQueueSize;
  final Drops drops;
  final int expectedLedgerSize;
  final int ledgerCurrentIndex;
  final Levels levels;
  final int maxQueueSize;
  final String? status;

  int getFeeType({XrplFeeType type = XrplFeeType.open}) {
    switch (type) {
      case XrplFeeType.open:
        return drops.openLedgerFee;
      case XrplFeeType.dynamic:
        return calculateFeeDynamically();
      case XrplFeeType.minimum:
        return drops.minimumFee;
    }
  }

  int calculateFeeDynamically() {
    final double queuePct = currentQueueSize / maxQueueSize;
    final int feeLow =
        (drops.minimumFee * 1.5).round().clamp(drops.minimumFee * 10, 1000);

    int possibleFeeMedium;
    if (queuePct > 0.1) {
      possibleFeeMedium =
          ((drops.minimumFee + drops.medianFee + drops.openLedgerFee) / 3)
              .round();
    } else if (queuePct == 0) {
      possibleFeeMedium = math.max(10 * drops.minimumFee, drops.openLedgerFee);
    } else {
      possibleFeeMedium = math.max(10 * drops.minimumFee,
          ((drops.minimumFee + drops.medianFee) / 2).round());
    }

    final int feeMedium =
        (possibleFeeMedium * 15).round().clamp(possibleFeeMedium, 10000);

    final int feeHigh = (math
            .max(10 * drops.minimumFee,
                (math.max(drops.medianFee, drops.openLedgerFee) * 1.1))
            .round())
        .clamp(10 * drops.minimumFee, 100000);

    int fee;
    if (queuePct == 0) {
      fee = feeLow;
    } else if (queuePct > 0 && queuePct < 1) {
      fee = feeMedium;
    } else {
      fee = feeHigh;
    }

    return fee;
  }

  LedgerInfo({
    required this.currentLedgerSize,
    required this.currentQueueSize,
    required this.drops,
    required this.expectedLedgerSize,
    required this.ledgerCurrentIndex,
    required this.levels,
    required this.maxQueueSize,
    required this.status,
  });

  factory LedgerInfo.fromJson(Map<String, dynamic> json) {
    return LedgerInfo(
      currentLedgerSize: IntUtils.tryParse(json['current_ledger_size'])!,
      currentQueueSize: IntUtils.tryParse(json['current_queue_size'])!,
      drops: Drops.fromJson(json['drops'] ?? {}),
      expectedLedgerSize: IntUtils.tryParse(json['expected_ledger_size'])!,
      ledgerCurrentIndex: IntUtils.tryParse(json['ledger_current_index'])!,
      levels: Levels.fromJson(json['levels'] ?? {}),
      maxQueueSize: IntUtils.tryParse(json['max_queue_size'])!,
      status: json['status'],
    );
  }
}

class Drops {
  final int baseFee;
  final int medianFee;
  final int minimumFee;
  final int openLedgerFee;

  Drops({
    required this.baseFee,
    required this.medianFee,
    required this.minimumFee,
    required this.openLedgerFee,
  });

  factory Drops.fromJson(Map<String, dynamic> json) {
    return Drops(
      baseFee: IntUtils.tryParse(json['base_fee'])!,
      medianFee: IntUtils.tryParse(json['median_fee'])!,
      minimumFee: IntUtils.tryParse(json['minimum_fee'])!,
      openLedgerFee: IntUtils.tryParse(json['open_ledger_fee'])!,
    );
  }
}

class Levels {
  final int medianLevel;
  final int minimumLevel;
  final int openLedgerLevel;
  final int referenceLevel;

  Levels({
    required this.medianLevel,
    required this.minimumLevel,
    required this.openLedgerLevel,
    required this.referenceLevel,
  });

  factory Levels.fromJson(Map<String, dynamic> json) {
    return Levels(
      medianLevel: IntUtils.tryParse(json['median_level'])!,
      minimumLevel: IntUtils.tryParse(json['minimum_level'])!,
      openLedgerLevel: IntUtils.tryParse(json['open_ledger_level'])!,
      referenceLevel: IntUtils.tryParse(json['reference_level'])!,
    );
  }
}
