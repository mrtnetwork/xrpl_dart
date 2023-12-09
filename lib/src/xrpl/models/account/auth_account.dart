import 'package:xrp_dart/src/xrpl/models/base/base.dart';

class AuthAccount extends XrplNestedModel {
  AuthAccount({required this.account});
  AuthAccount.fromJson(Map<String, dynamic> json)
      : account = json["auth_account"]["account"];
  final String account;

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      "auth_account": {"account": account}
    };
  }
}
