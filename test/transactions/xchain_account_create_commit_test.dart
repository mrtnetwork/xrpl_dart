import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

void main() {
  test("XChainAccountCreateCommit JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "XChainAccountCreateCommit",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3045022100E0B60D1F4D9FAA71DACADE8D9C073769A1AD4FC8A9C6C964C3C5803EF2F73DD102202C68A89BD3BFF53BCFC125A9FFE5D794846E88E26C6D78215A986B4BF2EC895E",
      "xchain_bridge": {
        "locking_chain_door": "rPFV632NxvfcuQ95daQv8LTLwHecz3taRw",
        "locking_chain_issue": {"currency": "XRP"},
        "issuing_chain_door": "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
        "issuing_chain_issue": {"currency": "XRP"}
      },
      "signature_reward": "200",
      "destination": "rpQkqYo9ksyn1Cq9TGWeou89bDxg7eQWQe",
      "amount": "10000000"
    };
    final transaction = XChainAccountCreateCommit.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toTransactionBlob(),
        "12002C240000000A201B0082715461400000000098968068400000000000000A601D40000000000000C87321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100E0B60D1F4D9FAA71DACADE8D9C073769A1AD4FC8A9C6C964C3C5803EF2F73DD102202C68A89BD3BFF53BCFC125A9FFE5D794846E88E26C6D78215A986B4BF2EC895E811490FB88B6E10522FAAB709CE7A91120E738BD5CCC83140F764945CE28DE1EAF88D42ED8014C00207FF4CF011914FA4E44ABAC11C26F09651C4C914705357B03627C000000000000000000000000000000000000000014B5F762798A53D543A014CAF8B297CFF8F2F937E80000000000000000000000000000000000000000");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("XChainAccountCreateCommit XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "XChainAccountCreateCommit",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100E0B60D1F4D9FAA71DACADE8D9C073769A1AD4FC8A9C6C964C3C5803EF2F73DD102202C68A89BD3BFF53BCFC125A9FFE5D794846E88E26C6D78215A986B4BF2EC895E",
      "XChainBridge": {
        "LockingChainDoor": "rPFV632NxvfcuQ95daQv8LTLwHecz3taRw",
        "LockingChainIssue": {"currency": "XRP"},
        "IssuingChainDoor": "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
        "IssuingChainIssue": {"currency": "XRP"}
      },
      "SignatureReward": "200",
      "Destination": "rpQkqYo9ksyn1Cq9TGWeou89bDxg7eQWQe",
      "Amount": "10000000"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "12002C240000000A201B0082715461400000000098968068400000000000000A601D40000000000000C87321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100E0B60D1F4D9FAA71DACADE8D9C073769A1AD4FC8A9C6C964C3C5803EF2F73DD102202C68A89BD3BFF53BCFC125A9FFE5D794846E88E26C6D78215A986B4BF2EC895E811490FB88B6E10522FAAB709CE7A91120E738BD5CCC83140F764945CE28DE1EAF88D42ED8014C00207FF4CF011914FA4E44ABAC11C26F09651C4C914705357B03627C000000000000000000000000000000000000000014B5F762798A53D543A014CAF8B297CFF8F2F937E80000000000000000000000000000000000000000");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });
}
