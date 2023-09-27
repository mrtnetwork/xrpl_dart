part of 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';

final RegExp _hexRegex = RegExp(r"[A-F0-9]{40}");

class AccountID extends Hash160 {
  @override
  factory AccountID.fromParser(BinaryParser parser, [int? lengthHint]) {
    final numBytes = lengthHint ?? 20;
    final bytes = parser.read(numBytes);
    return AccountID(bytes);
  }
  AccountID([Uint8List? buffer])
      : super(
            buffer ?? Uint8List.fromList(List.filled(Hash160.lengthBytes, 0)));

  @override
  factory AccountID.fromValue(dynamic value) {
    if (value == null || value is! String || value.isEmpty) {
      return AccountID();
    }

    /// Hex-encoded case
    if (_hexRegex.hasMatch(value)) {
      return AccountID(hexToBytes(value));
    }

    /// Base58 case
    if (XRPAddressUtilities.isValidClassicAddress(value)) {
      return AccountID(XRPAddressUtilities.decodeClassicAddress(value));
    }

    if (XRPAddressUtilities.isValidXAddress(value)) {
      final classicAddress =
          XRPAddressUtilities.xAddressToClassicAddress(value).$1;
      return AccountID(
          XRPAddressUtilities.decodeClassicAddress(classicAddress));
    }

    throw XRPLBinaryCodecException(
        "Invalid value to construct an AccountID: expected valid classic address "
        "${value.runtimeType}, received ${value.runtimeType}.");
  }

  @override
  String toJson() {
    return XRPAddressUtilities.encodeClassicAddress(buffer);
  }
}
