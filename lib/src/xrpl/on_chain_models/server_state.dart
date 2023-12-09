import 'package:xrp_dart/src/number/number_parser.dart';

class XRPLedgerState {
  final XRPLedgerStateDetails state;
  final String status;

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
      initialSyncDurationUs: parseInt(json['initial_sync_duration_us']) ?? 0,
      ioLatencyMs: parseInt(json['io_latency_ms']) ?? 0,
      jqTransOverflow: parseInt(json['jq_trans_overflow']) ?? 0,
      lastClose: XRPLastClose.fromJson(json['last_close']),
      loadBase: parseInt(json['load_base']) ?? 0,
      loadFactor: parseInt(json['load_factor']) ?? 0,
      loadFactorFeeEscalation:
          parseInt(json['load_factor_fee_escalation']) ?? 0,
      loadFactorFeeQueue: parseInt(json['load_factor_fee_queue']) ?? 0,
      loadFactorFeeReference: parseInt(json['load_factor_fee_reference']) ?? 0,
      loadFactorServer: parseInt(json['load_factor_server']) ?? 0,
      peerDisconnects: parseInt(json['peer_disconnects']) ?? 0,
      peerDisconnectsResources:
          parseInt(json['peer_disconnects_resources']) ?? 0,
      peers: json['peers'],
      pubkeyNode: json['pubkey_node'],
      serverState: json['server_state'],
      serverStateDurationUs: parseInt(json['server_state_duration_us']) ?? 0,
      stateAccounting:
          XRPLedgerStateAccounting.fromJson(json['state_accounting']),
      time: json['time'],
      uptime: parseInt(json['uptime']) ?? 0,
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
      convergeTime: parseInt(json['converge_time']) ?? 0,
      proposers: parseInt(json['proposers']) ?? 0,
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
      durationUs: parseInt(json['duration_us']) ?? 0,
      transitions: parseInt(json['transitions']) ?? 0,
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
      baseFee: parseInt(json['base_fee']) ?? 0,
      closeTime: parseInt(json['close_time']) ?? 0,
      hash: json['hash'],
      reserveBase: json['reserve_base'],
      reserveInc: json['reserve_inc'],
      seq: json['seq'],
    );
  }
}
