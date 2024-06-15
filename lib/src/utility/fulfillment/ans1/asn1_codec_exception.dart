import 'package:blockchain_utils/exception/exceptions.dart';

class ASN1CodecException implements BlockchainUtilsException {
  @override
  final String message;
  @override
  final Map<String, dynamic>? details;
  const ASN1CodecException(this.message, {this.details});
}
