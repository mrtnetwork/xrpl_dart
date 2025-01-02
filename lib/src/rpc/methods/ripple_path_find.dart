import 'package:xrpl_dart/src/rpc/rpc.dart';
import 'package:xrpl_dart/src/xrpl/models/currencies/currencies.dart';

/// The ripple_path_find method is a simplified version of the
/// path_find method that provides a single response with a payment
/// path you can use right away. It is available in both the WebSocket
/// and JSON-XRPRequest APIs. However, the results tend to become outdated as
/// time passes. Instead of making multiple calls to stay updated, you
/// should instead use the path_find method to subscribe to continued
/// updates where possible.

/// Although the rippled server tries to find the cheapest path or
/// combination of paths for making a payment, it is not guaranteed that
/// the paths returned by this method are, in fact, the best paths.
class XRPRequestRipplePathFind
    extends XRPLedgerRequest<RipplePathFound, Map<String, dynamic>> {
  XRPRequestRipplePathFind(
      {required this.sourceAccount,
      required this.destinationAccount,
      required this.destinationAmount,
      this.sendMax,
      this.sourceCurrencies,
      super.ledgerIndex = XRPLLedgerIndex.validated});
  @override
  String get method => XRPRequestMethod.ripplePathFind;
  final String sourceAccount;
  final String destinationAccount;
  final CurrencyAmount destinationAmount;
  final CurrencyAmount? sendMax;
  final List<XRPCurrencies>? sourceCurrencies;

  @override
  Map<String, dynamic> toJson() {
    return {
      'source_account': sourceAccount,
      'destination_account': destinationAccount,
      'destination_amount': destinationAmount.toJson(),
      'send_max': sendMax?.toJson(),
      'source_currencies': sourceCurrencies?.map((e) => e.toJson()).toList()
    };
  }

  @override
  RipplePathFound onResonse(Map<String, dynamic> result) {
    return RipplePathFound.fromJson(result);
  }
}
