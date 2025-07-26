import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

void main() {
  test("XChainCommit JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "XChainCommit",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "30440220159FB231EEC2D1E9ECF8F5BCB14DEE1D1D2B338541E0644746BCBAB6C082C4D4022021178C265D15BF089244EDB1DC8B0BFC36B699CEB8C0AA5FA18EF6FBBFCDA96B",
      "xchain_bridge": {
        "locking_chain_door": "rPFV632NxvfcuQ95daQv8LTLwHecz3taRw",
        "locking_chain_issue": {"currency": "XRP"},
        "issuing_chain_door": "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
        "issuing_chain_issue": {"currency": "XRP"}
      },
      "xchain_claim_id": 1,
      "amount": "100000"
    };
    final transaction = XChainCommit.fromJson(json);
    expect(transaction.toJson(), json);

    expect(transaction.toTransactionBlob(),
        "12002A240000000A201B00827154301400000000000000016140000000000186A068400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E744630440220159FB231EEC2D1E9ECF8F5BCB14DEE1D1D2B338541E0644746BCBAB6C082C4D4022021178C265D15BF089244EDB1DC8B0BFC36B699CEB8C0AA5FA18EF6FBBFCDA96B811490FB88B6E10522FAAB709CE7A91120E738BD5CCC011914FA4E44ABAC11C26F09651C4C914705357B03627C000000000000000000000000000000000000000014B5F762798A53D543A014CAF8B297CFF8F2F937E80000000000000000000000000000000000000000");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("XChainCommit XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "XChainCommit",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "30440220159FB231EEC2D1E9ECF8F5BCB14DEE1D1D2B338541E0644746BCBAB6C082C4D4022021178C265D15BF089244EDB1DC8B0BFC36B699CEB8C0AA5FA18EF6FBBFCDA96B",
      "XChainBridge": {
        "LockingChainDoor": "rPFV632NxvfcuQ95daQv8LTLwHecz3taRw",
        "LockingChainIssue": {"currency": "XRP"},
        "IssuingChainDoor": "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
        "IssuingChainIssue": {"currency": "XRP"}
      },
      "XChainClaimID": 1,
      "Amount": "100000"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "12002A240000000A201B00827154301400000000000000016140000000000186A068400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E744630440220159FB231EEC2D1E9ECF8F5BCB14DEE1D1D2B338541E0644746BCBAB6C082C4D4022021178C265D15BF089244EDB1DC8B0BFC36B699CEB8C0AA5FA18EF6FBBFCDA96B811490FB88B6E10522FAAB709CE7A91120E738BD5CCC011914FA4E44ABAC11C26F09651C4C914705357B03627C000000000000000000000000000000000000000014B5F762798A53D543A014CAF8B297CFF8F2F937E80000000000000000000000000000000000000000");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });
}
