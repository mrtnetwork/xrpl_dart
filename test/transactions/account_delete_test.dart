import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

void main() {
  test("Account Delete JSON", () {
    final json = {
      'account': 'rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f',
      'transaction_type': 'AccountDelete',
      'fee': '5000000',
      'sequence': 8543619,
      'last_ledger_sequence': 8544187,
      'signing_pub_key':
          '02D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA',
      'txn_signature':
          '304402206290CF5E1D64B39858BD561F10F0A3E7825AD2229B50C4C49D3E7C27B93652AC02207FDBF0150298E8F4E954649218B58B908E24BA5FA604C99D97B6002AAD2D8B52',
      'destination': 'rMRNfC38abgejshALTCMJL2W9XRzN8SXDn',
      'destination_tag': 3
    };
    final transaction = SubmittableTransaction.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toTransactionBlob(),
        "1200152400825D832E00000003201B00825FBB6840000000004C4B40732102D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA7446304402206290CF5E1D64B39858BD561F10F0A3E7825AD2229B50C4C49D3E7C27B93652AC02207FDBF0150298E8F4E954649218B58B908E24BA5FA604C99D97B6002AAD2D8B52811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8314DFF772492C5C618573B27BE95A0D05FD5C00F5E0");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });
  test("Account Delete XRPL", () {
    final json = {
      'Account': 'rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f',
      'TransactionType': 'AccountDelete',
      'Fee': '5000000',
      'Sequence': 8543619,
      'LastLedgerSequence': 8544238,
      'SigningPubKey':
          '02D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA',
      'TxnSignature':
          '30450221008E1C14A1EBD2D454E22B4AD76977A0AD0B2A118A1F37223016C72099EE89E9CE022049C87ABFA4D721BBFE9F3252E800E68A1DBBFFA2AAE598D8290E9D53506A7755',
      'Destination': 'rMRNfC38abgejshALTCMJL2W9XRzN8SXDn',
      'DestinationTag': 3
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "1200152400825D832E00000003201B00825FEE6840000000004C4B40732102D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA744730450221008E1C14A1EBD2D454E22B4AD76977A0AD0B2A118A1F37223016C72099EE89E9CE022049C87ABFA4D721BBFE9F3252E800E68A1DBBFFA2AAE598D8290E9D53506A7755811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8314DFF772492C5C618573B27BE95A0D05FD5C00F5E0");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });
}
