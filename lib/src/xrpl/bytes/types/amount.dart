part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class _AmoutUtils {
  static final BigRational maxXRP = BigRational.parseDecimal('1e17');
  static final BigRational minXRP = BigRational.parseDecimal('1e-6');
  static const List<String> iouAmountKeys = ["currency", "value", "issuer"];
  static const List<String> mptAssetNameKey = ["mpt_issuance_id", "value"];
  static final BigInt posSignBitMask =
      BigInt.parse('4000000000000000', radix: 16);
  static final BigInt zeroCurrencyAmountHex =
      BigInt.parse('8000000000000000', radix: 16);
  static final int nativeAmountByteLength = 8;
  static final int currencyAmountByteLength = 48;
  static final int mptAmountByteLength = 33;
  static final BigInt minIouExponent = BigInt.from(-96);
  static final BigInt maxIouExponent = BigInt.from(80);
  static const int maxIouPrecision = 16;
  static final BigInt ten = BigInt.from(10);
  static final BigInt minIouMantissa = ten.pow(15);
  static final BigInt maxIouMantissa = ten.pow(16) - BigInt.one;
  static final BigInt maxUint62 = BigInt.parse('4611686018427387903');

  static bool containsDecimal(String string) {
    return !string.contains('.');
  }

  static BigInt extractDigits(String input) {
    return BigInt.parse(input.runes
        .map((rune) => String.fromCharCode(rune))
        .where((char) => RegExp(r'\d').hasMatch(char))
        .map(int.parse)
        .toList()
        .join());
  }

  static void verifyXRPAmount(String xrpValue) {
    if (!containsDecimal(xrpValue)) {
      throw XRPLBinaryCodecException('$xrpValue is an invalid XRP amount.');
    }

    final BigRational decimal = BigRational.parseDecimal(xrpValue);
    if (decimal.toBigInt() == BigInt.zero) {
      return;
    }

    if (decimal < minXRP || decimal > maxXRP) {
      throw XRPLBinaryCodecException('$xrpValue is an invalid XRP amount.');
    }
  }

  static void verifyIouValue(String issuedCurrencyValue) {
    final BigRational? decimalValue =
        BigRational.tryParseDecimaal(issuedCurrencyValue);
    if (decimalValue == null) {
      throw const XRPLBinaryCodecException('Invalid issued currency amount');
    }
    if (decimalValue == BigRational.zero) {
      return;
    }
    if (decimalValue.precision > maxIouPrecision) {
      throw const XRPLBinaryCodecException(
          'Decimal precision out of range for issued currency value.');
    }

    verifyNoDecimal(decimalValue);
  }

  static void verifyNoDecimal(BigRational decimal) {
    final actualExponent = getDecimalComponents(decimal);

    if (actualExponent.$2 != 0) {
      String intNumberString = actualExponent.$1.toString();
      final BigRational exponent =
          BigRational.parseDecimal('1e${-(actualExponent.$2 - 15)}');
      intNumberString = (decimal * exponent).toDecimal();
      if (!containsDecimal(intNumberString)) {
        throw const XRPLBinaryCodecException(
            'Decimal place found in intNumberStr');
      }
    }
  }

  static (BigInt, int) getDecimalComponents(BigRational decimalValue) {
    final String decimalString = decimalValue.toDecimal();
    final BigInt digits = extractDigits(decimalString);
    final int exponent = decimalValue.scale;
    return (digits, (exponent == 0) ? 0 : -exponent);
  }

  static List<int> serializeIssuedCurrencyValue(String value) {
    verifyIouValue(value);
    final BigRational decimalValue = BigRational.parseDecimal(value);
    if (decimalValue == BigRational.zero) {
      return List<int>.from(
          [(zeroCurrencyAmountHex >> 56).toInt(), 0, 0, 0, 0, 0, 0, 0]);
    }
    final decimalComponet = getDecimalComponents(decimalValue);
    BigInt exponent = BigInt.from(decimalComponet.$2);
    BigInt mantissa = decimalComponet.$1;
    while (mantissa < minIouMantissa && exponent > minIouExponent) {
      mantissa *= ten;
      exponent -= BigInt.one;
    }

    while (mantissa > maxIouMantissa) {
      if (exponent >= maxIouExponent) {
        throw XRPLBinaryCodecException(
            'Amount overflow in issued currency value $value');
      }
      mantissa ~/= ten;
      exponent += BigInt.one;
    }
    if (exponent < minIouExponent || mantissa < minIouMantissa) {
      return [(zeroCurrencyAmountHex >> 56).toInt(), 0, 0, 0, 0, 0, 0, 0];
    }

    if (exponent > maxIouExponent || mantissa > maxIouMantissa) {
      throw XRPLBinaryCodecException(
          'Amount overflow in issued currency value $value');
    }
    BigInt serial = zeroCurrencyAmountHex;
    if (!decimalValue.isNegative) {
      serial |= posSignBitMask;
    }
    serial |= (exponent + BigInt.from(97)) << 54;
    serial |= mantissa;
    return BigintUtils.toBytes(serial, length: 8);
  }

  static List<int> serializeXRPAmount(String value) {
    verifyXRPAmount(value);

    final valueBigInt = BigInt.parse(value);
    final valueWithPosBit = valueBigInt | posSignBitMask;
    return BigintUtils.toBytes(valueWithPosBit, length: 8);
  }

  static List<int> serializeIssuedCurrencyAmount(Map<String, dynamic> value) {
    final List<int> amountBytes = serializeIssuedCurrencyValue(value['value']);
    final List<int> currencyBytes =
        Currency.fromValue(value['currency']).toBytes();
    final List<int> issuerBytes =
        AccountID.fromValue(value['issuer']).toBytes();
    return List<int>.from([...amountBytes, ...currencyBytes, ...issuerBytes]);
  }

  static List<int> serializeMPTAmount(Map<String, dynamic> value) {
    final BigInt? amount = BigintUtils.tryParse(value['value']);
    if (amount == null) {
      throw XRPLBinaryCodecException('Invalid MPTAmount ${value['value']}');
    }
    final List<int> amountBytes = BigintUtils.toBytes(amount, length: 8);
    final id = Hash192.fromValue(value["mpt_issuance_id"]);
    return List<int>.from([0x60, ...amountBytes, ...id.toBytes()]);
  }
}

class Amount extends SerializedType {
  Amount([List<int>? buffer]) : super(buffer ?? const []);

  @override
  factory Amount.fromValue(dynamic value) {
    try {
      if (value is String) {
        return Amount(_AmoutUtils.serializeXRPAmount(value));
      }
      final data = Map<String, dynamic>.from(value);
      final bool isMPT =
          _AmoutUtils.mptAssetNameKey.every((e) => data.containsKey(e));

      if (isMPT) {
        final mptBytes = _AmoutUtils.serializeMPTAmount(data);
        return Amount(mptBytes);
      }
      final bool isIOU =
          _AmoutUtils.iouAmountKeys.every((e) => data.containsKey(e));
      if (isIOU) {
        final iouBytes = _AmoutUtils.serializeIssuedCurrencyAmount(data);
        return Amount(iouBytes);
      }
    } on BlockchainUtilsException {
      rethrow;
    } catch (_) {}
    throw XRPLBinaryCodecException(
        'Invalid type to construct an Amount: expected String or Map, '
        'received ${value.runtimeType}.');
  }

  @override
  factory Amount.fromParser(BinaryParser parser, [int? lengthHint]) {
    final int firstBytes = parser.peek() ?? 0x00;
    final bool isIOU = (firstBytes & 0x80) != 0;
    if (isIOU) {
      return Amount(parser.read(_AmoutUtils.currencyAmountByteLength));
    }
    final bool isMpt = (firstBytes & 0x20) != 0;
    if (isMpt) {
      return Amount(parser.read(_AmoutUtils.mptAmountByteLength));
    }
    return Amount(parser.read(_AmoutUtils.nativeAmountByteLength));
  }

  bool isNative() {
    return (_buffer[0] & 0x80) == 0 && (_buffer[0] & 0x20) == 0;
  }

  bool isIOU() {
    return (_buffer[0] & 0x80) != 0;
  }

  bool isPositive() {
    return (_buffer[0] & 0x40) > 0;
  }

  bool isMpt() {
    return (_buffer[0] & 0x20) != 0 && _buffer[0] & 0x80 == 0;
  }

  @override
  dynamic toJson() {
    if (isNative()) {
      final BigInt amount =
          BigInt.parse(BytesUtils.toHexString(_buffer), radix: 16) &
              _AmoutUtils.maxUint62;
      return amount.toString();
    } else if (isIOU()) {
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
    } else if (isMpt()) {
      final BinaryParser parser = BinaryParser(_buffer);
      final int leadingByte = parser.readUint8();
      final valueBytes = parser.read(8);
      final id = Hash192.fromParser(parser);
      final int isPositive = leadingByte & 0x40;
      final value = BigintUtils.fromBytes(valueBytes);
      return {
        "mpt_issuance_id": id.toHex(),
        "value": isPositive > 0 ? value.toString() : "-$value"
      };
    } else {
      throw XRPLBinaryCodecException("Invalid amount bytes.");
    }
  }
}
