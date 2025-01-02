import 'package:blockchain_utils/utils/utils.dart';

class ServerInfo {
  final Info info;
  final String? status;

  ServerInfo({
    required this.info,
    required this.status,
  });

  factory ServerInfo.fromJson(Map<String, dynamic> json) {
    return ServerInfo(
      info: Info.fromJson(json['info']),
      status: json['status'],
    );
  }
}

class Info {
  final String? buildVersion;
  final String completeLedgers;
  final String hostId;
  final int initialSyncDurationUs;
  final int ioLatencyMs;
  final int jqTransOverflow;
  final LastClose lastClose;
  final int loadFactor;
  final int? networkId;
  final int peerDisconnects;
  final int peerDisconnectsResources;
  final int peers;
  final String pubkeyNode;
  final String serverState;
  final int serverStateDurationUs;
  final StateAccounting stateAccounting;
  final String time;
  final int uptime;
  final ValidatedLedger validatedLedger;
  final int validationQuorum;

  Info({
    required this.buildVersion,
    required this.completeLedgers,
    required this.hostId,
    required this.initialSyncDurationUs,
    required this.ioLatencyMs,
    required this.jqTransOverflow,
    required this.lastClose,
    required this.loadFactor,
    required this.networkId,
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

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      buildVersion: json['build_version'],
      completeLedgers: json['complete_ledgers'],
      hostId: json['hostid'],
      initialSyncDurationUs:
          IntUtils.tryParse(json['initial_sync_duration_us'])!,
      ioLatencyMs: IntUtils.tryParse(json['io_latency_ms'])!,
      jqTransOverflow: IntUtils.tryParse(json['jq_trans_overflow'])!,
      lastClose: LastClose.fromJson(json['last_close']),
      loadFactor: IntUtils.tryParse(json['load_factor'])!,
      networkId: IntUtils.tryParse(json['network_id']),
      peerDisconnects: IntUtils.tryParse(json['peer_disconnects'])!,
      peerDisconnectsResources:
          IntUtils.tryParse(json['peer_disconnects_resources'])!,
      peers: IntUtils.tryParse(json['peers'])!,
      pubkeyNode: json['pubkey_node'],
      serverState: json['server_state'],
      serverStateDurationUs:
          IntUtils.tryParse(json['server_state_duration_us'])!,
      stateAccounting: StateAccounting.fromJson(json['state_accounting']),
      time: json['time'],
      uptime: IntUtils.tryParse(json['uptime'])!,
      validatedLedger: ValidatedLedger.fromJson(json['validated_ledger']),
      validationQuorum: IntUtils.tryParse(json['validation_quorum'])!,
    );
  }
}

class LastClose {
  final int? convergeTimeS;
  final int? proposers;

  LastClose({
    required this.convergeTimeS,
    required this.proposers,
  });

  factory LastClose.fromJson(Map<String, dynamic> json) {
    return LastClose(
      convergeTimeS: IntUtils.tryParse(json['converge_time_s']),
      proposers: IntUtils.tryParse(json['proposers']),
    );
  }
}

class StateAccounting {
  final AccountingDuration connected;
  final AccountingDuration disconnected;
  final AccountingDuration full;
  final AccountingDuration syncing;
  final AccountingDuration tracking;

  StateAccounting({
    required this.connected,
    required this.disconnected,
    required this.full,
    required this.syncing,
    required this.tracking,
  });

  factory StateAccounting.fromJson(Map<String, dynamic> json) {
    return StateAccounting(
      connected: AccountingDuration.fromJson(json['connected']),
      disconnected: AccountingDuration.fromJson(json['disconnected']),
      full: AccountingDuration.fromJson(json['full']),
      syncing: AccountingDuration.fromJson(json['syncing']),
      tracking: AccountingDuration.fromJson(json['tracking']),
    );
  }
}

class AccountingDuration {
  final int durationUs;
  final int transitions;

  AccountingDuration({
    required this.durationUs,
    required this.transitions,
  });

  factory AccountingDuration.fromJson(Map<String, dynamic> json) {
    return AccountingDuration(
      durationUs: IntUtils.tryParse(json['duration_us'])!,
      transitions: IntUtils.tryParse(json['transitions'])!,
    );
  }
}

class ValidatedLedger {
  final int age;
  final double baseFeeXrp;
  final String hash;
  final int? reserveBaseXrp;
  final int? reserveIncXrp;
  final int seq;

  ValidatedLedger({
    required this.age,
    required this.baseFeeXrp,
    required this.hash,
    required this.reserveBaseXrp,
    required this.reserveIncXrp,
    required this.seq,
  });

  factory ValidatedLedger.fromJson(Map<String, dynamic> json) {
    return ValidatedLedger(
      age: IntUtils.tryParse(json['age'])!,
      baseFeeXrp: json['base_fee_xrp'],
      hash: json['hash'],
      reserveBaseXrp: IntUtils.tryParse(json['reserve_base_xrp']),
      reserveIncXrp: IntUtils.tryParse(json['reserve_inc_xrp']),
      seq: IntUtils.tryParse(json['seq'])!,
    );
  }
}
