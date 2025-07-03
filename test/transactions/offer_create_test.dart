import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("OfferCreate JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "OfferCreate",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3044022023B5750AF469B6BF41992003E0A35564C7D154E0A3B0415BF3D983316907419302204FB112D69BADBA2E0CF2FA059ADFCB7249D36E1FEFD54DF34F646BBAE7B676B4",
      "taker_gets": "13100000",
      "taker_pays": {
        "currency": "USD",
        "issuer": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
        "value": "10"
      }
    };
    final transaction = OfferCreate.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toBlob(forSigning: false),
        "120007240000000A201B0082715464D4C38D7EA4C68000000000000000000000000000555344000000000090FB88B6E10522FAAB709CE7A91120E738BD5CCC654000000000C7E3E068400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74463044022023B5750AF469B6BF41992003E0A35564C7D154E0A3B0415BF3D983316907419302204FB112D69BADBA2E0CF2FA059ADFCB7249D36E1FEFD54DF34F646BBAE7B676B4811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toBlob(forSigning: false));
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("OfferCreate XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "OfferCreate",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3044022023B5750AF469B6BF41992003E0A35564C7D154E0A3B0415BF3D983316907419302204FB112D69BADBA2E0CF2FA059ADFCB7249D36E1FEFD54DF34F646BBAE7B676B4",
      "TakerGets": "13100000",
      "TakerPays": {
        "currency": "USD",
        "issuer": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
        "value": "10"
      }
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "120007240000000A201B0082715464D4C38D7EA4C68000000000000000000000000000555344000000000090FB88B6E10522FAAB709CE7A91120E738BD5CCC654000000000C7E3E068400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74463044022023B5750AF469B6BF41992003E0A35564C7D154E0A3B0415BF3D983316907419302204FB112D69BADBA2E0CF2FA059ADFCB7249D36E1FEFD54DF34F646BBAE7B676B4811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
