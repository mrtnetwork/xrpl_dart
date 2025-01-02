// ignore_for_file: avoid_print

import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void offerExamples() async {
  final account = QuickWallet.create(0, account: 12);
  final mrtIssueWallet =
      QuickWallet.create(351, algorithm: XRPKeyAlgorithm.ed25519);
  await createOffer(account, mrtIssueWallet.address);
  await offerCancel(account);
}

Future<void> createOffer(QuickWallet account, String issueAddress) async {
  final trustLine = OfferCreate(
    account: account.address,
    takerGets: CurrencyAmount.xrp(
      XRPHelper.xrpDecimalToDrop("25"),
    ),
    takerPays: CurrencyAmount.issue(
      IssuedCurrencyAmount(
          value: "10.2", currency: "MRT", issuer: issueAddress),
    ),
    memos: [exampleMemo],
    signer: XRPLSignature.signer(account.pubHex),
  );

  await XRPHelper.autoFill(account.rpc, trustLine);
  final blob = trustLine.toBlob();
  print("sign transction");
  final sig = account.privateKey.sign(blob);
  print("Set transaction signature");
  trustLine.setSignature(sig);
  final trhash = trustLine.getHash();
  print("transaction hash: $trhash");
  final trBlob = trustLine.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result =
      await account.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/C9965370DDE9F1ABC57C5DF5FF3F3986C632DE166EDE55169AC68D18074F9146
}

Future<void> offerCancel(QuickWallet account) async {
  final acc = await account.rpc.request(XRPRequestAccountObjectType(
      account: account.address, type: AccountObjectType.offer));
  print(acc);
  final offerSequence = acc["account_objects"][0]["Sequence"];
  final transaction = OfferCancel(
    account: account.address,
    offerSequence: offerSequence,
    signer: XRPLSignature.signer(account.pubHex),
    memos: [exampleMemo],
  );
  await XRPHelper.autoFill(account.rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = account.privateKey.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);
  final trhash = transaction.getHash();
  print("transaction hash: $trhash");
  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result =
      await account.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/891197F5C8BB40C254C3D60483C8849627968F4962C89540AE22BADC5708B29F
}
