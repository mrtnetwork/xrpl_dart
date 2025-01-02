import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents one entry in a list of AuthAccounts used in AMMBid transaction.
class AuthAccount extends XRPLBase {
  AuthAccount({required this.account});
  AuthAccount.fromJson(Map<String, dynamic> json)
      : account = json['auth_account']['account'];
  final String account;

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'auth_account': {'account': account}
    };
  }
}
