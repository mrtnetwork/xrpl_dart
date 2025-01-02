import 'package:xrpl_dart/src/rpc/rpc.dart';
import 'package:xrpl_dart/src/xrpl/models/currencies/currencies.dart';

class StreamParameter {
  /// Represents a StreamParameter for consensus data.
  static const StreamParameter consensus = StreamParameter._('consensus');

  /// Represents a StreamParameter for ledger data.
  static const StreamParameter ledger = StreamParameter._('ledger');

  /// Represents a StreamParameter for manifests data.
  static const StreamParameter manifests = StreamParameter._('manifests');

  /// Represents a StreamParameter for peer status data.
  static const StreamParameter peerStatus = StreamParameter._('peer_status');

  /// Represents a StreamParameter for transactions data.
  static const StreamParameter transactions = StreamParameter._('transactions');

  /// Represents a StreamParameter for proposed transactions data.
  static const StreamParameter transactionsProposed =
      StreamParameter._('transactions_proposed');

  /// Represents a StreamParameter for server data.
  static const StreamParameter server = StreamParameter._('server');

  /// Represents a StreamParameter for validations data.
  static const StreamParameter validations = StreamParameter._('validations');

  /// The string value associated with each StreamParameter.
  final String value;

  /// Private constructor to initialize the string value for each StreamParameter.
  const StreamParameter._(this.value);
}

/// Format for elements in the ``books`` array for Subscribe only.
class SubscribeBook {
  SubscribeBook(
      {required this.takerGets,
      required this.takerPays,
      required this.taker,
      this.snapshot = false,
      this.both = false});
  final XRPCurrencies takerGets;
  final XRPCurrencies takerPays;
  final String taker;
  final bool snapshot;
  final bool both;

  Map<String, dynamic> toJson() {
    return {
      'taker_gets': takerGets.toJson(),
      'taker_pays': takerPays.toJson(),
      'taker': taker,
      'snapshot': snapshot,
      'both': both
    };
  }
}

/// The subscribe method requests periodic notifications from the server
/// when certain events happen.
/// WebSocket API only.
/// See [subscribe](https://xrpl.org/subscribe.html)
class RPCSubscribe
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  RPCSubscribe(
      {this.streams,
      this.books,
      this.accounts,
      this.accountProposed,
      this.url,
      this.urlUsername,
      this.urlPassword});
  @override
  String get method => XRPRequestMethod.subscribe;
  final List<StreamParameter>? streams;
  final List<String>? accounts;
  final List<String>? accountProposed;
  final String? url;
  final String? urlUsername;
  final String? urlPassword;
  final List<SubscribeBook>? books;

  @override
  Map<String, dynamic> toJson() {
    return {
      'streams': streams?.map((e) => e.value).toList(),
      'accounts': accounts,
      'accounts_proposed': accountProposed,
      'url': url,
      'url_username': urlUsername,
      'url_password': urlPassword,
      'books': books?.map((e) => e.toJson()).toList()
    };
  }
}
