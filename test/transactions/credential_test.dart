import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("CredentialCreate JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "CredentialCreate",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "304402205EE051A3ED020146D78E4358318AFD46E2CC27D4B03FA2313399D18CB8C98723022075B521E2797950C7AF1D2EBEA99F6DD8809E2DE0FB44CB8E6F62DBC78D394257",
      "subject": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn",
      "credential_type": "50617373706f72745f6a61666172",
      "uri": "7777772e6d792d69642e636f6d2f757365726e616d65"
    };
    final transaction = CredentialCreate.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toTransactionBlob(),
        "12003A240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E7446304402205EE051A3ED020146D78E4358318AFD46E2CC27D4B03FA2313399D18CB8C98723022075B521E2797950C7AF1D2EBEA99F6DD8809E2DE0FB44CB8E6F62DBC78D39425775167777772E6D792D69642E636F6D2F757365726E616D65701F0E50617373706F72745F6A61666172811490FB88B6E10522FAAB709CE7A91120E738BD5CCC801814DFF772492C5C618573B27BE95A0D05FD5C00F5E0");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("CredentialCreate XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "CredentialCreate",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "304402205EE051A3ED020146D78E4358318AFD46E2CC27D4B03FA2313399D18CB8C98723022075B521E2797950C7AF1D2EBEA99F6DD8809E2DE0FB44CB8E6F62DBC78D394257",
      "Subject": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn",
      "CredentialType": "50617373706f72745f6a61666172",
      "URI": "7777772e6d792d69642e636f6d2f757365726e616d65"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "12003A240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E7446304402205EE051A3ED020146D78E4358318AFD46E2CC27D4B03FA2313399D18CB8C98723022075B521E2797950C7AF1D2EBEA99F6DD8809E2DE0FB44CB8E6F62DBC78D39425775167777772E6D792D69642E636F6D2F757365726E616D65701F0E50617373706F72745F6A61666172811490FB88B6E10522FAAB709CE7A91120E738BD5CCC801814DFF772492C5C618573B27BE95A0D05FD5C00F5E0");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });
}
