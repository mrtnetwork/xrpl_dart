import 'package:blockchain_utils/exception/exception.dart';

/// Exception thrown when an error occurs during XRPL binary encoding or decoding.
class XRPLBinaryCodecException implements BlockchainUtilsException {
  @override
  final String message;

  /// Constructor for XRPLBinaryCodecException
  const XRPLBinaryCodecException(this.message);

  @override
  String toString() => message;
}

/// Exception thrown when an error occurs during XRPL address encoding or decoding.
class XRPLAddressCodecException implements BlockchainUtilsException {
  @override
  final String message;

  /// Constructor for XRPLAddressCodecException
  const XRPLAddressCodecException(this.message);
  @override
  String toString() => message;
}
