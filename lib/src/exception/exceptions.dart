import 'package:blockchain_utils/cbor/cbor.dart';
import 'package:blockchain_utils/exception/exception/exception.dart';
import 'package:blockchain_utils/networks/types/network.dart';
import 'package:xrpl_dart/src/serialization/seerialization.dart';
import 'package:xrpl_dart/src/utility/fulfillment/ans1/asn1_codec_exception.dart';

abstract class BaseXRPLPluginException extends IException {
  const BaseXRPLPluginException(super.message, {super.details});

  @override
  XRPLSerializationIdentifiers get serializationIdentifier;

  factory BaseXRPLPluginException.deserialize({
    List<int>? bytes,
    CborObject? obj,
  }) {
    final values = CborTagSerializable.decodeTaggedValueWithInfo(
      expectedTags: XRPLSerializationIdentifiers.values,
      cborBytes: bytes,
      cborObject: obj,
    );
    final identifier = values.identifier;
    return switch (identifier) {
      XRPLSerializationIdentifiers.xrplPluginError =>
        XRPLPluginException.deserialize(obj: values.tag),
      XRPLSerializationIdentifiers.binaryCodecError =>
        XRPLBinaryCodecException.deserialize(obj: values.tag),
      XRPLSerializationIdentifiers.addressCodecError =>
        XRPLAddressCodecException.deserialize(obj: values.tag),
      XRPLSerializationIdentifiers.transactionError =>
        XRPLTransactionException.deserialize(obj: values.tag),
      XRPLSerializationIdentifiers.asn1CodecException =>
        ASN1CodecException.deserialize(obj: values.tag),
    };
  }

  @override
  BlockchainNetwork get relatedNetwork => BlockchainNetwork.xrpl;
}

class XRPLPluginException extends BaseXRPLPluginException {
  const XRPLPluginException(super.message, {super.details});

  factory XRPLPluginException.deserialize({List<int>? bytes, CborObject? obj}) {
    final values = CborTagSerializable.decodeTaggedValue(
      identifier: XRPLSerializationIdentifiers.xrplPluginError,
      cborBytes: bytes,
      cborObject: obj,
    );
    return XRPLPluginException(
      values.rawValueAt(0),
      details: values.maybeRawMapAt<String, String?>(1),
    );
  }

  @override
  XRPLSerializationIdentifiers get serializationIdentifier =>
      XRPLSerializationIdentifiers.xrplPluginError;
}

/// Exception thrown when an error occurs during XRPL binary encoding or decoding.
class XRPLBinaryCodecException extends BaseXRPLPluginException {
  const XRPLBinaryCodecException(super.message, {super.details});

  factory XRPLBinaryCodecException.deserialize({
    List<int>? bytes,
    CborObject? obj,
  }) {
    final values = CborTagSerializable.decodeTaggedValue(
      identifier: XRPLSerializationIdentifiers.binaryCodecError,
      cborBytes: bytes,
      cborObject: obj,
    );
    return XRPLBinaryCodecException(
      values.rawValueAt(0),
      details: values.maybeRawMapAt<String, String?>(1),
    );
  }

  @override
  XRPLSerializationIdentifiers get serializationIdentifier =>
      XRPLSerializationIdentifiers.binaryCodecError;
}

/// Exception thrown when an error occurs during XRPL address, keypair,  encoding or decoding.
class XRPLAddressCodecException extends BaseXRPLPluginException {
  const XRPLAddressCodecException(super.message, {super.details});
  factory XRPLAddressCodecException.deserialize({
    List<int>? bytes,
    CborObject? obj,
  }) {
    final values = CborTagSerializable.decodeTaggedValue(
      identifier: XRPLSerializationIdentifiers.addressCodecError,
      cborBytes: bytes,
      cborObject: obj,
    );
    return XRPLAddressCodecException(
      values.rawValueAt(0),
      details: values.maybeRawMapAt<String, String?>(1),
    );
  }

  @override
  XRPLSerializationIdentifiers get serializationIdentifier =>
      XRPLSerializationIdentifiers.addressCodecError;
}

class XRPLTransactionException extends BaseXRPLPluginException {
  const XRPLTransactionException(super.message, {super.details});
  factory XRPLTransactionException.deserialize({
    List<int>? bytes,
    CborObject? obj,
  }) {
    final values = CborTagSerializable.decodeTaggedValue(
      identifier: XRPLSerializationIdentifiers.transactionError,
      cborBytes: bytes,
      cborObject: obj,
    );
    return XRPLTransactionException(
      values.rawValueAt(0),
      details: values.maybeRawMapAt<String, String?>(1),
    );
  }
  @override
  XRPLSerializationIdentifiers get serializationIdentifier =>
      XRPLSerializationIdentifiers.transactionError;
}
