import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("OracleDelete JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "DepositPreauth",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3044022074A770B6E4738877FBD6E6E1FDFE0CB504246F068032A76A2090783C9B97F921022048FE5A3EFE68F966DADAFEF785FEAFB8DBE26E931C66A2C98BDDC6F0DB63219B",
      "unauthorize": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn"
    };
    final transaction = DepositPreauth.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toTransactionBlob(),
        "120013240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74463044022074A770B6E4738877FBD6E6E1FDFE0CB504246F068032A76A2090783C9B97F921022048FE5A3EFE68F966DADAFEF785FEAFB8DBE26E931C66A2C98BDDC6F0DB63219B811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8614DFF772492C5C618573B27BE95A0D05FD5C00F5E0");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("OracleDelete XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "DepositPreauth",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3044022074A770B6E4738877FBD6E6E1FDFE0CB504246F068032A76A2090783C9B97F921022048FE5A3EFE68F966DADAFEF785FEAFB8DBE26E931C66A2C98BDDC6F0DB63219B",
      "Unauthorize": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "120013240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74463044022074A770B6E4738877FBD6E6E1FDFE0CB504246F068032A76A2090783C9B97F921022048FE5A3EFE68F966DADAFEF785FEAFB8DBE26E931C66A2C98BDDC6F0DB63219B811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8614DFF772492C5C618573B27BE95A0D05FD5C00F5E0");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });
  test("OracleDelete XRPL 2", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "DepositPreauth",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100CAD62C87BE58544C108C43A14F51C93D7E5FFC2875F396713E94EF29A61FC339022057332544BE80842A54E73663E79839DC3724DD0279AD7B858D375893E76A6FE8",
      "Authorize": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "120013240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100CAD62C87BE58544C108C43A14F51C93D7E5FFC2875F396713E94EF29A61FC339022057332544BE80842A54E73663E79839DC3724DD0279AD7B858D375893E76A6FE8811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8514DFF772492C5C618573B27BE95A0D05FD5C00F5E0");
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
