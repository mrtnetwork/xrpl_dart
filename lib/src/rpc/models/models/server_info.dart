import 'package:blockchain_utils/utils/utils.dart';

class ServerInfoResult {
  final InfoResult info;
  const ServerInfoResult({
    required this.info,
  });
  factory ServerInfoResult.fromJson(Map<String, dynamic> json) {
    return ServerInfoResult(info: InfoResult.fromJson(json['info']));
  }
  Map<String, dynamic> toJson() {
    return {"info": info.toJson()};
  }
}

class ServerStateResult {
  final StateInfoResult state;
  const ServerStateResult({required this.state});
  factory ServerStateResult.fromJson(Map<String, dynamic> json) {
    return ServerStateResult(state: StateInfoResult.fromJson(json['state']));
  }
  Map<String, dynamic> toJson() {
    return {"state": state.toJson()};
  }
}

class ClosedLedgerResult {
  final int age;
  final num baseFeeXrp;
  final String hash;
  final num reserveBaseXrp;
  final num reserveIncXrp;
  final int seq;

  ClosedLedgerResult({
    required this.age,
    required this.baseFeeXrp,
    required this.hash,
    required this.reserveBaseXrp,
    required this.reserveIncXrp,
    required this.seq,
  });

  factory ClosedLedgerResult.fromJson(Map<String, dynamic> json) {
    return ClosedLedgerResult(
      age: json['age'] as int,
      baseFeeXrp: json['base_fee_xrp'],
      hash: json['hash'] as String,
      reserveBaseXrp: json['reserve_base_xrp'],
      reserveIncXrp: json['reserve_inc_xrp'] as num,
      seq: json['seq'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'age': age,
        'base_fee_xrp': baseFeeXrp,
        'hash': hash,
        'reserve_base_xrp': reserveBaseXrp,
        'reserve_inc_xrp': reserveIncXrp,
        'seq': seq,
      };
}

class JobTypeResult {
  final String jobType;
  final double perSecond;
  final int? peakTime;
  final int? avgTime;
  final int? inProgress;

  JobTypeResult({
    required this.jobType,
    required this.perSecond,
    this.peakTime,
    this.avgTime,
    this.inProgress,
  });

  factory JobTypeResult.fromJson(Map<String, dynamic> json) {
    return JobTypeResult(
      jobType: json['job_type'] as String,
      perSecond: (json['per_second'] as num).toDouble(),
      peakTime: json['peak_time'],
      avgTime: json['avg_time'],
      inProgress: json['in_progress'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'job_type': jobType,
        'per_second': perSecond,
        'peak_time': peakTime,
        'avg_time': avgTime,
        'in_progress': inProgress,
      };
}

class LoadResult {
  final List<JobTypeResult> jobTypes;
  final int threads;

  LoadResult({
    required this.jobTypes,
    required this.threads,
  });

  factory LoadResult.fromJson(Map<String, dynamic> json) {
    return LoadResult(
      jobTypes: (json['job_types'] as List<dynamic>)
          .map((e) => JobTypeResult.fromJson(e as Map<String, dynamic>))
          .toList(),
      threads: json['threads'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'job_types': jobTypes.map((e) => e.toJson()).toList(),
        'threads': threads,
      };
}

class ServerPortResult {
  final String port;
  final List<String> protocol;

  ServerPortResult({required this.port, required this.protocol});

  factory ServerPortResult.fromJson(Map<String, dynamic> json) {
    return ServerPortResult(
      port: json['port'] as String,
      protocol: (json["protocol"] as List).cast(),
    );
  }

  Map<String, dynamic> toJson() => {
        'port': port,
        'protocol': protocol,
      };
}

class StateAccountingResult {
  final String durationUs;
  final String transitions;

  StateAccountingResult({
    required this.durationUs,
    required this.transitions,
  });

  factory StateAccountingResult.fromJson(Map<String, dynamic> json) {
    return StateAccountingResult(
      durationUs: json['duration_us'] as String,
      transitions: json['transitions'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'duration_us': durationUs,
        'transitions': transitions,
      };
}

class ValidatorListResult {
  final int count;
  final String expiration;
  final String status;

  const ValidatorListResult({
    required this.count,
    required this.expiration,
    required this.status,
  });

  factory ValidatorListResult.fromJson(Map<String, dynamic> json) {
    return ValidatorListResult(
      count: json['count'] as int,
      expiration: json['expiration'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'count': count,
        'expiration': expiration,
        'status': status,
      };
}

class InfoResult {
  final bool? amendmentblocked;
  final String buildVersion;
  final ClosedLedgerResult? closedLedger;
  final String completeLedgers;
  final String hostId;
  final int ioLatencyMs;
  final int jqTransOverflow;
  final LastCloseResult? lastClose;
  final LoadResult? load;

  final int? loadFactor;
  final int? networkId;
  final int? loadFactorLocal;
  final int? loadFactorNet;
  final int? loadFactorcluster;
  final int? loadFactorFeeEscalation;
  final int? loadFactorFeeQueue;
  final int? loadFactorServer;

  final int? peerDisconnects;
  final int? peerDisconnectsResources;
  final int? peers;
  final List<ServerPortResult> ports;
  final String? pubkeyNode;
  final String? pubkeyValidator;
  final String? serverState;
  final String serverStateDurationUs;

  final Map<String, StateAccountingResult> stateAccounting;

  final String time;
  final int uptime;
  final ValidatedLedgerResult? validatedLedger;
  final int validationQuorum;
  final String? validatorListExpires;
  final ValidatorListResult? validatorList;

  const InfoResult({
    required this.buildVersion,
    required this.completeLedgers,
    required this.hostId,
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
    required this.amendmentblocked,
    required this.closedLedger,
    required this.load,
    required this.loadFactorLocal,
    required this.loadFactorNet,
    required this.loadFactorcluster,
    required this.loadFactorFeeEscalation,
    required this.loadFactorFeeQueue,
    required this.loadFactorServer,
    required this.ports,
    required this.pubkeyValidator,
    required this.validatorListExpires,
    required this.validatorList,
  });

  factory InfoResult.fromJson(Map<String, dynamic> json) {
    return InfoResult(
        buildVersion: json['build_version'],
        completeLedgers: json['complete_ledgers'],
        hostId: json['hostid'],
        ioLatencyMs: IntUtils.parse(json['io_latency_ms']),
        jqTransOverflow: IntUtils.parse(json['jq_trans_overflow']),
        lastClose: json['last_close'] != null
            ? LastCloseResult.fromJson(json['last_close'])
            : null,
        loadFactor: IntUtils.tryParse(json['load_factor']),
        networkId: IntUtils.tryParse(json['network_id']),
        peerDisconnects: IntUtils.tryParse(json['peer_disconnects']),
        peerDisconnectsResources:
            IntUtils.tryParse(json['peer_disconnects_resources']),
        peers: IntUtils.tryParse(json['peers']),
        pubkeyNode: json['pubkey_node'],
        serverState: json['server_state'],
        serverStateDurationUs: json['server_state_duration_us'],
        stateAccounting: (json['state_accounting'] as Map)
            .map((k, v) => MapEntry(k, StateAccountingResult.fromJson(v))),
        time: json['time'],
        uptime: IntUtils.parse(json['uptime']),
        validatedLedger: json['validated_ledger'] != null
            ? ValidatedLedgerResult.fromJson(json['validated_ledger'])
            : null,
        validationQuorum: IntUtils.parse(json['validation_quorum']),
        amendmentblocked: json["amendment_blocked"],
        closedLedger: json["closed_ledger"] == null
            ? null
            : ClosedLedgerResult.fromJson(json["closed_ledger"]),
        load: json["load"] == null ? null : LoadResult.fromJson(json["load"]),
        loadFactorFeeEscalation:
            IntUtils.tryParse(json["load_factor_fee_escalation"]),
        loadFactorFeeQueue: IntUtils.tryParse(json["load_factor_fee_queue"]),
        loadFactorLocal: IntUtils.tryParse(json["load_factor_local"]),
        loadFactorNet: IntUtils.tryParse(json["load_factor_net"]),
        loadFactorServer: IntUtils.tryParse(json["load_factor_server"]),
        loadFactorcluster: IntUtils.tryParse(json["load_factor_cluster"]),
        ports: (json["ports"] as List)
            .map((e) => ServerPortResult.fromJson(e))
            .toList(),
        pubkeyValidator: json["pubkey_validator"],
        validatorList: json["validator_list"] == null
            ? null
            : ValidatorListResult.fromJson(json["validator_list"]),
        validatorListExpires: json["validator_list_expires"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'amendment_blocked': amendmentblocked,
      'build_version': buildVersion,
      'closed_ledger': closedLedger?.toJson(),
      'complete_ledgers': completeLedgers,
      'hostid': hostId,
      'io_latency_ms': ioLatencyMs,
      'jq_trans_overflow': jqTransOverflow,
      'last_close': lastClose?.toJson(),
      'load': load?.toJson(),
      'load_factor': loadFactor,
      'network_id': networkId,
      'load_factor_local': loadFactorLocal,
      'load_factor_net': loadFactorNet,
      'load_factor_cluster': loadFactorcluster,
      'load_factor_fee_escalation': loadFactorFeeEscalation,
      'load_factor_fee_queue': loadFactorFeeQueue,
      'load_factor_server': loadFactorServer,
      'peer_disconnects': peerDisconnects,
      'peer_disconnects_resources': peerDisconnectsResources,
      'peers': peers,
      'ports': ports.map((e) => e.toJson()).toList(),
      'pubkey_node': pubkeyNode,
      'pubkey_validator': pubkeyValidator,
      'server_state': serverState,
      'server_state_duration_us': serverStateDurationUs,
      'state_accounting':
          stateAccounting.map((k, v) => MapEntry(k, v.toJson())),
      'time': time,
      'uptime': uptime,
      'validated_ledger': validatedLedger?.toJson(),
      'validation_quorum': validationQuorum,
      'validator_list_expires': validatorListExpires,
      'validator_list': validatorList?.toJson(),
    };
  }
}

class LastCloseResult {
  final num? convergeTimeS;
  final num proposers;

  const LastCloseResult({required this.convergeTimeS, required this.proposers});

  factory LastCloseResult.fromJson(Map<String, dynamic> json) {
    return LastCloseResult(
      convergeTimeS: json['converge_time_s'],
      proposers: json['proposers'],
    );
  }
  Map<String, dynamic> toJson() {
    return {"converge_time_s": convergeTimeS, "proposers": proposers};
  }
}

class AccountingDurationResult {
  final int? durationUs;
  final int? transitions;

  const AccountingDurationResult({this.durationUs, this.transitions});

  factory AccountingDurationResult.fromJson(Map<String, dynamic> json) {
    return AccountingDurationResult(
      durationUs: IntUtils.tryParse(json['duration_us']),
      transitions: IntUtils.tryParse(json['transitions']),
    );
  }
}

class ValidatedLedgerResult {
  final int age;
  final num baseFeeXrp;
  final String hash;
  final num reserveBaseXrp;
  final num reserveIncXrp;
  final int seq;

  const ValidatedLedgerResult({
    required this.age,
    required this.baseFeeXrp,
    required this.hash,
    required this.reserveBaseXrp,
    required this.reserveIncXrp,
    required this.seq,
  });

  factory ValidatedLedgerResult.fromJson(Map<String, dynamic> json) {
    return ValidatedLedgerResult(
      age: IntUtils.parse(json['age']),
      baseFeeXrp: json['base_fee_xrp'],
      hash: json['hash'],
      reserveBaseXrp: json['reserve_base_xrp'],
      reserveIncXrp: json['reserve_inc_xrp'],
      seq: IntUtils.tryParse(json['seq'])!,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'base_fee_xrp': baseFeeXrp,
      'hash': hash,
      'reserve_base_xrp': reserveBaseXrp,
      'reserve_inc_xrp': reserveIncXrp,
      'seq': seq,
    };
  }
}

class StateValidatedLedgerResult {
  final int? age;
  final int baseFee;
  final int closeTime;
  final String hash;
  final int reserveBase;
  final int reserveInc;
  final int seq;

  const StateValidatedLedgerResult({
    required this.age,
    required this.closeTime,
    required this.reserveBase,
    required this.reserveInc,
    required this.baseFee,
    required this.hash,
    required this.seq,
  });

  factory StateValidatedLedgerResult.fromJson(Map<String, dynamic> json) {
    return StateValidatedLedgerResult(
      age: IntUtils.tryParse(json['age']),
      baseFee: IntUtils.parse(json['base_fee']),
      hash: json['hash'],
      closeTime: IntUtils.parse(json['close_time']),
      reserveBase: IntUtils.parse(json['reserve_base']),
      reserveInc: IntUtils.parse(json['reserve_inc']),
      seq: IntUtils.tryParse(json['seq'])!,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'close_time': closeTime,
      'base_fee': baseFee,
      'hash': hash,
      'reserve_base': reserveBase,
      'reserve_inc': reserveInc,
      'seq': seq,
    };
  }
}

class StateInfoResult {
  final bool? amendmentblocked;
  final String buildVersion;
  final ClosedLedgerResult? closedLedger;
  final String completeLedgers;
  final int ioLatencyMs;
  final int jqTransOverflow;
  final LastCloseResult? lastClose;
  final LoadResult? load;

  final int loadBase;
  final int loadFactor;
  final int networkId;
  final int? loadFactorFeeEscalation;
  final int? loadFactorFeeReference;
  final int? loadFactorFeeQueue;
  final int? loadFactorServer;

  final int? peerDisconnects;
  final int? peerDisconnectsResources;
  final int peers;
  // final List<ServerPortResult> ports;
  final String pubkeyNode;
  final String? pubkeyValidator;
  final String serverState;
  final String serverStateDurationUs;

  final Map<String, StateAccountingResult> stateAccounting;

  final String time;
  final int uptime;
  final StateValidatedLedgerResult? validatedLedger;
  final int validationQuorum;
  final String? validatorListExpires;

  const StateInfoResult({
    required this.buildVersion,
    required this.completeLedgers,
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
    required this.amendmentblocked,
    required this.closedLedger,
    required this.load,
    required this.loadFactorFeeEscalation,
    required this.loadFactorFeeQueue,
    required this.loadFactorServer,
    required this.pubkeyValidator,
    required this.validatorListExpires,
    required this.loadBase,
    required this.loadFactorFeeReference,
  });

  factory StateInfoResult.fromJson(Map<String, dynamic> json) {
    return StateInfoResult(
        buildVersion: json['build_version'],
        completeLedgers: json['complete_ledgers'],
        ioLatencyMs: IntUtils.parse(json['io_latency_ms']),
        jqTransOverflow: IntUtils.parse(json['jq_trans_overflow']),
        lastClose: json['last_close'] != null
            ? LastCloseResult.fromJson(json['last_close'])
            : null,
        loadFactor: IntUtils.parse(json['load_factor']),
        networkId: IntUtils.parse(json['network_id']),
        peerDisconnects: IntUtils.tryParse(json['peer_disconnects']),
        peerDisconnectsResources:
            IntUtils.tryParse(json['peer_disconnects_resources']),
        peers: IntUtils.parse(json['peers']),
        pubkeyNode: json['pubkey_node'],
        serverState: json['server_state'],
        serverStateDurationUs: json['server_state_duration_us'],
        stateAccounting: (json['state_accounting'] as Map)
            .map((k, v) => MapEntry(k, StateAccountingResult.fromJson(v))),
        time: json['time'],
        uptime: IntUtils.parse(json['uptime']),
        validatedLedger: json['validated_ledger'] != null
            ? StateValidatedLedgerResult.fromJson(json['validated_ledger'])
            : null,
        validationQuorum: IntUtils.parse(json['validation_quorum']),
        amendmentblocked: json["amendment_blocked"],
        closedLedger: json["closed_ledger"] == null
            ? null
            : ClosedLedgerResult.fromJson(json["closed_ledger"]),
        load: json["load"] == null ? null : LoadResult.fromJson(json["load"]),
        loadFactorFeeEscalation:
            IntUtils.tryParse(json["load_factor_fee_escalation"]),
        loadFactorFeeQueue: IntUtils.tryParse(json["load_factor_fee_queue"]),
        loadBase: IntUtils.parse(json["load_base"]),
        loadFactorFeeReference:
            IntUtils.tryParse(json["load_factor_fee_reference"]),
        loadFactorServer: IntUtils.tryParse(json["load_factor_server"]),
        pubkeyValidator: json["pubkey_validator"],
        validatorListExpires: json["validator_list_expires"]);
  }

  Map<String, dynamic> toJson() {
    return {
      'amendment_blocked': amendmentblocked,
      'build_version': buildVersion,
      'closed_ledger': closedLedger?.toJson(),
      'complete_ledgers': completeLedgers,
      'io_latency_ms': ioLatencyMs,
      'jq_trans_overflow': jqTransOverflow,
      'last_close': lastClose?.toJson(),
      'load': load?.toJson(),
      'load_factor': loadFactor,
      'network_id': networkId,
      'load_base': loadBase,
      'load_factor_fee_reference': loadFactorFeeReference,
      'load_factor_fee_escalation': loadFactorFeeEscalation,
      'load_factor_fee_queue': loadFactorFeeQueue,
      'load_factor_server': loadFactorServer,
      'peer_disconnects': peerDisconnects,
      'peer_disconnects_resources': peerDisconnectsResources,
      'peers': peers,
      'pubkey_node': pubkeyNode,
      'pubkey_validator': pubkeyValidator,
      'server_state': serverState,
      'server_state_duration_us': serverStateDurationUs,
      'state_accounting':
          stateAccounting.map((k, v) => MapEntry(k, v.toJson())),
      'time': time,
      'uptime': uptime,
      'validated_ledger': validatedLedger?.toJson(),
      'validation_quorum': validationQuorum,
      'validator_list_expires': validatorListExpires
    };
  }
}
