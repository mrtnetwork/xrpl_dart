part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class _AmoutUtils {
  static BigRational get maxXRP => BigRational.parseDecimal('1e17');
  static BigRational get minXRP => BigRational.parseDecimal('1e-6');
  static const List<String> iouAmountKeys = ["currency", "value", "issuer"];
  static const List<String> mptAssetNameKey = ["mpt_issuance_id", "value"];
  static BigInt get posSignBitMask =>
      BigInt.parse('4000000000000000', radix: 16);
  static BigInt get zeroCurrencyAmountHex =>
      BigInt.parse('8000000000000000', radix: 16);
  static const int nativeAmountByteLength = 8;
  static const int currencyAmountByteLength = 48;
  static const int mptAmountByteLength = 33;
  static BigInt get minIouExponent => BigInt.from(-96);
  static BigInt get maxIouExponent => BigInt.from(80);
  static const int maxIouPrecision = 16;
  static BigInt get ten => BigInt.from(10);
  static BigInt get minIouMantissa => ten.pow(15);
  static BigInt get maxIouMantissa => ten.pow(16) - BigInt.one;
  static BigInt get maxUint62 => BigInt.parse('4611686018427387903');

  static bool containsDecimal(String string) {
    return !string.contains('.');
  }

  static BigInt extractDigits(String input) {
    final digits =
        input.runes
            .map((rune) => String.fromCharCode(rune))
            .where((char) => RegExp(r'\d').hasMatch(char))
            .map(IntUtils.parse)
            .toList()
            .join();
    return BigintUtils.parse(digits);
  }

  static void verifyXRPAmount(String xrpValue) {
    if (!containsDecimal(xrpValue)) {
      throw BuError(
        DefaultErrorType.invalidArgument,
        '$xrpValue is an invalid XRP amount.',
      );
    }

    final BigRational decimal = BigRational.parseDecimal(xrpValue);
    if (decimal.toBigInt() == BigInt.zero) {
      return;
    }

    if (decimal < minXRP || decimal > maxXRP) {
      throw BuError(
        DefaultErrorType.invalidArgument,
        '$xrpValue is an invalid XRP amount.',
      );
    }
  }

  static void verifyIouValue(String issuedCurrencyValue) {
    final BigRational? decimalValue = BigRational.tryParse(issuedCurrencyValue);
    if (decimalValue == null) {
      throw BuError(
        DefaultErrorType.invalidArgument,
        'Invalid issued currency amount $issuedCurrencyValue.',
      );
    }
    if (decimalValue == BigRational.zero) {
      return;
    }
    if (decimalValue.precision > maxIouPrecision) {
      throw const BuError(
        DefaultErrorType.invalidArgument,
        'Decimal precision out of range for issued currency value.',
      );
    }

    verifyNoDecimal(decimalValue);
  }

  static void verifyNoDecimal(BigRational decimal) {
    final actualExponent = getDecimalComponents(decimal);

    if (actualExponent.$2 != 0) {
      String intNumberString = actualExponent.$1.toString();
      final BigRational exponent = BigRational.parseDecimal(
        '1e${-(actualExponent.$2 - 15)}',
      );
      intNumberString = (decimal * exponent).toDecimal();
      if (!containsDecimal(intNumberString)) {
        throw BuError(
          DefaultErrorType.invalidArgument,
          'Decimal place found in issued currency value $decimal.',
        );
      }
    }
  }

  static (BigInt, int) getDecimalComponents(BigRational decimalValue) {
    final String decimalString = decimalValue.toDecimal();
    final BigInt digits = extractDigits(decimalString);
    final int exponent = decimalValue.scale;
    return (digits, (exponent == 0) ? 0 : -exponent);
  }

  static BuBytes serializeIssuedCurrencyValue(String value) {
    verifyIouValue(value);
    final BigRational decimalValue = BigRational.parseDecimal(value);
    if (decimalValue == BigRational.zero) {
      return [
        (zeroCurrencyAmountHex >> 56).toInt(),
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ].asImmutableBytes;
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
        throw BuError(
          DefaultErrorType.invalidArgument,
          'Amount overflow in issued currency value $value',
        );
      }
      mantissa ~/= ten;
      exponent += BigInt.one;
    }
    if (exponent < minIouExponent || mantissa < minIouMantissa) {
      return [
        (zeroCurrencyAmountHex >> 56).toInt(),
        0,
        0,
        0,
        0,
        0,
        0,
        0,
      ].asImmutableBytes;
    }

    if (exponent > maxIouExponent || mantissa > maxIouMantissa) {
      throw BuError(
        DefaultErrorType.invalidArgument,
        'Amount overflow in issued currency value $value',
      );
    }
    BigInt serial = zeroCurrencyAmountHex;
    if (!decimalValue.isNegative) {
      serial |= posSignBitMask;
    }
    serial |= (exponent + BigInt.from(97)) << 54;
    serial |= mantissa;
    return serial.toBeBytes(length: 8);
  }

  static BuBytes serializeXRPAmount(String value) {
    verifyXRPAmount(value);
    final valueBigInt = BigintUtils.parse(value);
    final valueWithPosBit = valueBigInt | posSignBitMask;
    return valueWithPosBit.toBeBytes(length: 8);
  }

  static BuBytes serializeIssuedCurrencyAmount(Map<String, dynamic> value) {
    final List<int> amountBytes = serializeIssuedCurrencyValue(value['value']);
    final List<int> currencyBytes =
        Currency.fromValue(value['currency']).toBytes();
    final List<int> issuerBytes =
        AccountID.fromValue(value['issuer']).toBytes();
    return [...amountBytes, ...currencyBytes, ...issuerBytes].asImmutableBytes;
  }

  static BuBytes serializeMPTAmount(Map<String, dynamic> value) {
    final BigInt? amount = BigintUtils.tryParse(value['value']);
    if (amount == null) {
      throw BuError(
        DefaultErrorType.invalidArgument,
        'Invalid MPTAmount ${value['value']}',
      );
    }
    final List<int> amountBytes = amount.toBeBytes(length: 8);
    final id = Hash192.fromValue(value["mpt_issuance_id"]);
    return [0x60, ...amountBytes, ...id.toBytes()].asImmutableBytes;
  }
}

class Amount extends SerializedType {
  Amount([List<int>? buffer]) : super(buffer ?? const []);

  factory Amount.fromValue(dynamic value) {
    try {
      if (value is String) {
        return Amount(_AmoutUtils.serializeXRPAmount(value));
      }
      final data = Map<String, dynamic>.from(value);
      final bool isMPT = _AmoutUtils.mptAssetNameKey.every(
        (e) => data.containsKey(e),
      );

      if (isMPT) {
        final mptBytes = _AmoutUtils.serializeMPTAmount(data);
        return Amount(mptBytes);
      }
      final bool isIOU = _AmoutUtils.iouAmountKeys.every(
        (e) => data.containsKey(e),
      );
      if (isIOU) {
        final iouBytes = _AmoutUtils.serializeIssuedCurrencyAmount(data);
        return Amount(iouBytes);
      }
    } on BuError {
      rethrow;
    } catch (_) {}
    throw BuError(
      DefaultErrorType.castFailed,
      'Invalid type to construct an Amount: expected String or Map, '
      'received ${value.runtimeType}.',
    );
  }

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
    if (_buffer.isEmpty) {
      throw const BuError(
        DefaultErrorType.invalidArgument,
        'Invalid amount bytes: buffer is empty.',
      );
    }
    if (isNative()) {
      final BigInt amount =
          BigintUtils.fromBytes(_buffer) & _AmoutUtils.maxUint62;
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
      final String hexMantissa =
          (b2 & 0x3F).toRadixString(16).padLeft(2, '0') +
          BytesUtils.toHexString(valueBytes.sublist(2));
      final int intMantissa = IntUtils.parse('0x$hexMantissa');
      final BigRational value =
          BigRational.parseDecimal('$sign$intMantissa') *
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
        "value": isPositive > 0 ? value.toString() : "-$value",
      };
    } else {
      throw BuError(
        DefaultErrorType.invalidArgument,
        'Invalid amount bytes: leading byte 0x${_buffer[0].toRadixString(16).padLeft(2, '0')} matches neither native, IOU nor MPT amount.',
      );
    }
  }
}
