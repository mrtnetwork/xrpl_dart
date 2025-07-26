import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

void main() {
  test("XChainCreateClaimID JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "XChainCreateClaimID",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "304402205D75019F67E5E33FA6194C4227388C210D6BAA5A033582508568D42FA5B6AE03022039FCE6CAAC9A18516D97B834CEBC65C04B3B448AC0BDFFAFF3527E5AEB44311C",
      "xchain_bridge": {
        "locking_chain_door": "rPFV632NxvfcuQ95daQv8LTLwHecz3taRw",
        "locking_chain_issue": {"currency": "XRP"},
        "issuing_chain_door": "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
        "issuing_chain_issue": {"currency": "XRP"}
      },
      "signature_reward": "200",
      "other_chain_source": "rNJNipYraCYaMx3eddyzLKbn8QK62d7cW6"
    };
    final transaction = XChainCreateClaimId.fromJson(json);
    expect(transaction.toJson(), json);

    expect(transaction.toTransactionBlob(),
        "120029240000000A201B0082715468400000000000000A601D40000000000000C87321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E7446304402205D75019F67E5E33FA6194C4227388C210D6BAA5A033582508568D42FA5B6AE03022039FCE6CAAC9A18516D97B834CEBC65C04B3B448AC0BDFFAFF3527E5AEB44311C811490FB88B6E10522FAAB709CE7A91120E738BD5CCC80121491DC43958728E60A3C6198DE65B6B047B7F01814011914FA4E44ABAC11C26F09651C4C914705357B03627C000000000000000000000000000000000000000014B5F762798A53D543A014CAF8B297CFF8F2F937E80000000000000000000000000000000000000000");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });
  // return;
  test("XChainCreateClaimID XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "XChainCreateClaimID",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "304402205D75019F67E5E33FA6194C4227388C210D6BAA5A033582508568D42FA5B6AE03022039FCE6CAAC9A18516D97B834CEBC65C04B3B448AC0BDFFAFF3527E5AEB44311C",
      "XChainBridge": {
        "LockingChainDoor": "rPFV632NxvfcuQ95daQv8LTLwHecz3taRw",
        "LockingChainIssue": {"currency": "XRP"},
        "IssuingChainDoor": "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
        "IssuingChainIssue": {"currency": "XRP"}
      },
      "SignatureReward": "200",
      "OtherChainSource": "rNJNipYraCYaMx3eddyzLKbn8QK62d7cW6"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "120029240000000A201B0082715468400000000000000A601D40000000000000C87321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E7446304402205D75019F67E5E33FA6194C4227388C210D6BAA5A033582508568D42FA5B6AE03022039FCE6CAAC9A18516D97B834CEBC65C04B3B448AC0BDFFAFF3527E5AEB44311C811490FB88B6E10522FAAB709CE7A91120E738BD5CCC80121491DC43958728E60A3C6198DE65B6B047B7F01814011914FA4E44ABAC11C26F09651C4C914705357B03627C000000000000000000000000000000000000000014B5F762798A53D543A014CAF8B297CFF8F2F937E80000000000000000000000000000000000000000");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });
}
