// XRPL testnet: DEX offers (crossing match, then place + cancel a non-crossing one).


import 'package:example/examples/local/xrpl_node.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

const String currencyCode = 'TST';

/// The seller's token balance after the top-up, and the amount offered for sale.
const String tokenAmount = '1000';
const String tradeAmount = '100';
const String tradePrice = '2';

Future<void> main() async {
  final net = await XrplTestnet.connect();

  final issuer = LocalWallet(index: 30, algorithm: XRPKeyAlgorithm.ed25519);
  final seller = LocalWallet(index: 31, algorithm: XRPKeyAlgorithm.secp256k1);
  final buyer = LocalWallet(index: 32, algorithm: XRPKeyAlgorithm.ed25519);

  print('XRPL testnet: decentralised exchange');
  print(field('issuer', issuer.address));
  print(field('  key', issuer.algorithm.name));
  print(field('seller', seller.address));
  print(field('  key', seller.algorithm.name));
  print(field('buyer', buyer.address));
  print(field('  key', buyer.algorithm.name));
  print('');

  await fund(net, issuer);
  await fund(net, seller);
  await fund(net, buyer);

  /// ---- 0. give the seller something to sell ----------------------------
  for (final holder in [seller, buyer]) {
    final trust = TrustSet(
      account: holder.address,
      limitAmount: IssuedCurrencyAmount(
        currency: currencyCode,
        issuer: issuer.address,
        /// A large limit, so re-running the example does not hit the ceiling.
        value: '1000000',
      ),
      signer: XRPLSignature.signer(holder.pubHex),
    );
    final r = await submit(net, trust, holder);
    await waitForValidation(net, trust.getHash());
    print(field('trustset ${holder.index}', r.engineResult));
  }

  /// Top the seller up to a fixed amount. The accounts are deterministic, so a
  /// previous run may already hold some of the token.
  final sellerTst = await tokenBalance(net, seller);
  final topUp = BigInt.parse(tokenAmount) - BigInt.parse(sellerTst);
  if (topUp > BigInt.zero) {
    final issue = Payment(
      account: issuer.address,
      destination: seller.address,
      amount: IssuedCurrencyAmount(
        currency: currencyCode,
        issuer: issuer.address,
        value: topUp.toString(),
      ),
      signer: XRPLSignature.signer(issuer.pubHex),
    );
    final issueResult = await submit(net, issue, issuer);
    await waitForValidation(net, issue.getHash());
    print(field('issue to seller', issueResult.engineResult));
  }
  print(field('seller token balance', await tokenBalance(net, seller)));

  /// Offers left over from an earlier run would cross immediately, so cancel
  /// anything the seller already has on the book before placing a new order.
  await clearOffers(net, seller);
  print(field('stale offers cleared', 'yes'));
  print('');

  /// ---- 1. the seller offers 100 TST for 2 XRP --------------------------
  final sell = OfferCreate(
    account: seller.address,
    takerGets: IssuedCurrencyAmount(
      currency: currencyCode,
      issuer: issuer.address,
      value: tradeAmount,
    ),
    takerPays: XRPAmount(XRPHelper.xrpToDrop(tradePrice)),
    signer: XRPLSignature.signer(seller.pubHex),
  );
  final sellerTstBefore = await tokenBalance(net, seller);
  final sellerXrpBefore = await net.balanceOf(seller.address);

  final sellResult = await submit(net, sell, seller);
  final sellHash = sell.getHash();
  print(field('seller offer', sellResult.engineResult));
  print(field('tx', sellHash));
  print(field('offer sequence', '${sell.sequence}'));
  await waitForValidation(net, sellHash);

  /// The whole book for this pair: everyone offering TST for XRP.
  final book = await net.provider.request(
    XRPRequestBookOffers(
      takerGets: IssuedCurrency(currency: currencyCode, issuer: issuer.address),
      takerPays: XRPCurrency(),
    ),
  );
  print(field('offers on the book', '${book.offers.length}'));
  for (final offer in book.offers) {
    print(field('  sequence', '${offer.sequence} '
        'owner ${offer.account} '
        'funded ${offer.ownerFunds ?? '-'} TST'));
  }
  print('');

  /// ---- 2. the buyer crosses it -----------------------------------------
  /// This offer matches the seller's, so the trade happens inside this one
  /// transaction: the seller gets 2 XRP and the buyer gets 100 TST.
  final buy = OfferCreate(
    account: buyer.address,
    takerGets: XRPAmount(XRPHelper.xrpToDrop(tradePrice)),
    takerPays: IssuedCurrencyAmount(
      currency: currencyCode,
      issuer: issuer.address,
      value: tradeAmount,
    ),
    signer: XRPLSignature.signer(buyer.pubHex),
  );
  final buyerTstBefore = await tokenBalance(net, buyer);
  final buyerXrpBefore = await net.balanceOf(buyer.address);

  final buyResult = await submit(net, buy, buyer);
  final buyHash = buy.getHash();
  print(field('buyer offer', buyResult.engineResult));
  print(field('tx', buyHash));
  await waitForValidation(net, buyHash);

  /// The two offers cross inside this single transaction.
  print(field('seller TST', '${await tokenBalance(net, seller)} '
      '(was $sellerTstBefore)'));
  print(field('buyer TST', '${await tokenBalance(net, buyer)} '
      '(was $buyerTstBefore)'));
  print(field('seller XRP', formatDrops(await net.balanceOf(seller.address))));
  print(field('  change', formatDrops(
      await net.balanceOf(seller.address) - sellerXrpBefore)));
  print(field('buyer XRP', formatDrops(await net.balanceOf(buyer.address))));
  print(field('  change', formatDrops(
      await net.balanceOf(buyer.address) - buyerXrpBefore)));
  print('');

  /// ---- 3. rest an offer, then cancel it --------------------------------
  /// 10 TST for 500 XRP is far from the market, so it just sits on the book.
  final rest = OfferCreate(
    account: seller.address,
    takerGets: IssuedCurrencyAmount(
      currency: currencyCode,
      issuer: issuer.address,
      value: '10',
    ),
    takerPays: XRPAmount(XRPHelper.xrpToDrop('500')),
    signer: XRPLSignature.signer(seller.pubHex),
  );
  final restResult = await submit(net, rest, seller);
  final restHash = rest.getHash();
  await waitForValidation(net, restHash);
  print(field('resting offer', restResult.engineResult));
  print(field('offer sequence', '${rest.sequence}'));
  print(field('open offers', '${(await openOffers(net, seller)).length}'));

  final cancel = OfferCancel(
    account: seller.address,
    offerSequence: rest.sequence!,
    signer: XRPLSignature.signer(seller.pubHex),
  );
  final cancelResult = await submit(net, cancel, seller);
  final cancelHash = cancel.getHash();
  await waitForValidation(net, cancelHash);
  print(field('cancel', cancelResult.engineResult));
  print(field('open offers', '${(await openOffers(net, seller)).length}'));

  await net.close();
  print('');
  print('done.');
}

/// Token balance of [wallet], in whole units.
Future<String> tokenBalance(XrplTestnet net, LocalWallet wallet) async {
  final lines = await net.provider.request(
    XRPRequestAccountLines(account: wallet.address),
  );
  for (final line in lines.lines) {
    if (line.currency == currencyCode) return line.balance;
  }
  return '0';
}

/// Cancels every offer [wallet] has on the book.
///
/// The seller is a fixed address, so a previous run can leave offers behind;
/// those would cross with the new order and make the trade amount vary. The
/// ledger only reflects a cancellation once it is validated, so this re-reads
/// the offer list until it is empty.
Future<void> clearOffers(XrplTestnet net, LocalWallet wallet) async {
  for (var round = 0; round < 10; round++) {
    final offers = await openOffers(net, wallet);
    if (offers.isEmpty) return;
    for (final offer in offers) {
      final cancel = OfferCancel(
        account: wallet.address,
        offerSequence: offer.seq,
        signer: XRPLSignature.signer(wallet.pubHex),
      );
      final result = await submit(net, cancel, wallet);
      await waitForValidation(net, cancel.getHash());
      if (result.engineResult != 'tesSUCCESS') {
        throw StateError('could not cancel offer ${offer.seq}: '
            '${result.engineResult}');
      }
    }
    await Future<void>.delayed(const Duration(seconds: 2));
  }
  throw StateError('offers of ${wallet.address} did not clear');
}

/// Outstanding offers of [wallet].
Future<List<AccountOffer>> openOffers(
  XrplTestnet net,
  LocalWallet wallet,
) async {
  final result = await net.provider.request(
    XRPRequestAccountOffer(account: wallet.address),
  );
  return result.offers ?? const [];
}