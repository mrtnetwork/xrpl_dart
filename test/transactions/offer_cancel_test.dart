import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("OfferCancel JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "OfferCancel",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3045022100A3B61BFB6FC1DBB0E0DEF429EC7C04CF7BBE761CFA79811089BDD86E1C1F4225022028C406B91775DB4BF56B60D89A6EF77536D5D4F486971199912B6100F7CDC100",
      "offer_sequence": 8543619
    };
    final transaction = OfferCancel.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toTransactionBlob(),
        "120008240000000A201900825D83201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100A3B61BFB6FC1DBB0E0DEF429EC7C04CF7BBE761CFA79811089BDD86E1C1F4225022028C406B91775DB4BF56B60D89A6EF77536D5D4F486971199912B6100F7CDC100811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("OfferCancel XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "OfferCancel",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100A3B61BFB6FC1DBB0E0DEF429EC7C04CF7BBE761CFA79811089BDD86E1C1F4225022028C406B91775DB4BF56B60D89A6EF77536D5D4F486971199912B6100F7CDC100",
      "OfferSequence": 8543619
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "120008240000000A201900825D83201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100A3B61BFB6FC1DBB0E0DEF429EC7C04CF7BBE761CFA79811089BDD86E1C1F4225022028C406B91775DB4BF56B60D89A6EF77536D5D4F486971199912B6100F7CDC100811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");
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
