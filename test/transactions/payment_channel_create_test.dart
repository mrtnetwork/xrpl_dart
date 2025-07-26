import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("PaymentChannelCreate JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "PaymentChannelCreate",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3045022100B7D20A45276C933C34446BDD3E801F99F544B5FF51AD517B45916DB8640CEC6702202C21F6F744CDD5D85146C6C891688E4CAF11F83CDB5E03FFFB12F99690D23A77",
      "amount": "1",
      "destination": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn",
      "settle_delay": 86400,
      "public_key":
          "02D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA"
    };
    final transaction = PaymentChannelCreate.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toTransactionBlob(),
        "12000D240000000A201B0082715420270001518061400000000000000168400000000000000A712102D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100B7D20A45276C933C34446BDD3E801F99F544B5FF51AD517B45916DB8640CEC6702202C21F6F744CDD5D85146C6C891688E4CAF11F83CDB5E03FFFB12F99690D23A77811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8314DFF772492C5C618573B27BE95A0D05FD5C00F5E0");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("PaymentChannelCreate XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "PaymentChannelCreate",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100B7D20A45276C933C34446BDD3E801F99F544B5FF51AD517B45916DB8640CEC6702202C21F6F744CDD5D85146C6C891688E4CAF11F83CDB5E03FFFB12F99690D23A77",
      "Amount": "1",
      "Destination": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn",
      "SettleDelay": 86400,
      "PublicKey":
          "02D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "12000D240000000A201B0082715420270001518061400000000000000168400000000000000A712102D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100B7D20A45276C933C34446BDD3E801F99F544B5FF51AD517B45916DB8640CEC6702202C21F6F744CDD5D85146C6C891688E4CAF11F83CDB5E03FFFB12F99690D23A77811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8314DFF772492C5C618573B27BE95A0D05FD5C00F5E0");
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
