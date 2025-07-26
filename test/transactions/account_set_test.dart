import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("Account Set JSON", () {
    final json = {
      'account': 'rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f',
      'transaction_type': 'AccountSet',
      'fee': '10',
      'sequence': 8543619,
      'last_ledger_sequence': 8544368,
      'signing_pub_key':
          '02D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA',
      'txn_signature':
          '304402205C43007F05ECBD7C3325CDE932AF884CA4ACD9C2860D686728953755ED01ACA3022006798E8E9042356DA1757B433F9A86E7A2C65038431A91DD6557C63861E39061',
      'set_flag': 8
    };
    final transaction = SubmittableTransaction.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toTransactionBlob(),
        "1200032400825D83201B0082607020210000000868400000000000000A732102D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA7446304402205C43007F05ECBD7C3325CDE932AF884CA4ACD9C2860D686728953755ED01ACA3022006798E8E9042356DA1757B433F9A86E7A2C65038431A91DD6557C63861E39061811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(150);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });
  test("Account Set XRPL", () {
    final json = {
      'Account': 'rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f',
      'TransactionType': 'AccountSet',
      'Fee': '10',
      'Sequence': 8543619,
      'LastLedgerSequence': 8544440,
      'SigningPubKey':
          '02D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA',
      'TxnSignature':
          '304402202FD44495C1D523CB83A0B4A67F63762309BAC5CE7A2846B3C8BC3A61D65F2DE50220785C70D884B2B6FD2F1C1D5AE61EB835C828E9DA57CD37F36801B702BFBCC8B2',
      'ClearFlag': 3,
      'Domain': '6578616d706c652e636f6d',
      'EmailHash': '10000000002000000000300000000012',
      'MessageKey':
          '03AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB',
      'TransferRate': 0,
      'TickSize': 10
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "1200032400825D832B00000000201B008260B8202200000003411000000000200000000030000000001268400000000000000A722103AB40A0490F9B7ED8DF29D246BF2D6269820A0EE7742ACDD457BEA7C7D0931EDB732102D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA7446304402202FD44495C1D523CB83A0B4A67F63762309BAC5CE7A2846B3C8BC3A61D65F2DE50220785C70D884B2B6FD2F1C1D5AE61EB835C828E9DA57CD37F36801B702BFBCC8B2770B6578616D706C652E636F6D811490FB88B6E10522FAAB709CE7A91120E738BD5CCC0010100A");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());

    final wallet = QuickWallet.create(150);
    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });
}
