import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

class PathStepUtils {
  static const List<String> fieldsNames = [
    "account",
    "currency",
    "issuer",
    "type",
    "type_hex"
  ];
  bool isPathStepJson(Map<String, dynamic> json) {
    for (final i in json.keys) {
      if (!fieldsNames.contains(i)) return false;
    }
    return true;
  }
}

/// A PathStep represents an individual step along a Path.
class PathStep extends XRPLBase {
  PathStep({this.account, this.currency, this.issuer, this.type, this.typeHex});
  final String? account;
  final String? currency;
  final String? issuer;
  final int? type;
  final String? typeHex;

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'currency': currency,
      'issuer': issuer,
      'type': type,
      'type_hex': typeHex
    }..removeWhere((k, v) => v == null);
  }

  PathStep.fromJson(Map<String, dynamic> json)
      : account = json['account'],
        currency = json['currency'],
        issuer = json['issuer'],
        type = json['type'],
        typeHex = json['type_hex'];

  @override
  String? get validate => _getError() ?? super.validate;

  String? _getError() {
    if (account != null) {
      if (currency != null || issuer != null) {
        return 'Cannot set account if currency or issuer are set';
      }
    } else if (currency != null) {
      if (account != null) {
        return 'Cannot set currency if account is set';
      }
      if (issuer != null && currency!.toUpperCase() == 'XRP') {
        return 'Cannot set issuer if currency is XRP';
      }
    } else if (issuer != null) {
      if (account != null) {
        return 'Cannot set issuer if account is set';
      }
      if (currency != null && currency!.toUpperCase() == 'XRP') {
        return 'Cannot set issuer if currency is XRP';
      }
    }
    return null;
  }
}
