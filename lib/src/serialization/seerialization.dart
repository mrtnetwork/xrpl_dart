import 'package:blockchain_utils/blockchain_utils.dart';

enum XRPLSerializationIdentifiers implements SerializationIdentifier {
  xrplPluginError(22001),
  binaryCodecError(22002),
  addressCodecError(22003),
  transactionError(22004),
  asn1CodecException(22005);

  @override
  final int id;
  const XRPLSerializationIdentifiers(this.id);

  static XRPLSerializationIdentifiers fromIdentifier(int? value) {
    return values.firstWhere(
      (e) => e.id == value,
      orElse:
          () =>
              throw const BuError(
                DefaultErrorType.notFound,
                "No matching XRPLSerializationIdentifiers found for the given value. null",
              ),
    );
  }

  @override
  bool isValid(int? tag) {
    return tag == id;
  }
}
