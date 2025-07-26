import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("SetRegularKey JSON", () {
    final json = {
      "account": "rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1",
      "transaction_type": "SetRegularKey",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "304402205916D11A246FEB6442488C1D051D652F923D03A353B0B4FB53713BFE0B7604C4022009FF9650AAC7BC548900F37B1BF7928A3CF299D569238377F3B9E4428636444B",
      "regular_key": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f"
    };

    final transaction = SetRegularKey.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toTransactionBlob(),
        "120005240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E7446304402205916D11A246FEB6442488C1D051D652F923D03A353B0B4FB53713BFE0B7604C4022009FF9650AAC7BC548900F37B1BF7928A3CF299D569238377F3B9E4428636444B81142F128223E9380492BD2E02A1D7A6C259F25D6735881490FB88B6E10522FAAB709CE7A91120E738BD5CCC");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("SetRegularKey XRPL", () {
    final json = {
      "Account": "rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1",
      "TransactionType": "SetRegularKey",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "304402205916D11A246FEB6442488C1D051D652F923D03A353B0B4FB53713BFE0B7604C4022009FF9650AAC7BC548900F37B1BF7928A3CF299D569238377F3B9E4428636444B",
      "RegularKey": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "120005240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E7446304402205916D11A246FEB6442488C1D051D652F923D03A353B0B4FB53713BFE0B7604C4022009FF9650AAC7BC548900F37B1BF7928A3CF299D569238377F3B9E4428636444B81142F128223E9380492BD2E02A1D7A6C259F25D6735881490FB88B6E10522FAAB709CE7A91120E738BD5CCC");
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
