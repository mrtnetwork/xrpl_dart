import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("DIDSet JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "DIDSet",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3044022023B8469232C7FC185D983654F7FCB4789BAE89572F40D4B5273D4636615FF0E602200583B10B4D45232791FE6D831FD49BB35CF53B847ED3D5E731992BA563E18F0A",
      "did_document": "1234567890abcdefABCDEF",
      "data": "1234567890abcdefABCDEF",
      "uri": "1234567890abcdefABCDEF"
    };
    final transaction = DIDSet.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toBlob(forSigning: false),
        "120031240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74463044022023B8469232C7FC185D983654F7FCB4789BAE89572F40D4B5273D4636615FF0E602200583B10B4D45232791FE6D831FD49BB35CF53B847ED3D5E731992BA563E18F0A750B1234567890ABCDEFABCDEF701A0B1234567890ABCDEFABCDEF701B0B1234567890ABCDEFABCDEF811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toBlob(forSigning: false));
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("DIDSet XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "DIDSet",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3044022023B8469232C7FC185D983654F7FCB4789BAE89572F40D4B5273D4636615FF0E602200583B10B4D45232791FE6D831FD49BB35CF53B847ED3D5E731992BA563E18F0A",
      "DIDDocument": "1234567890abcdefABCDEF",
      "Data": "1234567890abcdefABCDEF",
      "URI": "1234567890abcdefABCDEF"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "120031240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74463044022023B8469232C7FC185D983654F7FCB4789BAE89572F40D4B5273D4636615FF0E602200583B10B4D45232791FE6D831FD49BB35CF53B847ED3D5E731992BA563E18F0A750B1234567890ABCDEFABCDEF701A0B1234567890ABCDEFABCDEF701B0B1234567890ABCDEFABCDEF811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
