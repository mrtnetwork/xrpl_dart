import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("EscrowFinish JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "EscrowFinish",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3045022100B25E2CBCC63EA025301D51217F9B1F84645CF631C87EAF3B1ED8455798F44AB702200527045F02CC8CF905EEFB17E61C4800F2FD34EB2E761354682983F21C45C962",
      "owner": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
      "offer_sequence": 7,
      "condition":
          "A0258020E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855810100",
      "fulfillment": "A0028000"
    };
    final transaction = EscrowFinish.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toTransactionBlob(),
        "120002240000000A201900000007201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100B25E2CBCC63EA025301D51217F9B1F84645CF631C87EAF3B1ED8455798F44AB702200527045F02CC8CF905EEFB17E61C4800F2FD34EB2E761354682983F21C45C962701004A0028000701127A0258020E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855810100811490FB88B6E10522FAAB709CE7A91120E738BD5CCC82144B4E9C06F24296074F7BC48F92A97916C6DC5EA9");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("EscrowFinish XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "EscrowFinish",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100B25E2CBCC63EA025301D51217F9B1F84645CF631C87EAF3B1ED8455798F44AB702200527045F02CC8CF905EEFB17E61C4800F2FD34EB2E761354682983F21C45C962",
      "Owner": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
      "OfferSequence": 7,
      "Condition":
          "A0258020E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855810100",
      "Fulfillment": "A0028000"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "120002240000000A201900000007201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100B25E2CBCC63EA025301D51217F9B1F84645CF631C87EAF3B1ED8455798F44AB702200527045F02CC8CF905EEFB17E61C4800F2FD34EB2E761354682983F21C45C962701004A0028000701127A0258020E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855810100811490FB88B6E10522FAAB709CE7A91120E738BD5CCC82144B4E9C06F24296074F7BC48F92A97916C6DC5EA9");
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
