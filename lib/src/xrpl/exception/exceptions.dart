import 'package:blockchain_utils/blockchain_utils.dart';

/// Exception thrown when an error occurs during XRPL binary encoding or decoding.
class XRPLBinaryCodecException implements BlockchainUtilsException {
  @override
  final String message;
  @override
  final Map<String, dynamic>? details;

  /// Constructor for XRPLBinaryCodecException
  const XRPLBinaryCodecException(this.message, {this.details});

  @override
  String toString() => message;
}

/// Exception thrown when an error occurs during XRPL address, keypair,  encoding or decoding.
class XRPLAddressCodecException implements BlockchainUtilsException {
  @override
  final String message;

  @override
  final Map<String, dynamic>? details;

  /// Constructor for XRPLAddressCodecException
  const XRPLAddressCodecException(this.message, {this.details});
  @override
  String toString() => message;
}

class XRPLTransactionException implements BlockchainUtilsException {
  @override
  final String message;

  @override
  final Map<String, dynamic>? details;

  const XRPLTransactionException(this.message, {this.details});
  @override
  String toString() => message;
}
