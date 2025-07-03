part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class _CurrencyUtils {
  static final List<int> xrpIsoBytes =
      List.unmodifiable(List<int>.filled(20, 0));
  static const String xrpIsoName = 'XRP';
  static bool isIsoCode(String value) {
    final isoRegex = RegExp(r'^[A-Z]{3}$');
    return isoRegex.hasMatch(value);
  }

  static String? isoNameFromBytes(List<int> value) {
    final candidateIso = String.fromCharCodes(value);
    if (candidateIso == xrpIsoName) {
      throw const XRPLBinaryCodecException(
          'Disallowed currency code: to indicate the currency XRP you must use 20 bytes of 0s');
    }
    return isIsoCode(candidateIso) ? candidateIso : null;
  }

  static List<int> isoToBytes(String iso) {
    if (iso == xrpIsoName) {
      return xrpIsoBytes;
    }
    final isoBytes = StringUtils.encode(iso, type: StringEncoding.ascii);
    return [...List<int>.filled(12, 0), ...isoBytes, ...List<int>.filled(5, 0)];
  }

  static String? parseCurrencyIso(List<int>? bytes) {
    if (bytes == null) return null;
    if (bytes[0] != 0) {
      return null;
    } else if (BytesUtils.bytesEqual(bytes, xrpIsoBytes)) {
      return xrpIsoName;
    } else {
      return isoNameFromBytes(bytes.sublist(12, 15));
    }
  }

  static bool isCurrencyHex(String value) {
    final hexRegex = RegExp(r'^[A-F0-9]{40}$');
    return hexRegex.hasMatch(value);
  }
}

class Currency extends Hash160 {
  String? _iso;
  Currency([List<int>? buffer])
      : super(buffer ?? List<int>.filled(Hash160.lengthBytes, 0)) {
    _iso = _CurrencyUtils.parseCurrencyIso(buffer);
  }

  @override
  factory Currency.fromValue(String value) {
    if (_CurrencyUtils.isIsoCode(value)) {
      return Currency(_CurrencyUtils.isoToBytes(value));
    }
    if (!_CurrencyUtils.isCurrencyHex(value)) {
      throw XRPLBinaryCodecException(
          'Unsupported Currency representation: $value');
    }
    return Currency(BytesUtils.fromHexString(value));
  }

  @override
  factory Currency.fromParser(BinaryParser parser, [int? lengthHint]) {
    final numBytes = lengthHint ?? Hash160.lengthBytes;
    final bytes = parser.read(numBytes);
    return Currency(bytes);
  }

  @override
  String toJson() {
    return _iso ?? BytesUtils.toHexString(_buffer, lowerCase: false);
  }
}
