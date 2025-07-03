import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("SignerListSet JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "SignerListSet",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3045022100B15D63E029A25979B590648E210D4B721556AC8FCA50384447EF50A41527B81D02202DBEC93480561CA3556ADC1B079391CAED33B6FD260463E44400315E1E7A2379",
      "signer_quorum": 1,
      "signer_entries": [
        {
          "signer_entry": {
            "account": "rEGUKt6VsUWL3FAsvfsKpbxUzXY26FBx8y",
            "signer_weight": 1
          }
        }
      ]
    };

    final transaction = SignerListSet.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toBlob(forSigning: false),
        "12000C240000000A201B0082715420230000000168400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100B15D63E029A25979B590648E210D4B721556AC8FCA50384447EF50A41527B81D02202DBEC93480561CA3556ADC1B079391CAED33B6FD260463E44400315E1E7A2379811490FB88B6E10522FAAB709CE7A91120E738BD5CCCF4EB13000181149C7174628BC3B3A2BFC48C684F077763A8E1054BE1F1");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toBlob(forSigning: false));
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("SignerListSet XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "SignerListSet",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100B15D63E029A25979B590648E210D4B721556AC8FCA50384447EF50A41527B81D02202DBEC93480561CA3556ADC1B079391CAED33B6FD260463E44400315E1E7A2379",
      "SignerQuorum": 1,
      "SignerEntries": [
        {
          "SignerEntry": {
            "Account": "rEGUKt6VsUWL3FAsvfsKpbxUzXY26FBx8y",
            "SignerWeight": 1
          }
        }
      ]
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "12000C240000000A201B0082715420230000000168400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100B15D63E029A25979B590648E210D4B721556AC8FCA50384447EF50A41527B81D02202DBEC93480561CA3556ADC1B079391CAED33B6FD260463E44400315E1E7A2379811490FB88B6E10522FAAB709CE7A91120E738BD5CCCF4EB13000181149C7174628BC3B3A2BFC48C684F077763A8E1054BE1F1");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
