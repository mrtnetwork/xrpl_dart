import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

void main() {
  test("Batch JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "Batch",
      "fee": "10",
      "sequence": 10,
      "flags": 65536,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3045022100B6A35BE59F2E2914170A224E52D20AC783830FE001608EDF44F7FFC30C3ADAA402207A5A3E30505B9885FF83FEEEA807A37C8A648684CD58D1F9B60408F4398C8D29",
      "raw_transactions": [
        {
          "raw_transaction": {
            "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
            "transaction_type": "Payment",
            "fee": "0",
            "sequence": 11,
            "flags": 1073741824,
            "signing_pub_key": "",
            "amount": "1",
            "destination": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn"
          }
        },
        {
          "raw_transaction": {
            "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
            "transaction_type": "Payment",
            "fee": "0",
            "sequence": 12,
            "flags": 1073741824,
            "signing_pub_key": "",
            "amount": "1",
            "destination": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn"
          }
        }
      ]
    };
    final transaction = Batch.fromJson(json);
    expect(transaction.toJson(), json);

    expect(transaction.toTransactionBlob(),
        "1200472200010000240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100B6A35BE59F2E2914170A224E52D20AC783830FE001608EDF44F7FFC30C3ADAA402207A5A3E30505B9885FF83FEEEA807A37C8A648684CD58D1F9B60408F4398C8D29811490FB88B6E10522FAAB709CE7A91120E738BD5CCCF01EE0221200002240000000240000000B6140000000000000016840000000000000007300811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8314DFF772492C5C618573B27BE95A0D05FD5C00F5E0E1E0221200002240000000240000000C6140000000000000016840000000000000007300811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8314DFF772492C5C618573B27BE95A0D05FD5C00F5E0E1F1");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });
  // return;
  test("XChainModifyBridge XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "Batch",
      "Fee": "10",
      "Sequence": 10,
      "Flags": 65536,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100B6A35BE59F2E2914170A224E52D20AC783830FE001608EDF44F7FFC30C3ADAA402207A5A3E30505B9885FF83FEEEA807A37C8A648684CD58D1F9B60408F4398C8D29",
      "RawTransactions": [
        {
          "RawTransaction": {
            "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
            "TransactionType": "Payment",
            "Fee": "0",
            "Sequence": 11,
            "Flags": 1073741824,
            "SigningPubKey": "",
            "Amount": "1",
            "Destination": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn"
          }
        },
        {
          "RawTransaction": {
            "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
            "TransactionType": "Payment",
            "Fee": "0",
            "Sequence": 12,
            "Flags": 1073741824,
            "SigningPubKey": "",
            "Amount": "1",
            "Destination": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn"
          }
        }
      ]
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "1200472200010000240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100B6A35BE59F2E2914170A224E52D20AC783830FE001608EDF44F7FFC30C3ADAA402207A5A3E30505B9885FF83FEEEA807A37C8A648684CD58D1F9B60408F4398C8D29811490FB88B6E10522FAAB709CE7A91120E738BD5CCCF01EE0221200002240000000240000000B6140000000000000016840000000000000007300811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8314DFF772492C5C618573B27BE95A0D05FD5C00F5E0E1E0221200002240000000240000000C6140000000000000016840000000000000007300811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8314DFF772492C5C618573B27BE95A0D05FD5C00F5E0E1F1");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });
}
