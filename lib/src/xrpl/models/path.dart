import 'package:xrp_dart/src/xrpl/utilities.dart';

import 'base.dart';

/// A PathStep represents an individual step along a Path.
class PathStep extends XRPLBase {
  PathStep({
    this.account,
    this.currency,
    this.issuer,
    this.type,
    this.typeHex,
  }) {
    final err = _getError();
    assert(err == null, err);
  }
  final String? account;
  final String? currency;
  final String? issuer;
  final int? type;
  final String? typeHex;

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    addWhenNotNull(json, "account", account);
    addWhenNotNull(json, "currency", currency);
    addWhenNotNull(json, "issuer", issuer);
    addWhenNotNull(json, "type", type);
    addWhenNotNull(json, "type_hex", typeHex);
    return json;
  }

  PathStep.fromJson(Map<String, dynamic> json)
      : account = json["account"],
        currency = json["currency"],
        issuer = json["issuer"],
        type = json["type"],
        typeHex = json["type_hex"];

  String? _getError() {
    if (account != null) {
      if (currency != null || issuer != null) {
        return "Cannot set account if currency or issuer are set";
      }
    } else if (currency != null) {
      if (account != null) {
        return "Cannot set currency if account is set";
      }
      if (issuer != null && currency!.toUpperCase() == "XRP") {
        return "Cannot set issuer if currency is XRP";
      }
    } else if (issuer != null) {
      if (account != null) {
        return "Cannot set issuer if account is set";
      }
      if (currency != null && currency!.toUpperCase() == "XRP") {
        return "Cannot set issuer if currency is XRP";
      }
    }
    return null;
  }
}
