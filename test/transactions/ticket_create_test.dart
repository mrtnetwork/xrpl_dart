import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("TicketCreate JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "TicketCreate",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "304402205B035DFE9A126BE16774D697AB40F30503282646861BF7452E9D57A368BA2A4C0220032E7C5F20C6E1C496BDC0BD687533A5D2D22FF165755CF4892E8A9D2B61022F",
      "ticket_count": 2
    };

    final transaction = TicketCreate.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toBlob(forSigning: false),
        "12000A240000000A201B0082715420280000000268400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E7446304402205B035DFE9A126BE16774D697AB40F30503282646861BF7452E9D57A368BA2A4C0220032E7C5F20C6E1C496BDC0BD687533A5D2D22FF165755CF4892E8A9D2B61022F811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toBlob(forSigning: false));
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("TicketCreate XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "TicketCreate",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "304402205B035DFE9A126BE16774D697AB40F30503282646861BF7452E9D57A368BA2A4C0220032E7C5F20C6E1C496BDC0BD687533A5D2D22FF165755CF4892E8A9D2B61022F",
      "TicketCount": 2
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "12000A240000000A201B0082715420280000000268400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E7446304402205B035DFE9A126BE16774D697AB40F30503282646861BF7452E9D57A368BA2A4C0220032E7C5F20C6E1C496BDC0BD687533A5D2D22FF165755CF4892E8A9D2B61022F811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
