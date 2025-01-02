import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/on_chain_models/on_chain_models.dart';
import 'package:xrpl_dart/src/xrpl/models/currencies/currencies.dart';
import '../core/methods_impl.dart';

/// The book_offers method retrieves a list of offers, also known
/// as the order book, between two currencies.
class XRPRequestBookOffers
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestBookOffers({
    required this.takerGets,
    required this.takerPays,
    this.limit,
    this.taker,
    super.ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.bookOffers;

  final String? taker;
  final XRPCurrencies takerGets;
  final XRPCurrencies takerPays;
  final int? limit;

  @override
  Map<String, dynamic> toJson() {
    return {
      'taker_gets': takerGets.toJson(),
      'limit': limit,
      'taker_pays': takerPays.toJson(),
      'taker': taker,
    };
  }
}
