import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/on_chain_models/on_chain_models.dart';
import '../core/methods_impl.dart';

class NoRippleCheckRole {
  /// Represents a NoRippleCheckRole for a gateway.
  static const NoRippleCheckRole gateway = NoRippleCheckRole._('gateway');

  /// Represents a NoRippleCheckRole for a user.
  static const NoRippleCheckRole user = NoRippleCheckRole._('user');

  /// The string value associated with each NoRippleCheckRole.
  final String value;

  /// Private constructor to initialize the string value for each NoRippleCheckRole.
  const NoRippleCheckRole._(this.value);
}

/// This request provides a quick way to check the status of the Default Ripple field
/// for an account and the No Ripple flag of its trust lines, compared with the
/// recommended settings.
/// See [noripple_check](https://xrpl.org/noripple_check.html)
class XRPRequestNoRippleCheck
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestNoRippleCheck({
    required this.account,
    required this.role,
    super.ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.noRippleCheck;

  final String account;
  final NoRippleCheckRole role;

  @override
  Map<String, dynamic> toJson() {
    return {'account': account, 'role': role.value};
  }
}
