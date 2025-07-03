import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("TrustSet JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "TrustSet",
      "fee": "10",
      "sequence": 10,
      "flags": 131072,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3045022100C91EEC32F7F9C6652527F99DA6C3AC533AD533CE5D26E7CE9DBBDBE890604BB502203C6DC07227140EDF637F89F123D4EB14FE0D236910F95D66150C8AF3D547A3AE",
      "limit_amount": {
        "currency": "USD",
        "issuer": "rpUNhMWkdc6NmhQKsQoPezoaJU1QLdXqAj",
        "value": "100"
      }
    };

    final transaction = TrustSet.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toBlob(forSigning: false),
        "1200142200020000240000000A201B0082715463D5038D7EA4C6800000000000000000000000000055534400000000000D1799FADFAF3D399D4B1F3E9692088DED9D023C68400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100C91EEC32F7F9C6652527F99DA6C3AC533AD533CE5D26E7CE9DBBDBE890604BB502203C6DC07227140EDF637F89F123D4EB14FE0D236910F95D66150C8AF3D547A3AE811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toBlob(forSigning: false));
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("TrustSet XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "TrustSet",
      "Fee": "10",
      "Sequence": 10,
      "Flags": 131072,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100C91EEC32F7F9C6652527F99DA6C3AC533AD533CE5D26E7CE9DBBDBE890604BB502203C6DC07227140EDF637F89F123D4EB14FE0D236910F95D66150C8AF3D547A3AE",
      "LimitAmount": {
        "currency": "USD",
        "issuer": "rpUNhMWkdc6NmhQKsQoPezoaJU1QLdXqAj",
        "value": "100"
      }
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "1200142200020000240000000A201B0082715463D5038D7EA4C6800000000000000000000000000055534400000000000D1799FADFAF3D399D4B1F3E9692088DED9D023C68400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100C91EEC32F7F9C6652527F99DA6C3AC533AD533CE5D26E7CE9DBBDBE890604BB502203C6DC07227140EDF637F89F123D4EB14FE0D236910F95D66150C8AF3D547A3AE811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
