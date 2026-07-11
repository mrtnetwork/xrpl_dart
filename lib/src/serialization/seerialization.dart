import 'package:blockchain_utils/cbor/serialization/cbor/tag.dart';
import 'package:blockchain_utils/exception/exception/blockchain_utils.dart';

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
              throw ItemNotFoundException(name: "XRPLSerializationIdentifiers"),
    );
  }

  @override
  bool isValid(int? tag) {
    return tag == id;
  }
}
