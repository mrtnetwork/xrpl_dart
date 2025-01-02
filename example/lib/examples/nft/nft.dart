// ignore_for_file: avoid_print, unused_local_variable

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void nftOprationExamples() async {
  final minter = QuickWallet.create(521, algorithm: XRPKeyAlgorithm.secp256k1);
  final coldWallet =
      QuickWallet.create(522, algorithm: XRPKeyAlgorithm.ed25519);

  /// mint token
  await mintToken(minter);

  /// burn token
  await burnToken(minter);

  /// issue address this wallet used to create issue in issue token example
  final issueWallet =
      QuickWallet.create(351, algorithm: XRPKeyAlgorithm.ed25519);

  /// create offer with 25.00 MRT token
  await createOffgerForNftWithToken(
      minter,
      IssuedCurrencyAmount(
          value: "25.00", currency: "MRT", issuer: issueWallet.address));

  /// get accounts nfts
  var resp =
      await minter.rpc.request(XRPRequestAccountNFTs(account: minter.address));

  /// get offer details of nft with index0
  var offer = await minter.rpc.request(
      XRPRequestNFTSellOffers(nftId: resp["account_nfts"][0]["NFTokenID"]));

  /// get offer id
  var offerid = offer["offers"][0]["nft_offer_index"];

  /// cancel offer
  await nfTokenCancelOffer(minter, [offerid]);

  /// create another offer
  await createOffgerForNftWithToken(
      minter,
      IssuedCurrencyAmount(
          value: "25.00", currency: "MRT", issuer: issueWallet.address));

  /// read nfts infromation again
  resp =
      await minter.rpc.request(XRPRequestAccountNFTs(account: minter.address));
  offer = await minter.rpc.request(
      XRPRequestNFTSellOffers(nftId: resp["account_nfts"][0]["NFTokenID"]));
  final offerAmountDetails =
      CurrencyAmount.fromJson(offer["offers"][0]["amount"]);
  offerid = offer["offers"][0]["nft_offer_index"];

  /// buy nfts whit some account has MRT TOKEN
  /// ok we have mrt token in this wallet to buy this nft
  final anotherWallet =
      QuickWallet.create(360, algorithm: XRPKeyAlgorithm.ed25519);
  await nftTokenAcceptOffer(anotherWallet, offerid);
}

Future<void> mintToken(QuickWallet wallet) async {
  final transaction = NFTokenMint(
      // flags: NFTokenMintFlag.tfTransferable.value,
      uri: BytesUtils.toHexString(
          StringUtils.encode("https://github.com/mrtnetwork/xrpl_dart")),
      account: wallet.address,
      signer: XRPLSignature.signer(wallet.pubHex),
      memos: [exampleMemo],
      nftokenTaxon: 1);
  print("autfil trnsction");
  await XRPHelper.autoFill(wallet.rpc, transaction, defaultLedgerOffset: 20);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = wallet.privateKey.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);

  final trhash = transaction.getHash();
  print("transaction hash: $trhash");
  final trBlob = transaction.toBlob(forSigning: false);

  print("regenarate transaction blob with exists signatures");
  print("broadcasting signed transaction blob");
  final result = await wallet.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/EA94249516381BEFAA10F9836D36C1C3B2DECB5176687FC17D17EA8E22ED1B9C
}

Future<void> burnToken(QuickWallet wallet) async {
  /// find token id to burn
  /// get list of account nfts
  final accountObject =
      await wallet.rpc.request(XRPRequestAccountNFTs(account: wallet.address));

  final tokenId = accountObject["account_nfts"][0]["NFTokenID"];

  // print("owner public: $ownerPublic");
  final transaction = NFTokenBurn(
    nfTokenId: tokenId,
    account: wallet.address,
    signer: XRPLSignature.signer(wallet.pubHex),
    memos: [exampleMemo],
  );
  print("autfil trnsction");
  await XRPHelper.autoFill(wallet.rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = wallet.privateKey.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);
  final trhash = transaction.getHash();
  print("transaction hash: $trhash");
  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await wallet.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/D5555CE0E944D7D4AB73899E1866FDA6315B35114AA924AC5639B91A1F52DF5C
}

Future<void> createOffgerForNftWithToken(
    QuickWallet wallet, IssuedCurrencyAmount amount) async {
  /// find token id to create offer
  /// get list of account nfts
  final accountObject =
      await wallet.rpc.request(XRPRequestAccountNFTs(account: wallet.address));
  final tokenId = accountObject["account_nfts"][0]["NFTokenID"];
  print("token id$tokenId");
  final offer = NFTokenCreateOffer(
    amount: CurrencyAmount.issue(amount),
    flags: NftTokenCreateOfferFlag.tfSellNftoken.value,
    nftokenId: tokenId,
    account: wallet.address,
    signer: XRPLSignature.signer(wallet.pubHex),
    memos: [exampleMemo],
  );
  print("autfil trnsction");
  await XRPHelper.autoFill(wallet.rpc, offer);
  final blob = offer.toBlob();
  print("sign transction");
  final sig = wallet.privateKey.sign(blob);
  print("Set transaction signature");
  offer.setSignature(sig);
  final trhash = offer.getHash();
  print("transaction hash: $trhash");
  final trBlob = offer.toBlob(forSigning: false);

  print("regenarate transaction blob with exists signatures");
  print("broadcasting signed transaction blob");
  final result = await wallet.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/7E23162014190C69E399953D96592BA862483E9754623CD1D0F5D9BD5808794D
}

Future<void> nftTokenAcceptOffer(QuickWallet buyer, String offerID) async {
  final offer = NFTokenAcceptOffer(
    nfTokenSellOffer: offerID,
    account: buyer.address,
    signer: XRPLSignature.signer(buyer.pubHex),
    memos: [exampleMemo],
  );
  print("autfil trnsction");
  await XRPHelper.autoFill(buyer.rpc, offer);
  final blob = offer.toBlob();
  print("sign transction");
  final sig = buyer.privateKey.sign(blob);
  print("Set transaction signature");
  offer.setSignature(sig);
  final trhash = offer.getHash();
  print("transaction hash: $trhash");
  final trBlob = offer.toBlob(forSigning: false);

  print("regenarate transaction blob with exists signatures");
  print("broadcasting signed transaction blob");
  final result = await buyer.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/5E14783616741A7C6DEB661FEF7908A076CE550E2609EFF86B831391FEBE5013
}

Future<void> nfTokenCancelOffer(
    QuickWallet minter, List<String> offerIdsToCancel) async {
  final offer = NFTokenCancelOffer(
    nftokenOffers: offerIdsToCancel,
    account: minter.address,
    signer: XRPLSignature.signer(minter.pubHex),
    memos: [exampleMemo],
  );
  print("autfil trnsction");
  await XRPHelper.autoFill(minter.rpc, offer);
  final blob = offer.toBlob();
  print("sign transction");
  final sig = minter.privateKey.sign(blob);
  print("Set transaction signature");
  offer.setSignature(sig);
  final trhash = offer.getHash();
  print("transaction hash: $trhash");
  final trBlob = offer.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await minter.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/EFF9277EAF2533A0474C5484CBD467AE313489903D5C66F29BD4737C5BCC4881
}
