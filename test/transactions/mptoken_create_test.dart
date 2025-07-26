import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("MPTokenIssuanceCreate JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "MPTokenIssuanceCreate",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3045022100C91E33D46EC6396ECA36C5EF6EC9EC0E57EE6B5AE435B927B0D730F59D48C56402206AED09869ACAE755B259E2EC84A584C4DF2E5E9B5EF0CF23065ABCD5456BC5DB",
      "asset_scale": 2,
      "maximum_amount": "9223372036854775807"
    };
    final transaction = MPTokenIssuanceCreate.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toTransactionBlob(),
        "120036240000000A201B0082715430187FFFFFFFFFFFFFFF68400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100C91E33D46EC6396ECA36C5EF6EC9EC0E57EE6B5AE435B927B0D730F59D48C56402206AED09869ACAE755B259E2EC84A584C4DF2E5E9B5EF0CF23065ABCD5456BC5DB811490FB88B6E10522FAAB709CE7A91120E738BD5CCC051002");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("MPTokenIssuanceCreate XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "MPTokenIssuanceCreate",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100C91E33D46EC6396ECA36C5EF6EC9EC0E57EE6B5AE435B927B0D730F59D48C56402206AED09869ACAE755B259E2EC84A584C4DF2E5E9B5EF0CF23065ABCD5456BC5DB",
      "AssetScale": 2,
      "MaximumAmount": "9223372036854775807"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "120036240000000A201B0082715430187FFFFFFFFFFFFFFF68400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100C91E33D46EC6396ECA36C5EF6EC9EC0E57EE6B5AE435B927B0D730F59D48C56402206AED09869ACAE755B259E2EC84A584C4DF2E5E9B5EF0CF23065ABCD5456BC5DB811490FB88B6E10522FAAB709CE7A91120E738BD5CCC051002");
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
