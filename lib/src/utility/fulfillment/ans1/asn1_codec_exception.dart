import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:xrpl_dart/src/exception/exceptions.dart';
import 'package:xrpl_dart/src/serialization/seerialization.dart';

class ASN1CodecException extends BaseXRPLPluginException {
  const ASN1CodecException(super.message, {super.details});
  factory ASN1CodecException.deserialize({List<int>? bytes, CborObject? obj}) {
    final values = CborTagSerializable.decodeTaggedValue(
      identifier: XRPLSerializationIdentifiers.asn1CodecException,
      cborBytes: bytes,
      cborObject: obj,
    );
    return ASN1CodecException(
      values.rawValueAt(0),
      details: values.maybeRawMapAt<String, String?>(1),
    );
  }

  @override
  XRPLSerializationIdentifiers get serializationIdentifier =>
      XRPLSerializationIdentifiers.asn1CodecException;
}
