import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

void main() {
  test("XChainModifyBridge JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "XChainModifyBridge",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "30440220309625CCEFCD624739588A2DF8F4E690C0BAD820AE445AACAE97F33E92822AF302204B98CA41C577154483FB5EBFE05F0D1A094048D4E2535D09C4D9530BBC8DC102",
      "xchain_bridge": {
        "locking_chain_door": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
        "locking_chain_issue": {"currency": "XRP"},
        "issuing_chain_door": "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
        "issuing_chain_issue": {"currency": "XRP"}
      },
      "signature_reward": "300",
      "min_account_create_amount": "10000000"
    };
    final transaction = XChainModifyBridge.fromJson(json);
    expect(transaction.toJson(), json);

    expect(transaction.toBlob(forSigning: false),
        "12002F240000000A201B0082715468400000000000000A601D400000000000012C601E40000000009896807321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E744630440220309625CCEFCD624739588A2DF8F4E690C0BAD820AE445AACAE97F33E92822AF302204B98CA41C577154483FB5EBFE05F0D1A094048D4E2535D09C4D9530BBC8DC102811490FB88B6E10522FAAB709CE7A91120E738BD5CCC01191490FB88B6E10522FAAB709CE7A91120E738BD5CCC000000000000000000000000000000000000000014B5F762798A53D543A014CAF8B297CFF8F2F937E80000000000000000000000000000000000000000");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
  test("XChainModifyBridge XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "XChainModifyBridge",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "30440220309625CCEFCD624739588A2DF8F4E690C0BAD820AE445AACAE97F33E92822AF302204B98CA41C577154483FB5EBFE05F0D1A094048D4E2535D09C4D9530BBC8DC102",
      "XChainBridge": {
        "LockingChainDoor": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
        "LockingChainIssue": {"currency": "XRP"},
        "IssuingChainDoor": "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
        "IssuingChainIssue": {"currency": "XRP"}
      },
      "SignatureReward": "300",
      "MinAccountCreateAmount": "10000000"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "12002F240000000A201B0082715468400000000000000A601D400000000000012C601E40000000009896807321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E744630440220309625CCEFCD624739588A2DF8F4E690C0BAD820AE445AACAE97F33E92822AF302204B98CA41C577154483FB5EBFE05F0D1A094048D4E2535D09C4D9530BBC8DC102811490FB88B6E10522FAAB709CE7A91120E738BD5CCC01191490FB88B6E10522FAAB709CE7A91120E738BD5CCC000000000000000000000000000000000000000014B5F762798A53D543A014CAF8B297CFF8F2F937E80000000000000000000000000000000000000000");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
