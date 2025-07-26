import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("EscrowCreate JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "EscrowCreate",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "source_tag": 11747,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3045022100F95AB30EAA189C9D0FC98221C783D38A120CCF46F4CBE8452B16297D4919699002202C81FBD76331C66E607E48C981C8722A264CF6E03E914A0631964258B8AE8A57",
      "amount": "10000",
      "destination": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn",
      "destination_tag": 23480,
      "cancel_after": 1751385486,
      "finish_after": 1751385485
    };
    final transaction = EscrowCreate.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toTransactionBlob(),
        "1200012300002DE3240000000A2E00005BB8201B0082715420246864058E20256864058D61400000000000271068400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100F95AB30EAA189C9D0FC98221C783D38A120CCF46F4CBE8452B16297D4919699002202C81FBD76331C66E607E48C981C8722A264CF6E03E914A0631964258B8AE8A57811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8314DFF772492C5C618573B27BE95A0D05FD5C00F5E0");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("EscrowCreate XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "EscrowCreate",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SourceTag": 11747,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100F95AB30EAA189C9D0FC98221C783D38A120CCF46F4CBE8452B16297D4919699002202C81FBD76331C66E607E48C981C8722A264CF6E03E914A0631964258B8AE8A57",
      "Amount": "10000",
      "Destination": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn",
      "DestinationTag": 23480,
      "CancelAfter": 1751385486,
      "FinishAfter": 1751385485
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "1200012300002DE3240000000A2E00005BB8201B0082715420246864058E20256864058D61400000000000271068400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100F95AB30EAA189C9D0FC98221C783D38A120CCF46F4CBE8452B16297D4919699002202C81FBD76331C66E607E48C981C8722A264CF6E03E914A0631964258B8AE8A57811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8314DFF772492C5C618573B27BE95A0D05FD5C00F5E0");
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
