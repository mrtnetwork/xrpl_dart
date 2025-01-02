import 'package:xrpl_dart/src/rpc/rpc.dart';
import 'package:xrpl_dart/src/xrpl/models/currencies/currencies.dart';

/// Format for elements in the ``books`` array for Unsubscribe only..
class UnsubscribeBook {
  UnsubscribeBook(
      {required this.takerGets, required this.takerPays, this.both = false});
  final XRPCurrencies takerGets;
  final XRPCurrencies takerPays;

  final bool both;

  Map<String, dynamic> toJson() {
    return {
      'taker_gets': takerGets.toJson(),
      'taker_pays': takerPays.toJson(),
      'both': both
    };
  }
}

/// The unsubscribe command tells the server to stop sending
/// messages for a particular subscription or set of subscriptions.
/// WebSocket API only.
/// See [unsubscribe](https://xrpl.org/unsubscribe.html)
class RPCUnSubscribe
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  RPCUnSubscribe({
    this.streams,
    this.books,
    this.accounts,
    this.accountProposed,
  });
  @override
  String get method => XRPRequestMethod.unsubscribe;
  final List<StreamParameter>? streams;
  final List<String>? accounts;
  final List<String>? accountProposed;
  final List<UnsubscribeBook>? books;

  @override
  Map<String, dynamic> toJson() {
    return {
      'streams': streams?.map((e) => e.value).toList(),
      'accounts': accounts,
      'accounts_proposed': accountProposed,
      'books': books?.map((e) => e.toJson()).toList()
    };
  }
}
