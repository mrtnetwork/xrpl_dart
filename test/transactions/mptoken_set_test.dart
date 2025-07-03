import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("MPTokenIssuanceSet JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "MPTokenIssuanceSet",
      "fee": "10",
      "sequence": 10,
      "flags": 1,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "30440220402D8ABF537D8DA902DEBDC3741F81F67CD544BE39C22BE1E36F46310604DCE40220575C328704723728F106FA4E5A16436D161D79F6685BC6682CB9DAB2759BC0B8",
      "mptoken_issuance_id": "fec874578aafa5acfea899950730bdc5bd5eb31bcf5ebf2a"
    };
    final transaction = MPTokenIssuanceSet.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toBlob(forSigning: false),
        "1200382200000001240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E744630440220402D8ABF537D8DA902DEBDC3741F81F67CD544BE39C22BE1E36F46310604DCE40220575C328704723728F106FA4E5A16436D161D79F6685BC6682CB9DAB2759BC0B8811490FB88B6E10522FAAB709CE7A91120E738BD5CCC0115FEC874578AAFA5ACFEA899950730BDC5BD5EB31BCF5EBF2A");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toBlob(forSigning: false));
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("MPTokenIssuanceSet XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "MPTokenIssuanceSet",
      "Fee": "10",
      "Sequence": 10,
      "Flags": 1,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "30440220402D8ABF537D8DA902DEBDC3741F81F67CD544BE39C22BE1E36F46310604DCE40220575C328704723728F106FA4E5A16436D161D79F6685BC6682CB9DAB2759BC0B8",
      "MPTokenIssuanceID": "fec874578aafa5acfea899950730bdc5bd5eb31bcf5ebf2a"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "1200382200000001240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E744630440220402D8ABF537D8DA902DEBDC3741F81F67CD544BE39C22BE1E36F46310604DCE40220575C328704723728F106FA4E5A16436D161D79F6685BC6682CB9DAB2759BC0B8811490FB88B6E10522FAAB709CE7A91120E738BD5CCC0115FEC874578AAFA5ACFEA899950730BDC5BD5EB31BCF5EBF2A");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
