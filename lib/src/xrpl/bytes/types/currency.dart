part of 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';

class Currency extends Hash160 {
  String? _iso;
  Currency([Uint8List? buffer])
      : super(buffer ?? Uint8List(Hash160.lengthBytes)) {
    if (buffer == null) return;
    final codeBytes = buffer.sublist(12, 15);
    if (buffer[0] != 0) {
      _iso = null;
    } else if (bytesToHex(buffer) == '0' * 40) {
      _iso = 'XRP';
    } else {
      _iso = _isoCodeFromHex(codeBytes);
    }
  }

  @override
  factory Currency.fromValue(dynamic value) {
    if (value is! String) {
      throw XRPLBinaryCodecException(
          'Invalid type to construct a Currency: expected String, received ${value.runtimeType}.');
    }

    if (_isIsoCode(value)) {
      return Currency(_isoToBytes(value));
    }

    if (_isHex(value)) {
      return Currency(Uint8List.fromList(hexToBytes(value)));
    }

    throw XRPLBinaryCodecException(
        'Unsupported Currency representation: $value');
  }

  static bool _isIsoCode(String value) {
    final isoRegex = RegExp(r'^[A-Z]{3}$');
    return isoRegex.hasMatch(value);
  }

  static String? _isoCodeFromHex(Uint8List value) {
    final candidateIso = String.fromCharCodes(value);
    if (candidateIso == 'XRP') {
      throw XRPLBinaryCodecException(
          'Disallowed currency code: to indicate the currency XRP you must use 20 bytes of 0s');
    }
    return _isIsoCode(candidateIso) ? candidateIso : null;
  }

  static bool _isHex(String value) {
    final hexRegex = RegExp(r'^[A-F0-9]{40}$');
    return hexRegex.hasMatch(value);
  }

  static Uint8List _isoToBytes(String iso) {
    if (iso == 'XRP') {
      return Uint8List(20);
    }

    final isoBytes = ascii.encode(iso);
    return Uint8List.fromList([...Uint8List(12), ...isoBytes, ...Uint8List(5)]);
  }

  @override
  factory Currency.fromParser(BinaryParser parser, [int? lengthHint]) {
    final numBytes = lengthHint ?? Hash160.lengthBytes;
    final bytes = parser.read(numBytes);
    return Currency(bytes);
  }

  @override
  String toJson() {
    if (_iso != null) {
      return _iso!;
    }
    return bytesToHex(buffer).toUpperCase();
  }
}
