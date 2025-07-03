import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  // print(BytesUtils.toHexString(QuickCrypto.generateRandom(48 ~/ 2)));
  // return;
  test("MPTokenAuthorize JSON", () {
    final json = {
      "account": "rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1",
      "transaction_type": "MPTokenAuthorize",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "30450221009E980A00A6D4D3D954BB1D642105D8128C1F17C3794EB9B53B3ED5ACD72E7FD9022022B4DD3E3F0CE34B01B81CFDA16CD8FA85BBE7AC6DDBDC6482908D29A929472D",
      "mptoken_issuance_id": "fec874578aafa5acfea899950730bdc5bd5eb31bcf5ebf2a"
    };
    final transaction = MPTokenAuthorize.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toBlob(forSigning: false),
        "120039240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E744730450221009E980A00A6D4D3D954BB1D642105D8128C1F17C3794EB9B53B3ED5ACD72E7FD9022022B4DD3E3F0CE34B01B81CFDA16CD8FA85BBE7AC6DDBDC6482908D29A929472D81142F128223E9380492BD2E02A1D7A6C259F25D67350115FEC874578AAFA5ACFEA899950730BDC5BD5EB31BCF5EBF2A");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toBlob(forSigning: false));
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("MPTokenAuthorize XRPL", () {
    final json = {
      "Account": "rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1",
      "TransactionType": "MPTokenAuthorize",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "30450221009E980A00A6D4D3D954BB1D642105D8128C1F17C3794EB9B53B3ED5ACD72E7FD9022022B4DD3E3F0CE34B01B81CFDA16CD8FA85BBE7AC6DDBDC6482908D29A929472D",
      "MPTokenIssuanceID": "fec874578aafa5acfea899950730bdc5bd5eb31bcf5ebf2a"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "120039240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E744730450221009E980A00A6D4D3D954BB1D642105D8128C1F17C3794EB9B53B3ED5ACD72E7FD9022022B4DD3E3F0CE34B01B81CFDA16CD8FA85BBE7AC6DDBDC6482908D29A929472D81142F128223E9380492BD2E02A1D7A6C259F25D67350115FEC874578AAFA5ACFEA899950730BDC5BD5EB31BCF5EBF2A");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
