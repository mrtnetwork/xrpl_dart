// ignore_for_file: avoid_print, unused_local_variable

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrp_dart/xrp_dart.dart';

void tokenIssueAndTransfer() async {
  final hotWallet =
      QuickWallet.create(350, algorithm: XRPKeyAlgorithm.secp256k1);
  final coldWallet =
      QuickWallet.create(351, algorithm: XRPKeyAlgorithm.ed25519);

  await configureIssue(coldWallet);
  await configureAccount(hotWallet);
  await createTrustSet(hotWallet, coldWallet.address);
  await sendToken(coldWallet, hotWallet.address, coldWallet.address);

  /// send from hot wallet to another address
  final anotherWallet =
      QuickWallet.create(360, algorithm: XRPKeyAlgorithm.ed25519);
  await configureAccount(anotherWallet);
  await createTrustSet(anotherWallet, coldWallet.address);
  await sendToken(hotWallet, anotherWallet.address, coldWallet.address);

  /// https://devnet.xrpl.org/transactions/8C373FA9BE4CB3F975DA0D93541198EF6A6EBA6EFA8611BAD935D07A31F54D6F
}

Future<void> configureAccount(QuickWallet hotWallet) async {
  final accountSet = AccountSet(
      account: hotWallet.address,
      signingPubKey: hotWallet.pubHex,
      memos: [exampleMemo],
      setFlag: AccountSetAsfFlag.asfRequireAuth);
  print("autfil trnsction");
  await XRPHelper.autoFill(hotWallet.rpc, accountSet);

  final blob = accountSet.toBlob();
  print("sign transction");
  final sig = hotWallet.privateKey.sign(blob);
  print("Set transaction signature");
  accountSet.setSignature(sig);

  final trhash = accountSet.getHash();
  print("transaction hash: $trhash");

  final trBlob = accountSet.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await hotWallet.rpc.request(RPCSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/5BE16C437C9556A47038EAB6139F55EEAC03140C2304017846C96CF96C337D4C
}

Future<void> configureIssue(QuickWallet coldWallet) async {
  final accountSet = AccountSet(
      account: coldWallet.address,
      signingPubKey: coldWallet.pubHex,
      memos: [exampleMemo],
      setFlag: AccountSetAsfFlag.asfDefaultRipple,
      domain: BytesUtils.toHexString(
          StringUtils.encode("https://github.com/mrtnetwork/xrp_dart")),
      tickSize: 5,
      transferRate: 0);
  print("autofill trnsction");
  await XRPHelper.autoFill(coldWallet.rpc, accountSet);
  final blob = accountSet.toBlob();
  print("sign transction");
  final sig = coldWallet.privateKey.sign(blob);
  print("Set transaction signature");
  accountSet.setSignature(sig);
  final trhash = accountSet.getHash();
  print("transaction hash: $trhash");

  final trBlob = accountSet.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await coldWallet.rpc.request(RPCSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/679B7F4A27BC2620760D14214B3755F78C767456C6ABE7DD8043FBAE55450801
}

Future<void> createTrustSet(QuickWallet account, String issueAddress) async {
  final trustLine = TrustSet(
    account: account.address,
    signingPubKey: account.pubHex,
    limitAmount: IssuedCurrencyAmount(
        value: "10000000000", currency: "MRT", issuer: issueAddress),
    memos: [exampleMemo],
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
  final result = await account.rpc.request(RPCSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/B4726002DA91E5DE27D89E9980A6915B1B8827B246822DBCA35A5FFDCD7E650B
}

Future<void> sendToken(
    QuickWallet account, String destination, String issueAddress) async {
  final sendToken = Payment(
    destination: destination,
    account: account.address,
    signingPubKey: account.pubHex,
    memos: [exampleMemo],
    amount: CurrencyAmount.issue(IssuedCurrencyAmount(
        value: "80.585677899", currency: "MRT", issuer: issueAddress)),
  );
  print("autofill trnsction");
  await XRPHelper.autoFill(account.rpc, sendToken);
  final blob = sendToken.toBlob();
  print("sign transction");
  final sig = account.privateKey.sign(blob);
  print("Set transaction signature");
  sendToken.setSignature(sig);
  final trhash = sendToken.getHash();
  print("transaction hash: $trhash");
  final trBlob = sendToken.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await account.rpc.request(RPCSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/B242F5CDB6674600379093ED157862F626DC0E495A2BE413C57F30DE14A20E2D
}
