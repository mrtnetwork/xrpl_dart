import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("Payment JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "Payment",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3045022100F3E7FB5A7F2A1F175212A29DCC52E6C5B99CB04693A7A30204C03C91D68834BA022003DCC91DD838F7B29667A850AABF5285DF64F96F9904B509A3E4C7B7B60355C3",
      "amount": "1",
      "destination": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn"
    };
    final transaction = Payment.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toTransactionBlob(),
        "120000240000000A201B0082715461400000000000000168400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100F3E7FB5A7F2A1F175212A29DCC52E6C5B99CB04693A7A30204C03C91D68834BA022003DCC91DD838F7B29667A850AABF5285DF64F96F9904B509A3E4C7B7B60355C3811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8314DFF772492C5C618573B27BE95A0D05FD5C00F5E0");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("Payment XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "Payment",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100F3E7FB5A7F2A1F175212A29DCC52E6C5B99CB04693A7A30204C03C91D68834BA022003DCC91DD838F7B29667A850AABF5285DF64F96F9904B509A3E4C7B7B60355C3",
      "Amount": "1",
      "Destination": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "120000240000000A201B0082715461400000000000000168400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100F3E7FB5A7F2A1F175212A29DCC52E6C5B99CB04693A7A30204C03C91D68834BA022003DCC91DD838F7B29667A850AABF5285DF64F96F9904B509A3E4C7B7B60355C3811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8314DFF772492C5C618573B27BE95A0D05FD5C00F5E0");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });
  test("Payment XRPL 2", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "Payment",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "30450221009D070DB87F8B0CD503BFB5808EE343F068C1C9EEE95D72E8A5E68ABCD1B550160220331FA49D8865EEA03E414F291253893D0FD2EBD32C80EAA985135F0CBCA7F7AC",
      "Amount": {
        "mpt_issuance_id": "fec874578aafa5acfea899950730bdc5bd5eb31bcf5ebf2a",
        "value": "10"
      },
      "Destination": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "120000240000000A201B008271546160000000000000000AFEC874578AAFA5ACFEA899950730BDC5BD5EB31BCF5EBF2A68400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E744730450221009D070DB87F8B0CD503BFB5808EE343F068C1C9EEE95D72E8A5E68ABCD1B550160220331FA49D8865EEA03E414F291253893D0FD2EBD32C80EAA985135F0CBCA7F7AC811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8314DFF772492C5C618573B27BE95A0D05FD5C00F5E0");
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
