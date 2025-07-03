import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

class IssuedCurrencyUtils {
  static const List<String> issuedCurrencyAmountFields = [
    "currency",
    "issuer",
    "value"
  ];
  static bool isIssuedCurrencyAmount(Map<String, dynamic> json) {
    for (final i in json.keys) {
      if (!issuedCurrencyAmountFields.contains(i)) return false;
    }
    if (!json.containsKey("currency")) {
      return false;
    }
    return true;
  }
}

/// An abstract class representing different currencies in the XRP Ledger.
abstract class BaseCurrency {
  /// Converts the object to a JSON representation.
  Map<String, dynamic> toJson();

  /// Factory method to create an instance of BaseCurrency from JSON.
  ///
  /// The [json] parameter represents the JSON data to parse.
  /// If the currency is "XRP", returns an instance of XRP.
  /// Otherwise, returns an instance of IssuedCurrency.
  factory BaseCurrency.fromJson(Map<String, dynamic> json) {
    if (json["mpt_issuance_id"] != null) {
      return MTPCurrency.fromJson(json);
    }
    if (json['currency'] == 'XRP') {
      return XRPCurrency();
    }
    return IssuedCurrency.fromJson(json);
  }
  bool get isXrp;
}

/// Represents a currency issued on the XRP Ledger with a specific issuer.
class IssuedCurrency extends XRPLBase implements BaseCurrency {
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

/// Represents the XRP (native currency) on the XRP Ledger.
class XRPCurrency extends XRPLBase implements BaseCurrency {
  /// Private constructor for creating a singleton instance of XRP.
  XRPCurrency._();

  /// Singleton instance of XRP.
  static final _currency = XRPCurrency._();

  /// Factory method to retrieve the singleton instance of XRP.
  factory XRPCurrency() {
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

class MTPCurrency extends XRPLBase implements BaseCurrency {
  final String mptIssuanceId;
  const MTPCurrency({required this.mptIssuanceId});
  MTPCurrency.fromJson(Map<String, dynamic> json)
      : mptIssuanceId = json["mpt_issuance_id"];
  @override
  bool get isXrp => false;

  @override
  Map<String, dynamic> toJson() {
    return {"mpt_issuance_id": mptIssuanceId};
  }
}

enum AmountType {
  native,
  issue,
  mpt;

  bool get isXRP => this == native;
}

abstract class BaseAmount<T> {
  AmountType get type;
  BigRational get rational;
  T get value;

  BaseCurrency toCurrency();
  dynamic toJson();
  const BaseAmount();
  factory BaseAmount.fromJson(dynamic json) {
    if (json is Map) {
      if (json.containsKey("mpt_issuance_id")) {
        return MPTAmount.fromJson(json as Map<String, dynamic>)
            as BaseAmount<T>;
      }
      return IssuedCurrencyAmount.fromJson(json as Map<String, dynamic>)
          as BaseAmount<T>;
    }
    return XRPAmount(BigintUtils.parse(json)) as BaseAmount<T>;
  }
}

abstract class NONXRPAmount<T> implements BaseAmount<T> {
  const NONXRPAmount();
}

/// Represents an amount of a specific issued currency on the XRP Ledger.
class IssuedCurrencyAmount extends IssuedCurrency
    implements NONXRPAmount<String> {
  /// Creates an instance of [IssuedCurrencyAmount].
  ///
  /// The [value] parameter represents the numeric value of the amount.
  IssuedCurrencyAmount._(
      {required super.currency, required super.issuer, required this.value});

  /// The numeric value of the amount.
  @override
  final String value;

  /// The rational representation of the numeric value.
  @override
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

  /// Converts the amount to an [BaseCurrency] object with the same currency and issuer.
  @override
  BaseCurrency toCurrency() =>
      IssuedCurrency(currency: currency, issuer: issuer);

  @override
  AmountType get type => AmountType.issue;
}

class XRPAmount extends BaseAmount<BigInt> {
  @override
  final BigInt value;
  XRPAmount(this.value);
  @override
  late final BigRational rational = BigRational(value);
  @override
  BaseCurrency toCurrency() {
    return XRPCurrency();
  }

  @override
  toJson() {
    return value.toString();
  }

  @override
  AmountType get type => AmountType.native;
}

// /// Represents an amount of currency, which can be either XRP or an issued currency.
// class BaseAmount {
//   /// Private constructor for creating an instance of BaseAmount.
//   BaseAmount._(this.xrp, this.isseAmount, this.mptAmount);

//   /// Factory method to create an instance of BaseAmount from JSON data.
//   ///
//   /// The [json] parameter represents the JSON data to parse.
// factory BaseAmount.fromJson(dynamic json) {
//   if (json is Map) {
//     if (json.containsKey("mpt_issuance_id")) {
//       return BaseAmount._(
//           null, null, MPTAmount.fromJson(json as Map<String, dynamic>));
//     }
//     return BaseAmount._(null,
//         IssuedCurrencyAmount.fromJson(json as Map<String, dynamic>), null);
//   }
//   return BaseAmount._(BigintUtils.tryParse(json)!, null, null);
// }

//   /// Creates an instance of BaseAmount with XRP value.
//   XRPAmount(BigInt this.xrp)
//       : isseAmount = null,
//         mptAmount = null;

//   /// Creates an instance of BaseAmount with issued currency value.
//   BaseAmount.issue(IssuedCurrencyAmount this.isseAmount)
//       : xrp = null,
//         mptAmount = null;

//   BaseAmount.mtp(MPTAmount this.mptAmount)
//       : xrp = null,
//         isseAmount = null;

//   /// The XRP value of the amount.
//   final BigInt? xrp;

//   /// The issued currency amount.
//   final IssuedCurrencyAmount? isseAmount;

//   final MPTAmount? mptAmount;

//   /// Indicates whether the amount is negative.
//   bool get isNegative => xrp?.isNegative ?? isseAmount!.isNegative;

//   /// Indicates whether the amount is zero.
//   bool get isZero => xrp == null ? isseAmount!.isZero : xrp == BigInt.zero;

//   /// Indicates whether the amount is in XRP.
//   bool get isXrp => xrp != null;

//   /// Converts the object to JSON representation.
//   dynamic toJson() {
//     return xrp?.toString() ?? isseAmount?.toJson() ?? mptAmount?.toJson();
//   }

//   /// Converts the amount to an [BaseCurrency] object.
//   BaseCurrency toCurrency() => isXrp ? XRPCurrency() : isseAmount!.toCurrency();

//   @override
//   String toString() {
//     return toJson().toString();
//   }
// }

class MPTAmountUtils {
  static const List<String> fieldsNames = ["value", "mpt_issuance_id"];
  static bool isMptAmount(Map<String, dynamic> json) {
    for (final i in json.keys) {
      if (!fieldsNames.contains(i)) return false;
    }
    for (final i in fieldsNames) {
      if (json[i] == null) return false;
    }
    return true;
  }
}

class MPTAmount extends MTPCurrency implements BaseAmount<String> {
  @override
  final String value;
  MPTAmount({required super.mptIssuanceId, required this.value});

  @override
  late final BigRational rational = BigRational(BigInt.parse(value));
  MPTAmount.fromJson(super.json)
      : value = json["value"],
        super.fromJson();

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), "value": value};
  }

  @override
  BaseCurrency toCurrency() {
    return this;
  }

  @override
  AmountType get type => AmountType.mpt;
}
