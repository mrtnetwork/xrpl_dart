import 'package:blockchain_utils/blockchain_utils.dart';

/// XRPL-specific error types. Phase 2: taxonomy only, no serialization.
enum XrplErrorType implements BuErrorType {
  plugin(14000),
  binaryCodec(14001),
  addressCodec(14002),
  transaction(14003),
  asn1(14004);

  @override
  String get domain => 'xrpl';

  @override
  String get errName => name;

  @override
  final int id;
  const XrplErrorType(this.id);

  @override
  bool isValid(int? tag) {
    return values.any((e) => e.id == tag);
  }
}
