import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// A PathStep represents an individual step along a Path.
class PathStep extends XRPLBase {
  PathStep({
    this.account,
    this.currency,
    this.issuer,
    this.type,
    this.typeHex,
  });
  final String? account;
  final String? currency;
  final String? issuer;
  final int? type;
  final String? typeHex;

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    XRPLBase.addWhenNotNull(json, "account", account);
    XRPLBase.addWhenNotNull(json, "currency", currency);
    XRPLBase.addWhenNotNull(json, "issuer", issuer);
    XRPLBase.addWhenNotNull(json, "type", type);
    XRPLBase.addWhenNotNull(json, "type_hex", typeHex);
    return json;
  }

  PathStep.fromJson(Map<String, dynamic> json)
      : account = json["account"],
        currency = json["currency"],
        issuer = json["issuer"],
        type = json["type"],
        typeHex = json["type_hex"];

  @override
  String? get validate => _getError() ?? super.validate;

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
