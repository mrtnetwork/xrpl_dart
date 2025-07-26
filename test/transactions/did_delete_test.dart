import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("DIDDelete JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "DIDDelete",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3044022022CE22880703E9705DC6E3F7E191F2346FA4EAAF9E03A4E7A14B59BEB63FC08A022017ED388DDB0F1F5967F3EF929083E552A3C90513E3864E427102261C96F896C1"
    };
    final transaction = DIDDelete.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toTransactionBlob(),
        "120032240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74463044022022CE22880703E9705DC6E3F7E191F2346FA4EAAF9E03A4E7A14B59BEB63FC08A022017ED388DDB0F1F5967F3EF929083E552A3C90513E3864E427102261C96F896C1811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("DIDDelete XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "DIDDelete",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3044022022CE22880703E9705DC6E3F7E191F2346FA4EAAF9E03A4E7A14B59BEB63FC08A022017ED388DDB0F1F5967F3EF929083E552A3C90513E3864E427102261C96F896C1"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "120032240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74463044022022CE22880703E9705DC6E3F7E191F2346FA4EAAF9E03A4E7A14B59BEB63FC08A022017ED388DDB0F1F5967F3EF929083E552A3C90513E3864E427102261C96F896C1811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");
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
