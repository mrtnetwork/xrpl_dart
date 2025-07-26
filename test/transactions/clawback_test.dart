import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("Clawback JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "Clawback",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "304402202911B172B85EE2C724DE5457F7DF2BC495E45B52B0F4F732C27DE123897B383B022015681998082D05DA9CAD3F02B78C8EEB5B5410639DBF2D457D59A4E11F8ECF40",
      "amount": {
        "currency": "USD",
        "issuer": "rPXs84cXuHyLKWydhpmxFri2bqNRhTeH6v",
        "value": "100"
      }
    };
    final transaction = Clawback.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toTransactionBlob(),
        "12001E240000000A201B0082715461D5038D7EA4C680000000000000000000000000005553440000000000F7019191EB61E65F0BF50F5F6B674E8BE0654ED568400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E7446304402202911B172B85EE2C724DE5457F7DF2BC495E45B52B0F4F732C27DE123897B383B022015681998082D05DA9CAD3F02B78C8EEB5B5410639DBF2D457D59A4E11F8ECF40811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("Clawback XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "Clawback",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "304402202911B172B85EE2C724DE5457F7DF2BC495E45B52B0F4F732C27DE123897B383B022015681998082D05DA9CAD3F02B78C8EEB5B5410639DBF2D457D59A4E11F8ECF40",
      "Amount": {
        "currency": "USD",
        "issuer": "rPXs84cXuHyLKWydhpmxFri2bqNRhTeH6v",
        "value": "100"
      }
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "12001E240000000A201B0082715461D5038D7EA4C680000000000000000000000000005553440000000000F7019191EB61E65F0BF50F5F6B674E8BE0654ED568400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E7446304402202911B172B85EE2C724DE5457F7DF2BC495E45B52B0F4F732C27DE123897B383B022015681998082D05DA9CAD3F02B78C8EEB5B5410639DBF2D457D59A4E11F8ECF40811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("Clawback XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "Clawback",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100F92DE248B7B37ED1DB03B57246C77A41F9AA74702D0E4AEE0166DEC52957DCEF02203A1BCB2BFBA730B588AC9D5984966EC6DD3BB64D42DA78C0116BD84D8ED0D73F",
      "Amount": {
        "mpt_issuance_id": "6068f959c6e7fdb165b9cf8b55060157982ae3d038180164",
        "value": "500"
      },
      "Holder": "rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);

    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "12001E240000000A201B00827154616000000000000001F46068F959C6E7FDB165B9CF8B55060157982AE3D03818016468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100F92DE248B7B37ED1DB03B57246C77A41F9AA74702D0E4AEE0166DEC52957DCEF02203A1BCB2BFBA730B588AC9D5984966EC6DD3BB64D42DA78C0116BD84D8ED0D73F811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8B142F128223E9380492BD2E02A1D7A6C259F25D6735");
    final fromBlob = SubmittableTransaction.fromBlob(
        "12001E240000000A201B00827154616000000000000001F46068F959C6E7FDB165B9CF8B55060157982AE3D03818016468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100F92DE248B7B37ED1DB03B57246C77A41F9AA74702D0E4AEE0166DEC52957DCEF02203A1BCB2BFBA730B588AC9D5984966EC6DD3BB64D42DA78C0116BD84D8ED0D73F811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8B142F128223E9380492BD2E02A1D7A6C259F25D6735");
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });
}
