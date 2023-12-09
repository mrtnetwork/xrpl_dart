part of 'package:xrp_dart/src/xrpl/bytes/serializer.dart';

/// Utility class for Account ID operations
class _AccountIdUils {
  static final RegExp _hex20Bytes = RegExp(r"[A-F0-9]{40}");

  /// Checks if the input string is a 20-byte hash in hexadecimal format
  static bool isHash160(String v) {
    return _hex20Bytes.hasMatch(v);
  }
}

/// Represents an XRP account ID
class AccountID extends Hash160 {
  @override
  factory AccountID.fromParser(BinaryParser parser, [int? lengthHint]) {
    final numBytes = lengthHint ?? 20;
    final bytes = parser.read(numBytes);
    return AccountID(bytes);
  }

  /// Constructor for AccountID
  AccountID([List<int>? buffer])
      : super(buffer ?? List.filled(Hash160.lengthBytes, 0));

  @override
  factory AccountID.fromValue(dynamic value) {
    if (value == null || value is! String || value.isEmpty) {
      return AccountID();
    }

    /// Hex-encoded case
    if (_AccountIdUils.isHash160(value)) {
      return AccountID(BytesUtils.fromHexString(value));
    }
    try {
      final addrHash = XRPAddressUtils.decodeAddress(value);
      return AccountID(addrHash);
    } catch (e) {
      throw XRPLBinaryCodecException(
          "Invalid value to construct an AccountID: expected valid classic address "
          "${value.runtimeType}, received ${value.runtimeType}.");
    }
  }

  @override
  String toJson() {
    return XRPAddressUtils.hashToAddress(_buffer);
  }
}
