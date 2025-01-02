import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// An abstract class representing different currencies in the XRP Ledger.
abstract class XRPCurrencies {
  /// Converts the object to a JSON representation.
  Map<String, dynamic> toJson();

  /// Factory method to create an instance of XRPCurrencies from JSON.
  ///
  /// The [json] parameter represents the JSON data to parse.
  /// If the currency is "XRP", returns an instance of XRP.
  /// Otherwise, returns an instance of IssuedCurrency.
  factory XRPCurrencies.fromJson(Map<String, dynamic> json) {
    if (json['currency'] == 'XRP') {
      return XRP();
    }
    return IssuedCurrency.fromJson(json);
  }
  bool get isXrp;
}

/// Represents a currency issued on the XRP Ledger with a specific issuer.
class IssuedCurrency extends XRPLBase implements XRPCurrencies {
  /// Creates an instance of [IssuedCurrency] with the specified currency and issuer.
  IssuedCurrency({required this.currency, required this.issuer});

  /// Creates an instance of [IssuedCurrency] from JSON data.
  ///
  /// The [json] parameter represents the JSON data to parse.
  IssuedCurrency.fromJson(Map<String, dynamic> json)
      : currency = json['currency'],
        issuer = json['issuer'];

  /// The currency code of the issued currency.
  final String currency;

  /// The issuer's address associated with the issued currency.
  final String issuer;

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {'currency': currency, 'issuer': issuer};
  }

  /// Converts the issued currency to an [IssuedCurrencyAmount] with the specified value.
  IssuedCurrencyAmount toAmount(String value) {
    return IssuedCurrencyAmount(
        currency: currency, issuer: issuer, value: value);
  }

  /// Checks if two instances of IssuedCurrency are equal.
  @override
  bool operator ==(other) {
    return other is IssuedCurrency &&
        currency == other.currency &&
        issuer == other.issuer &&
        runtimeType == other.runtimeType;
  }

  /// Calculates the hash code for the IssuedCurrency instance.
  @override
  int get hashCode => currency.hashCode ^ issuer.hashCode;

  /// Indicates whether the currency is XRP.
  @override
  bool get isXrp => false;
}

/// Represents an amount of a specific issued currency on the XRP Ledger.
class IssuedCurrencyAmount extends IssuedCurrency {
  /// Creates an instance of [IssuedCurrencyAmount].
  ///
  /// The [value] parameter represents the numeric value of the amount.
  IssuedCurrencyAmount._(
      {required super.currency, required super.issuer, required this.value});

  /// The numeric value of the amount.
  final String value;

  /// The rational representation of the numeric value.
  late final BigRational rational = BigRational.parseDecimal(value);

  /// Indicates whether the amount is negative.
  bool get isNegative => rational.isNegative;

  /// Indicates whether the amount is zero.
  bool get isZero => rational.isZero;

  /// Creates an instance of [IssuedCurrencyAmount] from JSON data.
  IssuedCurrencyAmount.fromJson(super.json)
      : value = json['value'],
        super.fromJson();

  /// Factory method to create an instance of [IssuedCurrencyAmount].
  ///
  /// The [value], [currency], and [issuer] parameters represent the components of the amount.
  factory IssuedCurrencyAmount(
      {required String value,
      required String currency,
      required String issuer}) {
    return IssuedCurrencyAmount._(
        currency: currency, issuer: issuer, value: value);
  }

  /// Checks if the provided JSON data represents valid currency details.
  static bool isValidCurrencyDetails(dynamic json) {
    if (json is! Map) return false;
    try {
      if (!XRPAddressUtils.isClassicAddress(json['issuer'])) {
        return false;
      }
      return json['value'] is String && json['currency'] is String;
    } catch (e) {
      return false;
    }
  }

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), 'value': value};
  }

  /// Converts the amount to an [XRPCurrencies] object with the same currency and issuer.
  XRPCurrencies toCurrency() =>
      IssuedCurrency(currency: currency, issuer: issuer);
}

/// Represents the XRP (native currency) on the XRP Ledger.
class XRP extends XRPLBase implements XRPCurrencies {
  /// Private constructor for creating a singleton instance of XRP.
  XRP._();

  /// Singleton instance of XRP.
  static final _currency = XRP._();

  /// Factory method to retrieve the singleton instance of XRP.
  factory XRP() {
    return _currency;
  }

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {'currency': 'XRP'};
  }

  /// Indicates whether the currency is XRP.
  @override
  bool get isXrp => true;

  /// Equality operator to compare with the singleton instance of XRP.
  @override
  bool operator ==(other) {
    return identical(this, other);
  }

  @override
  int get hashCode => _currency.hashCode;
}

/// Represents an amount of currency, which can be either XRP or an issued currency.
class CurrencyAmount {
  /// Private constructor for creating an instance of CurrencyAmount.
  CurrencyAmount._(this.xrp, this.isseAmount);

  /// Factory method to create an instance of CurrencyAmount from JSON data.
  ///
  /// The [json] parameter represents the JSON data to parse.
  factory CurrencyAmount.fromJson(dynamic json) {
    if (json is Map) {
      return CurrencyAmount._(
          null, IssuedCurrencyAmount.fromJson(json as Map<String, dynamic>));
    }
    return CurrencyAmount._(BigintUtils.tryParse(json)!, null);
  }

  /// Creates an instance of CurrencyAmount with XRP value.
  CurrencyAmount.xrp(BigInt this.xrp) : isseAmount = null;

  /// Creates an instance of CurrencyAmount with issued currency value.
  CurrencyAmount.issue(IssuedCurrencyAmount this.isseAmount) : xrp = null;

  /// The XRP value of the amount.
  final BigInt? xrp;

  /// The issued currency amount.
  final IssuedCurrencyAmount? isseAmount;

  /// Indicates whether the amount is negative.
  bool get isNegative => xrp?.isNegative ?? isseAmount!.isNegative;

  /// Indicates whether the amount is zero.
  bool get isZero => xrp == null ? isseAmount!.isZero : xrp == BigInt.zero;

  /// Indicates whether the amount is in XRP.
  bool get isXrp => xrp != null;

  /// Converts the object to JSON representation.
  dynamic toJson() {
    return xrp?.toString() ?? isseAmount!.toJson();
  }

  /// Converts the amount to an [XRPCurrencies] object.
  XRPCurrencies toCurrency() => isXrp ? XRP() : isseAmount!.toCurrency();

  @override
  String toString() {
    return toJson().toString();
  }
}
