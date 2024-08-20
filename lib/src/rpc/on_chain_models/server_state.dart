import 'package:blockchain_utils/utils/utils.dart';

class XRPLedgerState {
  final XRPLedgerStateDetails state;
  final String? status;

  XRPLedgerState({
    required this.state,
    required this.status,
  });

  factory XRPLedgerState.fromJson(Map<String, dynamic> json) {
    return XRPLedgerState(
      state: XRPLedgerStateDetails.fromJson(json['state']),
      status: json['status'],
    );
  }
}

class XRPLedgerStateDetails {
  final String buildVersion;
  final String completeLedgers;
  final int initialSyncDurationUs;
  final int ioLatencyMs;
  final int jqTransOverflow;
  final XRPLastClose lastClose;
  final int loadBase;
  final int loadFactor;
  final int loadFactorFeeEscalation;
  final int loadFactorFeeQueue;
  final int loadFactorFeeReference;
  final int loadFactorServer;
  final int peerDisconnects;
  final int peerDisconnectsResources;
  final int peers;

  final String pubkeyNode;
  final String serverState;
  final int serverStateDurationUs;
  final XRPLedgerStateAccounting stateAccounting;
  final String time;
  final int uptime;
  final XRPLedgerValidatedLedger validatedLedger;
  final int validationQuorum;

  XRPLedgerStateDetails({
    required this.buildVersion,
    required this.completeLedgers,
    required this.initialSyncDurationUs,
    required this.ioLatencyMs,
    required this.jqTransOverflow,
    required this.lastClose,
    required this.loadBase,
    required this.loadFactor,
    required this.loadFactorFeeEscalation,
    required this.loadFactorFeeQueue,
    required this.loadFactorFeeReference,
    required this.loadFactorServer,
    required this.peerDisconnects,
    required this.peerDisconnectsResources,
    required this.peers,
    required this.pubkeyNode,
    required this.serverState,
    required this.serverStateDurationUs,
    required this.stateAccounting,
    required this.time,
    required this.uptime,
    required this.validatedLedger,
    required this.validationQuorum,
  });

  factory XRPLedgerStateDetails.fromJson(Map<String, dynamic> json) {
    return XRPLedgerStateDetails(
      buildVersion: json['build_version'],
      completeLedgers: json['complete_ledgers'],
      initialSyncDurationUs:
          IntUtils.tryParse(json['initial_sync_duration_us']) ?? 0,
      ioLatencyMs: IntUtils.tryParse(json['io_latency_ms']) ?? 0,
      jqTransOverflow: IntUtils.tryParse(json['jq_trans_overflow']) ?? 0,
      lastClose: XRPLastClose.fromJson(json['last_close']),
      loadBase: IntUtils.tryParse(json['load_base']) ?? 0,
      loadFactor: IntUtils.tryParse(json['load_factor']) ?? 0,
      loadFactorFeeEscalation:
          IntUtils.tryParse(json['load_factor_fee_escalation']) ?? 0,
      loadFactorFeeQueue: IntUtils.tryParse(json['load_factor_fee_queue']) ?? 0,
      loadFactorFeeReference:
          IntUtils.tryParse(json['load_factor_fee_reference']) ?? 0,
      loadFactorServer: IntUtils.tryParse(json['load_factor_server']) ?? 0,
      peerDisconnects: IntUtils.tryParse(json['peer_disconnects']) ?? 0,
      peerDisconnectsResources:
          IntUtils.tryParse(json['peer_disconnects_resources']) ?? 0,
      peers: json['peers'],
      pubkeyNode: json['pubkey_node'],
      serverState: json['server_state'],
      serverStateDurationUs:
          IntUtils.tryParse(json['server_state_duration_us']) ?? 0,
      stateAccounting:
          XRPLedgerStateAccounting.fromJson(json['state_accounting']),
      time: json['time'],
      uptime: IntUtils.tryParse(json['uptime']) ?? 0,
      validatedLedger:
          XRPLedgerValidatedLedger.fromJson(json['validated_ledger']),
      validationQuorum: json['validation_quorum'],
    );
  }
}

class XRPLastClose {
  final int convergeTime;
  final int proposers;

  XRPLastClose({
    required this.convergeTime,
    required this.proposers,
  });

  factory XRPLastClose.fromJson(Map<String, dynamic> json) {
    return XRPLastClose(
      convergeTime: IntUtils.tryParse(json['converge_time']) ?? 0,
      proposers: IntUtils.tryParse(json['proposers']) ?? 0,
    );
  }
}

class XRPLedgerStateAccounting {
  final XRPLedgerStateAccountingDuration connected;
  final XRPLedgerStateAccountingDuration disconnected;
  final XRPLedgerStateAccountingDuration full;
  final XRPLedgerStateAccountingDuration syncing;
  final XRPLedgerStateAccountingDuration tracking;

  XRPLedgerStateAccounting({
    required this.connected,
    required this.disconnected,
    required this.full,
    required this.syncing,
    required this.tracking,
  });

  factory XRPLedgerStateAccounting.fromJson(Map<String, dynamic> json) {
    return XRPLedgerStateAccounting(
      connected: XRPLedgerStateAccountingDuration.fromJson(json['connected']),
      disconnected:
          XRPLedgerStateAccountingDuration.fromJson(json['disconnected']),
      full: XRPLedgerStateAccountingDuration.fromJson(json['full']),
      syncing: XRPLedgerStateAccountingDuration.fromJson(json['syncing']),
      tracking: XRPLedgerStateAccountingDuration.fromJson(json['tracking']),
    );
  }
}

class XRPLedgerStateAccountingDuration {
  final int durationUs;
  final int transitions;

  XRPLedgerStateAccountingDuration({
    required this.durationUs,
    required this.transitions,
  });

  factory XRPLedgerStateAccountingDuration.fromJson(Map<String, dynamic> json) {
    return XRPLedgerStateAccountingDuration(
      durationUs: IntUtils.tryParse(json['duration_us']) ?? 0,
      transitions: IntUtils.tryParse(json['transitions']) ?? 0,
    );
  }
}

class XRPLedgerValidatedLedger {
  final int baseFee;
  final int closeTime;
  final String hash;
  final int reserveBase;
  final int reserveInc;
  final int seq;

  XRPLedgerValidatedLedger({
    required this.baseFee,
    required this.closeTime,
    required this.hash,
    required this.reserveBase,
    required this.reserveInc,
    required this.seq,
  });

  factory XRPLedgerValidatedLedger.fromJson(Map<String, dynamic> json) {
    return XRPLedgerValidatedLedger(
      baseFee: IntUtils.tryParse(json['base_fee']) ?? 0,
      closeTime: IntUtils.tryParse(json['close_time']) ?? 0,
      hash: json['hash'],
      reserveBase: json['reserve_base'],
      reserveInc: json['reserve_inc'],
      seq: json['seq'],
    );
  }
}
