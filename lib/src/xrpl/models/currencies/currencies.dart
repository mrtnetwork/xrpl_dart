import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/xrpl/address_utilities.dart';
import 'package:xrp_dart/src/xrpl/models/base.dart';

abstract class XRPCurrencies {
  Map<String, dynamic> toJson();
  factory XRPCurrencies.fromJson(Map<String, dynamic> json) {
    if (json["currency"] == "XRP") {
      return XRP();
    }
    return IssuedCurrency.fromJson(json);
  }
}

class IssuedCurrency extends XRPLBase implements XRPCurrencies {
  IssuedCurrency({required this.currency, required this.issuer});
  IssuedCurrency.fromJson(Map<String, dynamic> json)
      : currency = json["currency"],
        issuer = json["issuer"];
  final String currency;
  final String issuer;

  @override
  Map<String, dynamic> toJson() {
    return {"currency": currency, "issuer": issuer};
  }

  IssuedCurrencyAmount toAmount(String value) {
    return IssuedCurrencyAmount(
        currency: currency, issuer: issuer, value: value);
  }
}

class IssuedCurrencyAmount extends IssuedCurrency {
  IssuedCurrencyAmount._(
      {required super.currency, required super.issuer, required this.value});
  final String value;
  IssuedCurrencyAmount.fromJson(Map<String, dynamic> json)
      : value = json["value"],
        super.fromJson(json);
  factory IssuedCurrencyAmount(
      {required String value,
      required String currency,
      required String issuer}) {
    return IssuedCurrencyAmount._(
        currency: currency, issuer: issuer, value: value);
  }

  static bool isValidCurrencyDetails(dynamic json) {
    if (json is! Map) return false;
    try {
      if (!XRPAddressUtilities.isValidClassicAddress(json["issuer"])) {
        return false;
      }
      return json["value"] is String && json["currency"] is String;
    } catch (e) {
      return false;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), "value": value};
  }

  IssuedCurrency toCurrency() =>
      IssuedCurrency(currency: currency, issuer: issuer);
}

class XRP extends XRPLBase implements XRPCurrencies {
  XRP._();
  static final _currency = XRP._();
  factory XRP() {
    return _currency;
  }
  @override
  Map<String, dynamic> toJson() {
    return {"currency": "XRP"};
  }
}

class CurrencyAmount {
  CurrencyAmount._(this.xrp, this.isseAmount);
  factory CurrencyAmount.fromJson(dynamic json) {
    if (json is Map) {
      return CurrencyAmount._(
          null, IssuedCurrencyAmount.fromJson(json as Map<String, dynamic>));
    }
    return CurrencyAmount._(parseBigInt(json)!, null);
  }

  CurrencyAmount.xrp(BigInt this.xrp) : isseAmount = null;
  CurrencyAmount.issue(IssuedCurrencyAmount this.isseAmount) : xrp = null;
  final BigInt? xrp;
  final IssuedCurrencyAmount? isseAmount;

  dynamic toJson() {
    return xrp?.toString() ?? isseAmount!.toJson();
  }
}
