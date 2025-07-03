import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("CheckCash JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "CheckCash",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "304402205B49B7CC3DC4CFE4D52AD718663A867E7D57E0E43899DA03F419CF9F5C807CD60220289F43B58229856091AC00BE6A798E1CCDF848D901742F5BF8B35C2B41179D2E",
      "check_id":
          "838766BA2B995C00744175F69A1B11E32C3DBC40E64801A4056FCBD657F57334",
      "amount": "100000000"
    };
    final transaction = CheckCash.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toBlob(forSigning: false),
        "120011240000000A201B008271545018838766BA2B995C00744175F69A1B11E32C3DBC40E64801A4056FCBD657F57334614000000005F5E10068400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E7446304402205B49B7CC3DC4CFE4D52AD718663A867E7D57E0E43899DA03F419CF9F5C807CD60220289F43B58229856091AC00BE6A798E1CCDF848D901742F5BF8B35C2B41179D2E811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("CheckCash XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "CheckCash",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "304402205B49B7CC3DC4CFE4D52AD718663A867E7D57E0E43899DA03F419CF9F5C807CD60220289F43B58229856091AC00BE6A798E1CCDF848D901742F5BF8B35C2B41179D2E",
      "CheckID":
          "838766BA2B995C00744175F69A1B11E32C3DBC40E64801A4056FCBD657F57334",
      "Amount": "100000000"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "120011240000000A201B008271545018838766BA2B995C00744175F69A1B11E32C3DBC40E64801A4056FCBD657F57334614000000005F5E10068400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E7446304402205B49B7CC3DC4CFE4D52AD718663A867E7D57E0E43899DA03F419CF9F5C807CD60220289F43B58229856091AC00BE6A798E1CCDF848D901742F5BF8B35C2B41179D2E811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
  test("CheckCash XRPL 2", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "CheckCash",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100CDBB4FF91A6E3567DB3988EFDA327843A0EDE56331648545688618FECE5354CD02200BE9C5DCAC8B4FAFE898AA11BBC37AE5AAFC866B8BE954BAA6DDF7C3BD8393D5",
      "CheckID":
          "838766BA2B995C00744175F69A1B11E32C3DBC40E64801A4056FCBD657F57334",
      "DeliverMin": "100000000"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "120011240000000A201B008271545018838766BA2B995C00744175F69A1B11E32C3DBC40E64801A4056FCBD657F5733468400000000000000A6A4000000005F5E1007321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100CDBB4FF91A6E3567DB3988EFDA327843A0EDE56331648545688618FECE5354CD02200BE9C5DCAC8B4FAFE898AA11BBC37AE5AAFC866B8BE954BAA6DDF7C3BD8393D5811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
