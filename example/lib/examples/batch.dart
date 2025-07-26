import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void main() async {
  final main = QuickWallet.create(971632);
  final dest1 = QuickWallet.create(971633);
  await main.fucent();
  await dest1.fucent();

  final paymet = Payment(
      flags: [TransactionFlag.innerBatchTxn.id],
      amount: XRPAmount(XRPHelper.xrpToDrop("12")),
      destination: "ranfTcEQKYGVWTtRRFGXqyCevtaL5wrBjp",
      account: main.address);
  final paymet2 = Payment(
      flags: [TransactionFlag.innerBatchTxn.id],
      amount: XRPAmount(XRPHelper.xrpToDrop("12")),
      destination: "ranfTcEQKYGVWTtRRFGXqyCevtaL5wrBjp",
      account: dest1.address);
  final batch = Batch(
      // lastLedgerSequence: 9218775,
      rawTransactions: [paymet, paymet2],
      account: main.address,
      flags: [0x00010000],
      fee: BigInt.from(50));
  await XRPHelper.autoFill(main.rpc, batch,
      setupLedgerSequence: true, calculateFee: false);
  final sig2 = dest1.privateKey.sign(batch.toBatchSigningBloblBytes());
  batch.setBatchSignure([
    BatchSigner(
        account: dest1.address,
        signingPubKey: sig2.signingPubKey,
        txnSignature: sig2.signature),
  ]);
  batch.setSignature(XRPLSignature.signer(main.pubHex));
  final signBlob = batch.toSigningBlobBytes(main.toAddress);
  batch.setSignature(main.privateKey.sign(signBlob));
  final finalBlob = batch.toTransactionBlob();
  await main.rpc.request(XRPRequestSubmit(txBlob: finalBlob));

  /// https://devnet.xrpl.org/transactions/A285E70B541151D58C542D0A4DEF8688F9709111B3F716F25AD19FBC36CAD398
}
