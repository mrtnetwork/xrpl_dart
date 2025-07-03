import 'package:xrpl_dart/src/exception/exception.dart';

/// Exception thrown when an error occurs during XRPL binary encoding or decoding.
class XRPLBinaryCodecException extends XRPLPluginException {
  const XRPLBinaryCodecException(super.message, {super.details});

  /// Constructor for XRPLBinaryCodecException

  @override
  String toString() => message;
}

/// Exception thrown when an error occurs during XRPL address, keypair,  encoding or decoding.
class XRPLAddressCodecException extends XRPLPluginException {
  const XRPLAddressCodecException(super.message, {super.details});
  @override
  String toString() => message;
}

class XRPLTransactionException extends XRPLPluginException {
  const XRPLTransactionException(super.message, {super.details});
  @override
  String toString() => message;
}
