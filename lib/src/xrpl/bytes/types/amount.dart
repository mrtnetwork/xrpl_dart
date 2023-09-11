part of 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';

final Decimal _maxXrp = Decimal.parse('1e17');
final Decimal _minXrp = Decimal.parse('1e-6');
final BigInt _posSignBitMask = BigInt.parse("4000000000000000", radix: 16);
final BigInt _zeroCurrencyAmountHex =
    BigInt.parse("8000000000000000", radix: 16);
final BigInt _nativeAmountByteLength = BigInt.from(8);
final BigInt _currencyAmountByteLength = BigInt.from(48);
final BigInt minIouExponent = BigInt.from(-96);
final BigInt maxIouExponent = BigInt.from(80);
const int maxIouPrecision = 16;
final BigInt minIouMantissa = BigInt.from(10).pow(15);
final BigInt maxIouMantissa = BigInt.from(10).pow(16) - BigInt.one;

bool _containsDecimal(String string) {
  return !string.contains('.');
}

void verifyXrpValue(String xrpValue) {
  if (!_containsDecimal(xrpValue)) {
    throw XRPLBinaryCodecException('$xrpValue is an invalid XRP amount.');
  }

  Decimal decimal = Decimal.parse(xrpValue);
  if (decimal.toBigInt() == BigInt.zero) {
    return;
  }

  if (decimal < _minXrp || decimal > _maxXrp) {
    throw XRPLBinaryCodecException('$xrpValue is an invalid XRP amount.');
  }
}

void verifyIouValue(String issuedCurrencyValue) {
  Decimal decimalValue = Decimal.parse(issuedCurrencyValue);
  if (decimalValue == Decimal.zero) {
    return;
  }
  if (decimalValue.precision > maxIouPrecision) {
    throw XRPLBinaryCodecException(
        'Decimal precision out of range for issued currency value.');
  }

  _verifyNoDecimal(decimalValue);
}

void _verifyNoDecimal(Decimal decimal) {
  final actualExponent = _getDecimalComponents(decimal);
  Decimal exponent = Decimal.parse("1e${-(actualExponent.$3 - 15)}");
  String intNumberString;
  if (actualExponent.$3 == 0) {
    intNumberString = actualExponent.$2.join("");
  } else {
    intNumberString = (decimal * exponent).toString();
  }
  if (!_containsDecimal(intNumberString)) {
    throw XRPLBinaryCodecException('Decimal place found in intNumberStr');
  }
}

(int, List<int>, int) _getDecimalComponents(Decimal decimalValue) {
  String decimalString = decimalValue.toString();
  int sign = decimalString.startsWith('-') ? 1 : 0;
  String digitsAndExp =
      decimalString.split('e')[0].replaceAll('-', '').replaceAll('.', '');
  List<int> digits = digitsAndExp.runes
      .map((rune) => int.parse(String.fromCharCode(rune)))
      .toList();
  int exponent = decimalValue.scale;
  return (sign, digits, (exponent == 0) ? 0 : -exponent);
}

Uint8List _serializeIssuedCurrencyValue(String issueValue) {
  final String value = issueValue.toString();
  verifyIouValue(value);
  Decimal decimalValue = Decimal.parse(value);
  if (decimalValue == Decimal.zero) {
    return Uint8List.fromList(
        [(_zeroCurrencyAmountHex >> 56).toInt(), 0, 0, 0, 0, 0, 0, 0]);
  }
  final decimalComponet = _getDecimalComponents(decimalValue);
  BigInt exponent = BigInt.from(decimalComponet.$3);
  BigInt mantissa = BigInt.parse(decimalComponet.$2.join());
  while (mantissa < minIouMantissa && exponent > minIouExponent) {
    mantissa *= BigInt.from(10);
    exponent -= BigInt.one;
  }

  while (mantissa > maxIouMantissa) {
    if (exponent >= maxIouExponent) {
      throw XRPLBinaryCodecException(
          'Amount overflow in issued currency value $value');
    }
    mantissa ~/= BigInt.from(10);
    exponent += BigInt.one;
  }
  if (exponent < minIouExponent || mantissa < minIouMantissa) {
    return Uint8List.fromList(
        [(_zeroCurrencyAmountHex >> 56).toInt(), 0, 0, 0, 0, 0, 0, 0]);
  }

  if (exponent > maxIouExponent || mantissa > maxIouMantissa) {
    throw XRPLBinaryCodecException(
        'Amount overflow in issued currency value $value');
  }
  BigInt serial = _zeroCurrencyAmountHex;
  if (decimalComponet.$1 == 0) {
    serial |= _posSignBitMask;
  }
  serial |= (exponent + BigInt.from(97)) << 54;
  serial |= mantissa;
  return _convertBigIntToBytes(serial);
}

Uint8List _serializeXrpAmount(String value) {
  verifyXrpValue(value);

  final valueBigInt = BigInt.parse(value);
  final valueWithPosBit = valueBigInt | _posSignBitMask;
  return _convertBigIntToBytes(valueWithPosBit);
}

Uint8List _convertBigIntToBytes(BigInt value) {
  final bytes = <int>[];
  try {
    for (int i = 7; i >= 0; i--) {
      final shift = 8 * i;
      bytes.add((value >> shift).toUnsigned(8).toInt());
    }
  } catch (e) {
    rethrow;
  }
  return Uint8List.fromList(bytes);
}

Uint8List _serializeIssuedCurrencyAmount(Map<String, dynamic> value) {
  Uint8List amountBytes =
      _serializeIssuedCurrencyValue(value['value'] ?? value["Value"]);
  Uint8List currencyBytes =
      Currency.fromValue(value['currency'] ?? value['Currency']).toBytes();
  Uint8List issuerBytes =
      AccountID.fromValue(value['issuer'] ?? value["Issuer"]).toBytes();
  return Uint8List.fromList([...amountBytes, ...currencyBytes, ...issuerBytes]);
}

class Amount extends SerializedType {
  Amount([Uint8List? buffer]) : super(buffer ?? Uint8List(0));

  @override
  factory Amount.fromValue(dynamic value) {
    if (value is String) {
      return Amount(_serializeXrpAmount(value));
    }
    if (value is Map) {
      return Amount(
          _serializeIssuedCurrencyAmount(value as Map<String, dynamic>));
    }

    throw XRPLBinaryCodecException(
        'Invalid type to construct an Amount: expected String or Map, '
        'received ${value.runtimeType}.');
  }

  @override
  factory Amount.fromParser(BinaryParser parser, [int? lengthHint]) {
    try {
      int? parserFirstByte = parser.peek();

      int notXrp = (parserFirstByte ?? 0x00) & 0x80;
      BigInt numBytes =
          notXrp != 0 ? _currencyAmountByteLength : _nativeAmountByteLength;
      final read = parser.read(numBytes.toInt());
      final toAmount = Amount(read);
      return toAmount;
    } catch (e) {
      rethrow;
    }
  }

  bool isNative() {
    return (buffer[0] & 0x80) == 0;
  }

  bool isPositive() {
    return (buffer[0] & 0x40) > 0;
  }

  @override
  dynamic toJson() {
    if (isNative()) {
      BigInt maskedBytes = BigInt.parse(bytesToHex(buffer), radix: 16) &
          BigInt.from(0x3FFFFFFFFFFFFFFF);
      return maskedBytes.toString();
    } else {
      BinaryParser parser = BinaryParser(toHex());
      Uint8List valueBytes = parser.read(8);
      String currency = Currency.fromParser(parser, null).toJson();
      String issuer = AccountID.fromParser(parser).toJson();

      int b1 = valueBytes[0];
      int b2 = valueBytes[1];
      bool isPositive = (b1 & 0x40) > 0;
      String sign = isPositive ? '' : '-';
      int exponent = ((b1 & 0x3F) << 2) + ((b2 & 0xFF) >> 6) - 97;
      String hexMantissa =
          (b2 & 0x3F).toRadixString(16) + bytesToHex(valueBytes.sublist(2));
      int intMantissa = int.parse(hexMantissa, radix: 16);
      Decimal value =
          Decimal.parse('$sign$intMantissa') * Decimal.parse('1e$exponent');
      String valueStr = value == Decimal.zero ? '0' : value.toString();
      verifyIouValue(valueStr);

      return {
        'value': valueStr,
        'currency': currency,
        'issuer': issuer,
      };
    }
  }
}
