import 'package:blockchain_utils/exception/exceptions.dart';

class ASN1CodecException implements BlockchainUtilsException {
  @override
  final String message;
  const ASN1CodecException(this.message);
}
