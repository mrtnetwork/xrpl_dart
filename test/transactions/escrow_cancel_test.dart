import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("EscrowCancel JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "EscrowCancel",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3045022100FA3AEED0E7C4587F391AEBF0E87DA46D62867DCDFB142D452809D8B5AC8E4B740220142FB032BCD777A5B51A07CA40CDF7D38E83B34B7EE147CA014C27B8B044EEAA",
      "owner": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
      "offer_sequence": 7
    };
    final transaction = EscrowCancel.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toTransactionBlob(),
        "120004240000000A201900000007201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100FA3AEED0E7C4587F391AEBF0E87DA46D62867DCDFB142D452809D8B5AC8E4B740220142FB032BCD777A5B51A07CA40CDF7D38E83B34B7EE147CA014C27B8B044EEAA811490FB88B6E10522FAAB709CE7A91120E738BD5CCC82144B4E9C06F24296074F7BC48F92A97916C6DC5EA9");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("EscrowCancel XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "EscrowCancel",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100FA3AEED0E7C4587F391AEBF0E87DA46D62867DCDFB142D452809D8B5AC8E4B740220142FB032BCD777A5B51A07CA40CDF7D38E83B34B7EE147CA014C27B8B044EEAA",
      "Owner": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
      "OfferSequence": 7
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "120004240000000A201900000007201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100FA3AEED0E7C4587F391AEBF0E87DA46D62867DCDFB142D452809D8B5AC8E4B740220142FB032BCD777A5B51A07CA40CDF7D38E83B34B7EE147CA014C27B8B044EEAA811490FB88B6E10522FAAB709CE7A91120E738BD5CCC82144B4E9C06F24296074F7BC48F92A97916C6DC5EA9");
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
