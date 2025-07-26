import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("AMMVote JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "AMMVote",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "304402201E3F8304E3CD436C920846469A6D65A41371050BB35310E2B52A8E51986C05620220492A459A81E2CEE8B66750E5013ED66F02A1E09BD77DCAB4BE25D61FED6DCFFD",
      "asset": {"currency": "XRP"},
      "asset2": {
        "currency": "USD",
        "issuer": "rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1"
      },
      "trading_fee": 35
    };
    final transaction = AMMVote.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toTransactionBlob(),
        "120026150023240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E7446304402201E3F8304E3CD436C920846469A6D65A41371050BB35310E2B52A8E51986C05620220492A459A81E2CEE8B66750E5013ED66F02A1E09BD77DCAB4BE25D61FED6DCFFD811490FB88B6E10522FAAB709CE7A91120E738BD5CCC03180000000000000000000000000000000000000000041800000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D6735");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("AMMVote XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "AMMVote",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "304402201E3F8304E3CD436C920846469A6D65A41371050BB35310E2B52A8E51986C05620220492A459A81E2CEE8B66750E5013ED66F02A1E09BD77DCAB4BE25D61FED6DCFFD",
      "Asset": {"currency": "XRP"},
      "Asset2": {
        "currency": "USD",
        "issuer": "rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1"
      },
      "TradingFee": 35
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "120026150023240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E7446304402201E3F8304E3CD436C920846469A6D65A41371050BB35310E2B52A8E51986C05620220492A459A81E2CEE8B66750E5013ED66F02A1E09BD77DCAB4BE25D61FED6DCFFD811490FB88B6E10522FAAB709CE7A91120E738BD5CCC03180000000000000000000000000000000000000000041800000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D6735");
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
