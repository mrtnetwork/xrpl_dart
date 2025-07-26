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
          "3045022100B0EE7F8F02934FEB5C6C4C6EC56C488F6D7DFD955670675DF0913C958EF54B2B02203EF34499CE9A8C3BB872CF17C98B60289822A2D4C70B1C7E166B3D393080AD88",
      "subject": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn",
      "credential_type": "4964656e74697479446f63756d656e74"
    };
    final transaction = CredentialCreate.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toTransactionBlob(),
        "12003A240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100B0EE7F8F02934FEB5C6C4C6EC56C488F6D7DFD955670675DF0913C958EF54B2B02203EF34499CE9A8C3BB872CF17C98B60289822A2D4C70B1C7E166B3D393080AD88701F104964656E74697479446F63756D656E74811490FB88B6E10522FAAB709CE7A91120E738BD5CCC801814DFF772492C5C618573B27BE95A0D05FD5C00F5E0");

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
          "3045022100B0EE7F8F02934FEB5C6C4C6EC56C488F6D7DFD955670675DF0913C958EF54B2B02203EF34499CE9A8C3BB872CF17C98B60289822A2D4C70B1C7E166B3D393080AD88",
      "Subject": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn",
      "CredentialType": "4964656e74697479446f63756d656e74"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "12003A240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100B0EE7F8F02934FEB5C6C4C6EC56C488F6D7DFD955670675DF0913C958EF54B2B02203EF34499CE9A8C3BB872CF17C98B60289822A2D4C70B1C7E166B3D393080AD88701F104964656E74697479446F63756D656E74811490FB88B6E10522FAAB709CE7A91120E738BD5CCC801814DFF772492C5C618573B27BE95A0D05FD5C00F5E0");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("CredentialAccept XRPL", () {
    final json = {
      "Account": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn",
      "TransactionType": "CredentialAccept",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100C436A180618EB146798896321CF923E05A04DB38DB57D539379A903E8C48FED002206AFEAB5AEB98B95E28FC034BE29ED90DDF9FEB930ECFEC6EA8A4B3429817E8A9",
      "Issuer": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "CredentialType": "4964656e74697479446f63756d656e74"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "12003B240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100C436A180618EB146798896321CF923E05A04DB38DB57D539379A903E8C48FED002206AFEAB5AEB98B95E28FC034BE29ED90DDF9FEB930ECFEC6EA8A4B3429817E8A9701F104964656E74697479446F63756D656E748114DFF772492C5C618573B27BE95A0D05FD5C00F5E0841490FB88B6E10522FAAB709CE7A91120E738BD5CCC");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });
  test("PermissionedDomainSet XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "PermissionedDomainSet",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100FCE8EF1D9E8252D7D224457B9CCCFC92006A1B725CD7DF9248A4D94F50BD982602205EEE854A03B6D017E1DE872D2D994C8C7C89833470A741A35FE535A223E95170",
      "AcceptedCredentials": [
        {
          "Credential": {
            "Issuer": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
            "CredentialType": "4964656e74697479446f63756d656e74"
          }
        }
      ]
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "12003E240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100FCE8EF1D9E8252D7D224457B9CCCFC92006A1B725CD7DF9248A4D94F50BD982602205EEE854A03B6D017E1DE872D2D994C8C7C89833470A741A35FE535A223E95170811490FB88B6E10522FAAB709CE7A91120E738BD5CCCF01CE021701F104964656E74697479446F63756D656E74841490FB88B6E10522FAAB709CE7A91120E738BD5CCCE1F1");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("PermissionedDomainDelete XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "PermissionedDomainDelete",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3044022071BC669CCA875919F3BB1C8B96081293B4F9E0AA7FD064665A1720B88F3C7EA70220652A83CF882EEBA0C6C1EC90689BDC089E62229F4832C5B89A02FA42E2E38FCF",
      "DomainID":
          "F53D3578746DBB1A8ACA6A65A5FA81F1E658C89101298A7CA43B519199BFF6B1"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "12003F240000000A201B008271545022F53D3578746DBB1A8ACA6A65A5FA81F1E658C89101298A7CA43B519199BFF6B168400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74463044022071BC669CCA875919F3BB1C8B96081293B4F9E0AA7FD064665A1720B88F3C7EA70220652A83CF882EEBA0C6C1EC90689BDC089E62229F4832C5B89A02FA42E2E38FCF811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");
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
