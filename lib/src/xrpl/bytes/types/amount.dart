part of 'package:xrp_dart/src/xrpl/bytes/serializer.dart';

class _AmoutUtils {
  static final BigRational _maxXrp = BigRational.parseDecimal('1e17');
  static final BigRational _minXrp = BigRational.parseDecimal('1e-6');
  static final BigInt _posSignBitMask =
      BigInt.parse("4000000000000000", radix: 16);
  static final BigInt _zeroCurrencyAmountHex =
      BigInt.parse("8000000000000000", radix: 16);
  static final BigInt _nativeAmountByteLength = BigInt.from(8);
  static final BigInt _currencyAmountByteLength = BigInt.from(48);
  static final BigInt minIouExponent = BigInt.from(-96);
  static final BigInt maxIouExponent = BigInt.from(80);
  static const int maxIouPrecision = 16;
  static final BigInt minIouMantissa = BigInt.from(10).pow(15);
  static final BigInt maxIouMantissa = BigInt.from(10).pow(16) - BigInt.one;

  static final BigInt maxUint62 = BigInt.parse("4611686018427387903");
  static bool _containsDecimal(String string) {
    return !string.contains('.');
  }

  static void verifyXrpValue(String xrpValue) {
    if (!_containsDecimal(xrpValue)) {
      throw XRPLBinaryCodecException('$xrpValue is an invalid XRP amount.');
    }

    BigRational decimal = BigRational.parseDecimal(xrpValue);
    if (decimal.toBigInt() == BigInt.zero) {
      return;
    }

    if (decimal < _minXrp || decimal > _maxXrp) {
      throw XRPLBinaryCodecException('$xrpValue is an invalid XRP amount.');
    }
  }

  static void verifyIouValue(String issuedCurrencyValue) {
    BigRational decimalValue = BigRational.parseDecimal(issuedCurrencyValue);
    if (decimalValue == BigRational.zero) {
      return;
    }
    if (decimalValue.precision > maxIouPrecision) {
      throw const XRPLBinaryCodecException(
          'Decimal precision out of range for issued currency value.');
    }

    _verifyNoDecimal(decimalValue);
  }

  static void _verifyNoDecimal(BigRational decimal) {
    final actualExponent = _getDecimalComponents(decimal);
    BigRational exponent =
        BigRational.parseDecimal("1e${-(actualExponent.$3 - 15)}");
    String intNumberString;
    if (actualExponent.$3 == 0) {
      intNumberString = actualExponent.$2.join("");
    } else {
      intNumberString = (decimal * exponent).toDecimal();
    }
    if (!_containsDecimal(intNumberString)) {
      throw const XRPLBinaryCodecException(
          'Decimal place found in intNumberStr');
    }
  }

  static (int, List<int>, int) _getDecimalComponents(BigRational decimalValue) {
    String decimalString = decimalValue.toDecimal();
    int sign = decimalString.startsWith('-') ? 1 : 0;
    String digitsAndExp =
        decimalString.split('e')[0].replaceAll('-', '').replaceAll('.', '');
    List<int> digits = digitsAndExp.runes
        .map((rune) => int.parse(String.fromCharCode(rune)))
        .toList();
    int exponent = decimalValue.scale;
    return (sign, digits, (exponent == 0) ? 0 : -exponent);
  }

  static List<int> _serializeIssuedCurrencyValue(String issueValue) {
    final String value = issueValue.toString();
    verifyIouValue(value);
    BigRational decimalValue = BigRational.parseDecimal(value);
    if (decimalValue == BigRational.zero) {
      return List<int>.from(
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
      return List<int>.from(
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

  static List<int> _serializeXrpAmount(String value) {
    verifyXrpValue(value);

    final valueBigInt = BigInt.parse(value);
    final valueWithPosBit = valueBigInt | _posSignBitMask;
    return _convertBigIntToBytes(valueWithPosBit);
  }

  static List<int> _convertBigIntToBytes(BigInt value) {
    final bytes = <int>[];
    try {
      for (int i = 7; i >= 0; i--) {
        final shift = 8 * i;
        bytes.add((value >> shift).toUnsigned(8).toInt());
      }
    } catch (e) {
      rethrow;
    }
    return bytes;
  }

  static List<int> _serializeIssuedCurrencyAmount(Map<String, dynamic> value) {
    List<int> amountBytes =
        _serializeIssuedCurrencyValue(value['value'] ?? value["Value"]);
    List<int> currencyBytes =
        Currency.fromValue(value['currency'] ?? value['Currency']).toBytes();
    List<int> issuerBytes =
        AccountID.fromValue(value['issuer'] ?? value["Issuer"]).toBytes();
    return List<int>.from([...amountBytes, ...currencyBytes, ...issuerBytes]);
  }
}

class Amount extends SerializedType {
  Amount([List<int>? buffer]) : super(buffer ?? List<int>.empty());

  @override
  factory Amount.fromValue(dynamic value) {
    if (value is String) {
      return Amount(_AmoutUtils._serializeXrpAmount(value));
    }
    if (value is Map) {
      return Amount(_AmoutUtils._serializeIssuedCurrencyAmount(
          value as Map<String, dynamic>));
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
      BigInt numBytes = notXrp != 0
          ? _AmoutUtils._currencyAmountByteLength
          : _AmoutUtils._nativeAmountByteLength;
      final read = parser.read(numBytes.toInt());
      final toAmount = Amount(read);
      return toAmount;
    } catch (e) {
      rethrow;
    }
  }

  bool isNative() {
    return (_buffer[0] & 0x80) == 0;
  }

  bool isPositive() {
    return (_buffer[0] & 0x40) > 0;
  }

  @override
  dynamic toJson() {
    if (isNative()) {
      BigInt maskedBytes =
          BigInt.parse(BytesUtils.toHexString(_buffer), radix: 16) &
              _AmoutUtils.maxUint62;
      return maskedBytes.toString();
    } else {
      BinaryParser parser = BinaryParser(_buffer);
      List<int> valueBytes = parser.read(8);
      String currency = Currency.fromParser(parser, null).toJson();
      String issuer = AccountID.fromParser(parser).toJson();

      int b1 = valueBytes[0];
      int b2 = valueBytes[1];
      bool isPositive = (b1 & 0x40) > 0;
      String sign = isPositive ? '' : '-';
      int exponent = ((b1 & 0x3F) << 2) + ((b2 & 0xFF) >> 6) - 97;
      String hexMantissa = (b2 & 0x3F).toRadixString(16) +
          BytesUtils.toHexString(valueBytes.sublist(2));
      int intMantissa = int.parse(hexMantissa, radix: 16);
      BigRational value = BigRational.parseDecimal('$sign$intMantissa') *
          BigRational.parseDecimal('1e$exponent');
      String valueStr = value == BigRational.zero ? '0' : value.toDecimal();
      _AmoutUtils.verifyIouValue(valueStr);

      return {'value': valueStr, 'currency': currency, 'issuer': issuer};
    }
  }
}
