part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class _Tuple3<L, M, R> {
  _Tuple3(this.item1, this.item2, this.item3);
  final L item1;
  final M item2;
  final R item3;
}

class _AmoutUtils {
  static final BigRational _maxXrp = BigRational.parseDecimal('1e17');
  static final BigRational _minXrp = BigRational.parseDecimal('1e-6');
  static final BigInt _posSignBitMask =
      BigInt.parse('4000000000000000', radix: 16);
  static final BigInt _zeroCurrencyAmountHex =
      BigInt.parse('8000000000000000', radix: 16);
  static final BigInt _nativeAmountByteLength = BigInt.from(8);
  static final BigInt _currencyAmountByteLength = BigInt.from(48);
  static final BigInt minIouExponent = BigInt.from(-96);
  static final BigInt maxIouExponent = BigInt.from(80);
  static const int maxIouPrecision = 16;
  static final BigInt minIouMantissa = BigInt.from(10).pow(15);
  static final BigInt maxIouMantissa = BigInt.from(10).pow(16) - BigInt.one;

  static final BigInt maxUint62 = BigInt.parse('4611686018427387903');
  static bool _containsDecimal(String string) {
    return !string.contains('.');
  }

  static void verifyXrpValue(String xrpValue) {
    if (!_containsDecimal(xrpValue)) {
      throw XRPLBinaryCodecException('$xrpValue is an invalid XRP amount.');
    }

    final BigRational decimal = BigRational.parseDecimal(xrpValue);
    if (decimal.toBigInt() == BigInt.zero) {
      return;
    }

    if (decimal < _minXrp || decimal > _maxXrp) {
      throw XRPLBinaryCodecException('$xrpValue is an invalid XRP amount.');
    }
  }

  static void verifyIouValue(String issuedCurrencyValue) {
    final BigRational decimalValue =
        BigRational.parseDecimal(issuedCurrencyValue);
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
    final BigRational exponent =
        BigRational.parseDecimal('1e${-(actualExponent.item3 - 15)}');
    String intNumberString;
    if (actualExponent.item3 == 0) {
      intNumberString = actualExponent.item2.join('');
    } else {
      intNumberString = (decimal * exponent).toDecimal();
    }
    if (!_containsDecimal(intNumberString)) {
      throw const XRPLBinaryCodecException(
          'Decimal place found in intNumberStr');
    }
  }

  static _Tuple3<int, List<int>, int> _getDecimalComponents(
      BigRational decimalValue) {
    final String decimalString = decimalValue.toDecimal();
    final int sign = decimalString.startsWith('-') ? 1 : 0;
    final String digitsAndExp =
        decimalString.split('e')[0].replaceAll('-', '').replaceAll('.', '');
    final List<int> digits = digitsAndExp.runes
        .map((rune) => int.parse(String.fromCharCode(rune)))
        .toList();
    final int exponent = decimalValue.scale;
    return _Tuple3(sign, digits, (exponent == 0) ? 0 : -exponent);
  }

  static List<int> _serializeIssuedCurrencyValue(String issueValue) {
    final String value = issueValue.toString();
    verifyIouValue(value);
    final BigRational decimalValue = BigRational.parseDecimal(value);
    if (decimalValue == BigRational.zero) {
      return List<int>.from(
          [(_zeroCurrencyAmountHex >> 56).toInt(), 0, 0, 0, 0, 0, 0, 0]);
    }
    final decimalComponet = _getDecimalComponents(decimalValue);
    BigInt exponent = BigInt.from(decimalComponet.item3);
    BigInt mantissa = BigInt.parse(decimalComponet.item2.join());
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
    if (decimalComponet.item1 == 0) {
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
    final List<int> amountBytes =
        _serializeIssuedCurrencyValue(value['value'] ?? value['Value']);
    final List<int> currencyBytes =
        Currency.fromValue(value['currency'] ?? value['Currency']).toBytes();
    final List<int> issuerBytes =
        AccountID.fromValue(value['issuer'] ?? value['Issuer']).toBytes();
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
      final int? parserFirstByte = parser.peek();

      final int notXrp = (parserFirstByte ?? 0x00) & 0x80;
      final BigInt numBytes = notXrp != 0
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
      final BigInt maskedBytes =
          BigInt.parse(BytesUtils.toHexString(_buffer), radix: 16) &
              _AmoutUtils.maxUint62;
      return maskedBytes.toString();
    } else {
      final BinaryParser parser = BinaryParser(_buffer);
      final List<int> valueBytes = parser.read(8);
      final String currency = Currency.fromParser(parser, null).toJson();
      final String issuer = AccountID.fromParser(parser).toJson();

      final int b1 = valueBytes[0];
      final int b2 = valueBytes[1];
      final bool isPositive = (b1 & 0x40) > 0;
      final String sign = isPositive ? '' : '-';
      final int exponent = ((b1 & 0x3F) << 2) + ((b2 & 0xFF) >> 6) - 97;
      final String hexMantissa = (b2 & 0x3F).toRadixString(16) +
          BytesUtils.toHexString(valueBytes.sublist(2));
      final int intMantissa = int.parse(hexMantissa, radix: 16);
      final BigRational value = BigRational.parseDecimal('$sign$intMantissa') *
          BigRational.parseDecimal('1e$exponent');
      final String valueStr =
          value == BigRational.zero ? '0' : value.toDecimal();
      _AmoutUtils.verifyIouValue(valueStr);

      return {'value': valueStr, 'currency': currency, 'issuer': issuer};
    }
  }
}
