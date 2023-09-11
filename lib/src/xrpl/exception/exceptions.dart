class XRPLBinaryCodecException implements Exception {
  final String message;

  XRPLBinaryCodecException(this.message);

  @override
  String toString() => message;
}

class XRPLAddressCodecException implements Exception {
  final String message;

  XRPLAddressCodecException(this.message);
}
