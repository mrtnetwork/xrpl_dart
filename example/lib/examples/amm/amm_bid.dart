// ignore_for_file: avoid_print

import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void ammBid() async {
  final isuuerWallet = QuickWallet.create(0, account: 5);
  final lpWallet = QuickWallet.create(1, account: 5);

  final info = await isuuerWallet.rpc.request(XRPRequestAMMInfo(
      asset: XRPCurrency(),
      asset2: IssuedCurrency(currency: "USD", issuer: isuuerWallet.address)));
  final lpToken = info.amm.lpToken;
  await _ammBid(
    lpWallet,
    XRPCurrency(),
    IssuedCurrency(currency: "USD", issuer: isuuerWallet.address),
  );
  await _ammBitWithAuthAccount(
      lpWallet,
      XRPCurrency(),
      IssuedCurrency(currency: "USD", issuer: isuuerWallet.address),
      [
        AuthAccount(account: isuuerWallet.address),
      ],
      bidMax: IssuedCurrencyAmount(
          value: "20", currency: lpToken.currency, issuer: lpToken.issuer),
      bidMin: IssuedCurrencyAmount(
          value: "5", currency: lpToken.currency, issuer: lpToken.issuer));
}

Future<void> _ammBitWithAuthAccount(QuickWallet wallet, BaseCurrency assets,
    BaseCurrency assets2, List<AuthAccount> authAccount,
    {BaseAmount? bidMin, BaseAmount? bidMax}) async {
  final transaction = AMMBid(
      account: wallet.address,
      signer: XRPLSignature.signer(wallet.pubHex),
      asset: assets,
      asset2: assets2,
      memos: [exampleMemo],
      authAccounts: authAccount,
      bidMax: bidMax,
      bidMin: bidMin);
  await XRPHelper.autoFill(wallet.rpc, transaction);
  final blob = transaction.toSigningBlobBytes(wallet.toAddress);
  print("sign transction");
  final sig = wallet.privateKey.sign(blob);
  transaction.setSignature(sig);
  final trBlob = transaction.toTransactionBlob();
  final result = await wallet.rpc.request(XRPRequestSubmit(txBlob: trBlob));
  print("is success: ${result.isSuccess}");
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");

  /// https://devnet.xrpl.org/transactions/59245131C3268C467282B7C3BFDC21DD611C81F3869C14E30EBEC4688F1A7431
}

Future<void> _ammBid(
    QuickWallet wallet, BaseCurrency assets, BaseCurrency assets2) async {
  final transaction = AMMBid(
      account: wallet.address,
      signer: XRPLSignature.signer(wallet.pubHex),
      asset: assets,
      asset2: assets2,
      memos: [exampleMemo]);
  await XRPHelper.autoFill(wallet.rpc, transaction);
  final blob = transaction.toSigningBlobBytes(wallet.toAddress);
  print("sign transction");
  final sig = wallet.privateKey.sign(blob);
  transaction.setSignature(sig);
  final trBlob = transaction.toTransactionBlob();
  final result = await wallet.rpc.request(XRPRequestSubmit(txBlob: trBlob));
  print("is success: ${result.isSuccess}");
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");

  /// https://devnet.xrpl.org/transactions/50C0534F09FDDE42C2935AB72619B381B29075A1772127ADE45C976822EAF5CD
}
