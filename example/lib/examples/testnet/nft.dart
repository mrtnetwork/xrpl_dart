// XRPL testnet: NFTs (mint, sell, brokered sale with broker fee).


import 'dart:convert';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:example/examples/local/xrpl_node.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

/// The taxon groups this minter's NFTs. Values >= 0x80000000 are reserved.
const int taxon = 0;

/// Sale price of the first NFT, in XRP.
const String salePrice = '5';

Future<void> main() async {
  final net = await XrplTestnet.connect();

  final minter = LocalWallet(index: 50, algorithm: XRPKeyAlgorithm.ed25519);
  final buyer = LocalWallet(index: 51, algorithm: XRPKeyAlgorithm.secp256k1);

  print('XRPL testnet: NFTs');
  print(field('minter', minter.address));
  print(field('  key', minter.algorithm.name));
  print(field('buyer', buyer.address));
  print(field('  key', buyer.algorithm.name));
  print(field('taxon', '$taxon'));
  print('');

  await fund(net, minter);
  await fund(net, buyer);
  print(field('minter funded', '${formatDrops(await net.balanceOf(minter.address))} XRP'));
  print(field('buyer funded', '${formatDrops(await net.balanceOf(buyer.address))} XRP'));
  print('');

  /// ---- 1. mint ----------------------------------------------------------
  final uri = BytesUtils.toHexString(
    utf8.encode('ipfs://xrpl-dart/example-nft'),
  );
  final nftId = await mintNft(net, minter, uri);
  print(field('mint', 'tesSUCCESS'));
  print(field('uri', 'ipfs://xrpl-dart/example-nft'));
  print(field('nft id', nftId));
  print(field('owner', minter.address));
  print('');

  /// ---- 2. sell offer ----------------------------------------------------
  final minterXrpBefore = await net.balanceOf(minter.address);
  final buyerXrpBefore = await net.balanceOf(buyer.address);
  final minterNftsBefore = (await nftsOf(net, minter)).length;
  final buyerNftsBefore = (await nftsOf(net, buyer)).length;

  final sell = NFTokenCreateOffer(
    account: minter.address,
    nftokenId: nftId,
    amount: XRPAmount(XRPHelper.xrpToDrop(salePrice)),
    flags: [NftTokenCreateOfferFlag.tfSellNftoken.value],
    signer: XRPLSignature.signer(minter.pubHex),
  );
  final sellResult = await submit(net, sell, minter);
  await waitForValidation(net, sell.getHash());
  print(field('sell offer', sellResult.engineResult));
  print(field('tx', sell.getHash()));

  /// The offer index is read back from the chain, as a client would.
  final offers = await net.provider.request(
    XRPRequestNFTSellOffers(nftId: nftId),
  );
  print(field('sell offers', '${offers.offers.length}'));
  print(field('offer index', offers.offers.first.nftOfferIndex));
  print('');

  /// ---- 3. accept --------------------------------------------------------
  /// Accepting a sell offer needs only the buyer's signature: the seller has
  /// already committed to the price.
  final accept = NFTokenAcceptOffer(
    account: buyer.address,
    nfTokenSellOffer: offers.offers.first.nftOfferIndex,
    signer: XRPLSignature.signer(buyer.pubHex),
  );
  final acceptResult = await submit(net, accept, buyer);
  final acceptHash = accept.getHash();
  await waitForValidation(net, acceptHash);
  print(field('accept', acceptResult.engineResult));
  print(field('tx', acceptHash));
  /// The addresses are fixed, so earlier runs may already own NFTs; report the
  /// change rather than the total.
  final minterNftsNow = (await nftsOf(net, minter)).length;
  final buyerNftsNow = (await nftsOf(net, buyer)).length;
  print(field('minter NFTs', '$minterNftsNow '
      '(${signed(minterNftsNow - minterNftsBefore)})'));
  print(field('buyer NFTs', '$buyerNftsNow (${signed(buyerNftsNow - buyerNftsBefore)})'));
  print(field('minter XRP change', formatDrops(
      await net.balanceOf(minter.address) - minterXrpBefore)));
  print(field('buyer XRP change', formatDrops(
      await net.balanceOf(buyer.address) - buyerXrpBefore)));
  print(field('explorer', explorerUrl(acceptHash)));
  print('');

  await brokeredSale(net);
  await net.close();
  print('');
  print('done.');
}

/// ---- brokered mode ------------------------------------------------------
///
/// Both sides post an offer and a third account matches them. The broker keeps
/// the difference between the two amounts; the seller still receives exactly
/// what it asked for.
Future<void> brokeredSale(XrplTestnet net) async {
  final seller = LocalWallet(index: 52, algorithm: XRPKeyAlgorithm.ed25519);
  final buyer = LocalWallet(index: 53, algorithm: XRPKeyAlgorithm.secp256k1);
  final broker = LocalWallet(index: 54, algorithm: XRPKeyAlgorithm.ed25519);

  print('brokered sale');
  print(field('seller', seller.address));
  print(field('  key', seller.algorithm.name));
  print(field('buyer', buyer.address));
  print(field('  key', buyer.algorithm.name));
  print(field('broker', broker.address));
  print(field('  key', broker.algorithm.name));

  await fund(net, seller);
  await fund(net, buyer);
  await fund(net, broker);

  final nftId = await mintNft(
    net,
    seller,
    BytesUtils.toHexString(utf8.encode('ipfs://xrpl-dart/brokered-nft')),
  );
  print(field('nft id', nftId));

  /// The seller asks 5 XRP.
  final sell = NFTokenCreateOffer(
    account: seller.address,
    nftokenId: nftId,
    amount: XRPAmount(XRPHelper.xrpToDrop('5')),
    flags: [NftTokenCreateOfferFlag.tfSellNftoken.value],
    signer: XRPLSignature.signer(seller.pubHex),
  );
  await submit(net, sell, seller);
  await waitForValidation(net, sell.getHash());

  /// The buyer offers 6 XRP for the same NFT; the extra 1 XRP is the fee.
  final buy = NFTokenCreateOffer(
    account: buyer.address,
    nftokenId: nftId,
    amount: XRPAmount(XRPHelper.xrpToDrop('6')),
    owner: seller.address,
    signer: XRPLSignature.signer(buyer.pubHex),
  );
  await submit(net, buy, buyer);
  await waitForValidation(net, buy.getHash());

  final sells = await net.provider.request(
    XRPRequestNFTSellOffers(nftId: nftId),
  );
  final buys = await net.provider.request(
    XRPRequestNFTBuyOffers(nftId: nftId),
  );
  print(field('sells', '${sells.offers.length}'));
  print(field('buys', '${buys.offers.length}'));
  print('');

  final sellerXrpBefore = await net.balanceOf(seller.address);
  final brokerXrpBefore = await net.balanceOf(broker.address);
  final buyerXrpBefore = await net.balanceOf(buyer.address);
  final sellerNftsBefore = (await nftsOf(net, seller)).length;
  final buyerNftsBefore = (await nftsOf(net, buyer)).length;

  /// Only the broker submits: it does not own the NFT, it just brings the two
  /// offers together and takes the agreed fee.
  final accept = NFTokenAcceptOffer(
    account: broker.address,
    nfTokenSellOffer: sells.offers.first.nftOfferIndex,
    nfTokenBuyOffer: buys.offers.first.nftOfferIndex,
    nfTokenBrokerFee: XRPAmount(XRPHelper.xrpToDrop('1')),
    signer: XRPLSignature.signer(broker.pubHex),
  );
  final result = await submit(net, accept, broker);
  final hash = accept.getHash();
  await waitForValidation(net, hash);
  print(field('brokered accept', result.engineResult));
  print(field('tx', hash));
  final sellerNftsNow = (await nftsOf(net, seller)).length;
  final buyerNftsNow = (await nftsOf(net, buyer)).length;
  print(field('seller NFTs', '$sellerNftsNow '
      '(${signed(sellerNftsNow - sellerNftsBefore)})'));
  print(field('buyer NFTs', '$buyerNftsNow (${signed(buyerNftsNow - buyerNftsBefore)})'));
  print(field('seller XRP change', formatDrops(
      await net.balanceOf(seller.address) - sellerXrpBefore)));
  print(field('broker XRP change', formatDrops(
      await net.balanceOf(broker.address) - brokerXrpBefore)));
  print(field('buyer XRP change', formatDrops(
      await net.balanceOf(buyer.address) - buyerXrpBefore)));
  print(field('explorer', explorerUrl(hash)));
}

/// Mints one transferable NFT for [wallet] and returns its id.
Future<String> mintNft(XrplTestnet net, LocalWallet wallet, String uri) async {
  final mint = NFTokenMint(
    account: wallet.address,
    nftokenTaxon: taxon,
    uri: uri,
    flags: [NFTokenMintFlag.tfTransferable.value],
    signer: XRPLSignature.signer(wallet.pubHex),
  );
  final result = await submit(net, mint, wallet);
  await waitForValidation(net, mint.getHash());
  if (result.engineResult != 'tesSUCCESS') {
    throw StateError('mint failed: ${result.engineResult}');
  }
  final nfts = await nftsOf(net, wallet);
  if (nfts.isEmpty) throw StateError('${wallet.address} owns no NFT');
  return nfts.first.nfTokenId;
}

/// Formats a change with an explicit sign, e.g. `+1` or `-1`.
String signed(int value) => value >= 0 ? '+$value' : '$value';

/// All NFTs owned by [wallet].
Future<List<AccountNFToken>> nftsOf(
  XrplTestnet net,
  LocalWallet wallet,
) async {
  final result = await net.provider.request(
    XRPRequestAccountNFTs(
      account: wallet.address,
      ledgerIndex: XRPLLedgerIndex.current,
    ),
  );
  return result.accountNfts;
}