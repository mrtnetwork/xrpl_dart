import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

class RipplePathFound {
  final String destinationAccount;
  final dynamic destinationAmount;
  final List<String> destinationCurrencies;
  final bool fullReply;
  final String sourceAccount;
  final String? status;
  final List<Alternatives> alternatives;

  RipplePathFound({
    required this.alternatives,
    required this.destinationAccount,
    required this.destinationAmount,
    required this.destinationCurrencies,
    required this.fullReply,
    required this.sourceAccount,
    required this.status,
  });

  factory RipplePathFound.fromJson(Map<String, dynamic> json) {
    return RipplePathFound(
      alternatives: ((json['alternatives'] as List?) ?? [])
          .map((e) => Alternatives.fromJson(e))
          .toList(),
      destinationAccount: json['destination_account'] ?? '',
      destinationAmount: json['destination_amount'],
      destinationCurrencies: List<String>.from(json['destination_currencies']),
      fullReply: json['full_reply'] ?? false,
      sourceAccount: json['source_account'] ?? '',
      status: json['status'],
    );
  }
}

class Alternatives {
  factory Alternatives.fromJson(Map<String, dynamic> json) {
    final List<dynamic> pathsCanonical =
        (json['paths_canonical'] as List?) ?? [];
    final List<List<PathStep>>? pathsComputed = json['paths_computed'] == null
        ? null
        : ((json['paths_computed'] as List?) ?? [])
            .map((e) => (e as List).map((e) => PathStep.fromJson(e)).toList())
            .toList();
    return Alternatives(
        pathsCanonical: pathsCanonical,
        pathsComputed: pathsComputed,
        sourceAmount: CurrencyAmount.fromJson(json['source_amount']));
  }

  Alternatives(
      {required this.pathsCanonical,
      required this.pathsComputed,
      required this.sourceAmount});
  final List<dynamic> pathsCanonical;
  final List<List<PathStep>>? pathsComputed;
  final CurrencyAmount? sourceAmount;
}
