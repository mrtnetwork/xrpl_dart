import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("OracleDelete JSON", () {
    final json = {
      "account": "rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1",
      "transaction_type": "OracleDelete",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3045022100E026D05E496BFCA4DF8F4E4FADFD4845840A368D808F8A2CF97DAB07D1ADD2F4022051EF76BD2A803DA2C0339CA3339CF9129B6706BE5CDE82004590E53A6FDBC69D",
      "oracle_document_id": 32121
    };
    final transaction = OracleDelete.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toBlob(forSigning: false),
        "120034240000000A201B00827154203300007D7968400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100E026D05E496BFCA4DF8F4E4FADFD4845840A368D808F8A2CF97DAB07D1ADD2F4022051EF76BD2A803DA2C0339CA3339CF9129B6706BE5CDE82004590E53A6FDBC69D81142F128223E9380492BD2E02A1D7A6C259F25D6735");

    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("OracleDelete XRPL", () {
    final json = {
      "Account": "rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1",
      "TransactionType": "OracleDelete",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100E026D05E496BFCA4DF8F4E4FADFD4845840A368D808F8A2CF97DAB07D1ADD2F4022051EF76BD2A803DA2C0339CA3339CF9129B6706BE5CDE82004590E53A6FDBC69D",
      "OracleDocumentID": 32121
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "120034240000000A201B00827154203300007D7968400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100E026D05E496BFCA4DF8F4E4FADFD4845840A368D808F8A2CF97DAB07D1ADD2F4022051EF76BD2A803DA2C0339CA3339CF9129B6706BE5CDE82004590E53A6FDBC69D81142F128223E9380492BD2E02A1D7A6C259F25D6735");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
