// ignore_for_file: avoid_print

import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void ammCreate() async {
  final isuuerWallet = QuickWallet.create(0, account: 5);
  final lpWallet = QuickWallet.create(1, account: 5);

  await accountSet(isuuerWallet);
  await trustSet(lpWallet, isuuerWallet.address);
  await payment(isuuerWallet, isuuerWallet.address, lpWallet.address);
  await _ammCreate(lpWallet, isuuerWallet.address);
}

Future<void> accountSet(QuickWallet wallet) async {
  final transaction = AccountSet(
      account: wallet.address,
      signer: XRPLSignature.signer(wallet.pubHex),
      setFlag: AccountSetAsfFlag.asfDefaultRipple,
      memos: [exampleMemo]);
  await XRPHelper.autoFill(wallet.rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = wallet.privateKey.sign(blob);
  transaction.setSignature(sig);
  final trBlob = transaction.toBlob(forSigning: false);
  final result = await wallet.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("is success: ${result.isSuccess}");
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");

  /// https://devnet.xrpl.org/transactions/5E622C7CB1CDB0264B75EEF992896A24464988A411AA5E86E8EAB029CDE14EE8
}

Future<void> trustSet(QuickWallet wallet, String issuer) async {
  final transaction = TrustSet(
      account: wallet.address,
      signer: XRPLSignature.signer(wallet.pubHex),
      flags: TrustSetFlag.tfClearNoRipple.value,
      limitAmount:
          IssuedCurrencyAmount(value: "1000", currency: "USD", issuer: issuer),
      memos: [exampleMemo]);
  await XRPHelper.autoFill(wallet.rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = wallet.privateKey.sign(blob);
  transaction.setSignature(sig);
  final trBlob = transaction.toBlob(forSigning: false);
  final result = await wallet.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("is success: ${result.isSuccess}");
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");

  /// https://devnet.xrpl.org/transactions/696C6D301AA2C103817A55F2C8E0A97E1533C51053141E9C4D806624CCDE2CC3
}

Future<void> payment(
    QuickWallet wallet, String issuer, String destionation) async {
  final transaction = Payment(
      account: wallet.address,
      signer: XRPLSignature.signer(wallet.pubHex),
      flags: TrustSetFlag.tfClearNoRipple.value,
      destination: destionation,
      amount: CurrencyAmount.issue(
          IssuedCurrencyAmount(value: "500", currency: "USD", issuer: issuer)),
      memos: [exampleMemo]);
  await XRPHelper.autoFill(wallet.rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = wallet.privateKey.sign(blob);
  transaction.setSignature(sig);
  final trBlob = transaction.toBlob(forSigning: false);
  final result = await wallet.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("is success: ${result.isSuccess}");
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");

  /// https://devnet.xrpl.org/transactions/7D62779213F6C5206032B6D207050F37E24E4E96AE8E1A1371BD5E7FCF6DB936
}

Future<void> _ammCreate(QuickWallet wallet, String issuer,
    {String currencyCode = "USD"}) async {
  final transaction = AMMCreate(
      account: wallet.address,
      signer: XRPLSignature.signer(wallet.pubHex),
      tradingFee: 12,
      amount: CurrencyAmount.xrp(BigInt.from(250)),
      amount2: CurrencyAmount.issue(IssuedCurrencyAmount(
          value: "500", currency: currencyCode, issuer: issuer)),
      memos: [exampleMemo]);
  await XRPHelper.autoFill(wallet.rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = wallet.privateKey.sign(blob);
  transaction.setSignature(sig);
  final trBlob = transaction.toBlob(forSigning: false);
  final result = await wallet.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("is success: ${result.isSuccess}");
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");

  await wallet.rpc.request(XRPRequestAMMInfo(
      asset: XRP(),
      asset2: IssuedCurrency(currency: currencyCode, issuer: issuer)));

  /// https://devnet.xrpl.org/transactions/41EE34649919A8D00AE3E1EBFF15CF145E084E7D6C74B0D6BEF3CF2458799DDC
}
