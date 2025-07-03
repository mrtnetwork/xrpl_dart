import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("MPTokenIssuanceDestroy JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "MPTokenIssuanceDestroy",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3045022100914DCF59882BC993C0AB8BD82EDFE5B2985730E72E391FC99697189E8D435F0802204805B0131A5F0BAAE4AAF51CC9138949BC7CFEC3EC44A648F9C995070F457D01",
      "mptoken_issuance_id": "fec874578aafa5acfea899950730bdc5bd5eb31bcf5ebf2a"
    };
    final transaction = MPTokenIssuanceDestroy.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toBlob(forSigning: false),
        "120037240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100914DCF59882BC993C0AB8BD82EDFE5B2985730E72E391FC99697189E8D435F0802204805B0131A5F0BAAE4AAF51CC9138949BC7CFEC3EC44A648F9C995070F457D01811490FB88B6E10522FAAB709CE7A91120E738BD5CCC0115FEC874578AAFA5ACFEA899950730BDC5BD5EB31BCF5EBF2A");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toBlob(forSigning: false));
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("MPTokenIssuanceDestroy XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "MPTokenIssuanceDestroy",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100914DCF59882BC993C0AB8BD82EDFE5B2985730E72E391FC99697189E8D435F0802204805B0131A5F0BAAE4AAF51CC9138949BC7CFEC3EC44A648F9C995070F457D01",
      "MPTokenIssuanceID": "fec874578aafa5acfea899950730bdc5bd5eb31bcf5ebf2a"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "120037240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100914DCF59882BC993C0AB8BD82EDFE5B2985730E72E391FC99697189E8D435F0802204805B0131A5F0BAAE4AAF51CC9138949BC7CFEC3EC44A648F9C995070F457D01811490FB88B6E10522FAAB709CE7A91120E738BD5CCC0115FEC874578AAFA5ACFEA899950730BDC5BD5EB31BCF5EBF2A");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
