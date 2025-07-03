import 'package:xrpl_dart/src/rpc/core/methods_impl.dart';
import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/models/models.dart';
import 'package:xrpl_dart/src/xrpl/models/currencies/currencies.dart';

//
/// The book_offers method retrieves a list of offers, also known
/// as the order book, between two currencies.
class XRPRequestBookOffers
    extends XRPLedgerRequest<BookOffersResult, Map<String, dynamic>> {
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
  final BaseCurrency takerGets;
  final BaseCurrency takerPays;
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

  @override
  BookOffersResult onResonse(Map<String, dynamic> result) {
    return BookOffersResult.fromJson(result);
  }
}
