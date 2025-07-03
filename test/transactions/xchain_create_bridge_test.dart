import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

void main() {
  test("XChainCreateBridge JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "XChainCreateBridge",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3044022072172F30993B55AF177C2893132A11E0DB3D8E0095BB74EA630899C20B17060F022059AD32FCD93B4048ED0168BC7C6FE19996019EC10F83877EB9F44EB4E4DCCE6C",
      "xchain_bridge": {
        "locking_chain_door": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
        "locking_chain_issue": {"currency": "XRP"},
        "issuing_chain_door": "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
        "issuing_chain_issue": {"currency": "XRP"}
      },
      "signature_reward": "200",
      "min_account_create_amount": "10000000"
    };
    final transaction = XChainCreateBridge.fromJson(json);
    expect(transaction.toJson(), json);

    expect(transaction.toBlob(forSigning: false),
        "120030240000000A201B0082715468400000000000000A601D40000000000000C8601E40000000009896807321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74463044022072172F30993B55AF177C2893132A11E0DB3D8E0095BB74EA630899C20B17060F022059AD32FCD93B4048ED0168BC7C6FE19996019EC10F83877EB9F44EB4E4DCCE6C811490FB88B6E10522FAAB709CE7A91120E738BD5CCC01191490FB88B6E10522FAAB709CE7A91120E738BD5CCC000000000000000000000000000000000000000014B5F762798A53D543A014CAF8B297CFF8F2F937E80000000000000000000000000000000000000000");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
  // return;
  test("XChainCreateBridge XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "XChainCreateBridge",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3044022072172F30993B55AF177C2893132A11E0DB3D8E0095BB74EA630899C20B17060F022059AD32FCD93B4048ED0168BC7C6FE19996019EC10F83877EB9F44EB4E4DCCE6C",
      "XChainBridge": {
        "LockingChainDoor": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
        "LockingChainIssue": {"currency": "XRP"},
        "IssuingChainDoor": "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
        "IssuingChainIssue": {"currency": "XRP"}
      },
      "SignatureReward": "200",
      "MinAccountCreateAmount": "10000000"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "120030240000000A201B0082715468400000000000000A601D40000000000000C8601E40000000009896807321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74463044022072172F30993B55AF177C2893132A11E0DB3D8E0095BB74EA630899C20B17060F022059AD32FCD93B4048ED0168BC7C6FE19996019EC10F83877EB9F44EB4E4DCCE6C811490FB88B6E10522FAAB709CE7A91120E738BD5CCC01191490FB88B6E10522FAAB709CE7A91120E738BD5CCC000000000000000000000000000000000000000014B5F762798A53D543A014CAF8B297CFF8F2F937E80000000000000000000000000000000000000000");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
