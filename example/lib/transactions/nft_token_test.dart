// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrp_dart/xrp_dart.dart';
import '../main.dart';

void nftTokenTest() async {
  // final hotWallet = XRPPrivateKey.fromHex(
  //     "0038570E937AB74F50D786D1D757DA6B1458A756A4EB514E59EF8AE02D9860E843");
  final hotWallet = XRPPrivateKey.fromHex(
      "ED519D086FC4C09BD945500E2B90E43E00DB116E32A67E61AFB8C32B7648ED588A");
  await rpc.getFucent(hotWallet.getPublic().toAddress().address);

  await mintToken(hotWallet);
  await burnToken(hotWallet);
  await nfTokenCreateOffer(hotWallet);
  await nftTokenAcceptOffer(hotWallet);
  await nfTokenCancelOffer(hotWallet);
  await ntfTokenCreateOfferWithIssue(
      hotWallet, hotWallet.getPublic().toAddress().address, "FOO");
}

Future<void> mintToken(XRPPrivateKey owner) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();

  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  print("owner public: $ownerPublic");
  final transaction = NFTokenMint(
      flags: NFTokenMintFlag.tfTransferable.value,
      account: ownerAddress,
      signingPubKey: ownerPublic,
      memos: [memo],
      nftokenTaxon: 1);
  print("autfil trnsction");
  await XRPHelper.autoFill(rpc, transaction, defaultLedgerOffset: 20);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = owner.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);

  final trhash = transaction.getHash();
  print("transaction hash: $trhash");
  final trBlob = transaction.toBlob(forSigning: false);

  print("regenarate transaction blob with exists signatures");
  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> burnToken(XRPPrivateKey owner) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();
  const String tokenId =
      "000800007F8B435B93C14A68E105413A636A5332E3A1AB6016E5DA9D00000001";
  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  print("owner public: $ownerPublic");
  final transaction = NFTokenBurn(
    nfTokenId: tokenId,
    account: ownerAddress,
    signingPubKey: ownerPublic,
    memos: [memo],
  );
  print("autfil trnsction");
  await XRPHelper.autoFill(rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = owner.sign(blob);
  assert(owner.getPublic().verifySignature(blob, sig), "Test");
  print("Set transaction signature");
  transaction.setSignature(sig);
  final trhash = transaction.getHash();
  print("transaction hash: $trhash");
  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> nftTokenAcceptOffer(XRPPrivateKey owner) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();

  const String offerId =
      "535DC979550471F3BA82F0CA70835BE4A4DFADB010DDE495231F2BE10952CCD3";
  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);

  print("owner public: $ownerPublic");
  final offer = NFTokenAcceptOffer(
    nfTokenSellOffer: offerId,
    account: ownerAddress,
    signingPubKey: ownerPublic,
    memos: [memo],
  );
  print("autfil trnsction");
  await XRPHelper.autoFill(rpc, offer);
  final blob = offer.toBlob();
  print("sign transction");
  final sig = owner.sign(blob);
  print("Set transaction signature");
  offer.setSignature(sig);
  final trhash = offer.getHash();
  print("transaction hash: $trhash");
  final trBlob = offer.toBlob(forSigning: false);

  print("regenarate transaction blob with exists signatures");
  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> nfTokenCreateOffer(XRPPrivateKey owner) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();

  const String tokenId =
      "000800007F8B435B93C14A68E105413A636A5332E3A1AB602DCBAB9C00000002";
  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  print("owner public: $ownerPublic");
  final offer = NFTokenCreateOffer(
    amount: CurrencyAmount.xrp(BigInt.from(1000000)),
    flags: NftTokenCreateOfferFlag.tfSellNftoken.value,
    nftokenId: tokenId,
    account: ownerAddress,
    signingPubKey: ownerPublic,
    memos: [memo],
  );
  print("autfil trnsction");
  await XRPHelper.autoFill(rpc, offer);
  final blob = offer.toBlob();
  print("sign transction");
  final sig = owner.sign(blob);
  print("Set transaction signature");
  offer.setSignature(sig);
  final trhash = offer.getHash();
  print("transaction hash: $trhash");
  final trBlob = offer.toBlob(forSigning: false);

  print("regenarate transaction blob with exists signatures");
  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
  // trustSet.toBlob();
}

Future<void> nfTokenCancelOffer(XRPPrivateKey owner) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();

  const String offerId =
      "05A57CE70FBA0585A29CB55490013B8236C076801FFD661E6E55BBA8363F515C";
  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);

  print("owner public: $ownerPublic");
  final offer = NFTokenCancelOffer(
    nftokenOffers: [offerId],
    account: ownerAddress,
    signingPubKey: ownerPublic,
    memos: [memo],
  );
  print("autfil trnsction");
  await XRPHelper.autoFill(rpc, offer);
  final blob = offer.toBlob();
  print("sign transction");
  final sig = owner.sign(blob);
  print("Set transaction signature");
  offer.setSignature(sig);
  final trhash = offer.getHash();
  print("transaction hash: $trhash");
  final trBlob = offer.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
  // trustSet.toBlob();
}

Future<void> ntfTokenCreateOfferWithIssue(
    XRPPrivateKey owner, String issuerAddress, String currencyName) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();

  const String tokenId =
      "00080000C7D3B4C4A7A343765B13B08AF6A1310220FACA5F2DCBAB9C00000002";
  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  print("owner public: $ownerPublic");
  final offer = NFTokenCreateOffer(
    amount: CurrencyAmount.issue(IssuedCurrencyAmount(
        value: "35.5", currency: currencyName, issuer: issuerAddress)),
    flags: NftTokenCreateOfferFlag.tfSellNftoken.value,
    nftokenId: tokenId,
    account: ownerAddress,
    signingPubKey: ownerPublic,
    memos: [memo],
  );
  print("autfil trnsction");
  await XRPHelper.autoFill(rpc, offer);
  final blob = offer.toBlob();
  print("sign transction");
  final sig = owner.sign(blob);
  print("Set transaction signature");
  offer.setSignature(sig);
  final trhash = offer.getHash();
  print("transaction hash: $trhash");
  final trBlob = offer.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}
