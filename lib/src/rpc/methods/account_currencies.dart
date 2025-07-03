import 'package:xrpl_dart/src/rpc/methods/rpc_request_methods.dart';
import 'package:xrpl_dart/src/rpc/models/models/ledger_index.dart';
import 'package:xrpl_dart/src/rpc/models/models/response.dart';

/// This request retrieves a list of currencies that an account can send or receive,
/// based on its trust lines.
/// This is not a thoroughly confirmed list, but it can be used to populate user
/// interfaces.
/// See [account_currencies](https://xrpl.org/account_currencies.html)
class XRPRequestAccountCurrencies
    extends XRPLedgerRequest<AccountCurrenciesResult, Map<String, dynamic>> {
  XRPRequestAccountCurrencies({
    required this.account,
    super.ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.accountCurrencies;

  final String account;

  @override
  Map<String, dynamic> toJson() {
    return {
      'account': account,
    };
  }

  @override
  AccountCurrenciesResult onResonse(Map<String, dynamic> result) {
    return AccountCurrenciesResult.fromJson(result);
  }
}
