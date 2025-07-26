import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("PaymentChannelFund JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "PaymentChannelFund",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3045022100A26ED06B7795CF8E9E2ED0E46DA49CB8AD26D42E96A383CB92F58854EF44147302207641DB61063DA555F00838CF390A8557CA483D919AE6FA1D1BCCF05DE5284F85",
      "channel":
          "57C945850FAFAF1482FA1C0A1D838E6F64EFAC6237683FA79A892CC2FFC156FD",
      "amount": "1"
    };
    final transaction = PaymentChannelFund.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toTransactionBlob(),
        "12000E240000000A201B00827154501657C945850FAFAF1482FA1C0A1D838E6F64EFAC6237683FA79A892CC2FFC156FD61400000000000000168400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100A26ED06B7795CF8E9E2ED0E46DA49CB8AD26D42E96A383CB92F58854EF44147302207641DB61063DA555F00838CF390A8557CA483D919AE6FA1D1BCCF05DE5284F85811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("PaymentChannelFund XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "PaymentChannelFund",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100A26ED06B7795CF8E9E2ED0E46DA49CB8AD26D42E96A383CB92F58854EF44147302207641DB61063DA555F00838CF390A8557CA483D919AE6FA1D1BCCF05DE5284F85",
      "Channel":
          "57C945850FAFAF1482FA1C0A1D838E6F64EFAC6237683FA79A892CC2FFC156FD",
      "Amount": "1"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "12000E240000000A201B00827154501657C945850FAFAF1482FA1C0A1D838E6F64EFAC6237683FA79A892CC2FFC156FD61400000000000000168400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100A26ED06B7795CF8E9E2ED0E46DA49CB8AD26D42E96A383CB92F58854EF44147302207641DB61063DA555F00838CF390A8557CA483D919AE6FA1D1BCCF05DE5284F85811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });
}
