import 'package:xrpl_dart/src/rpc/rpc.dart';

/// This request retrieves a list of currencies that an account can send or receive,
/// based on its trust lines.
/// This is not a thoroughly confirmed list, but it can be used to populate user
/// interfaces.
/// See [account_currencies](https://xrpl.org/account_currencies.html)
class RPCAccountCurrencies extends XRPLedgerRequest<Map<String, dynamic>> {
  RPCAccountCurrencies({
    required this.account,
    XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
  }) : super(ledgerIndex: ledgerIndex);
  @override
  String get method => XRPRequestMethod.accountCurrencies;

  final String account;

  @override
  Map<String, dynamic> toJson() {
    return {
      "account": account,
    };
  }
}
