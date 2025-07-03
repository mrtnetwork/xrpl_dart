import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("AMMWithdraw JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "AMMWithdraw",
      "fee": "10",
      "sequence": 10,
      "flags": 524288,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "30440220616193BABD5D49330D40E933727D4C59455F9E074612AA28CD63174DE9A94616022015A99588E2A95A05DAAE8E2AD9C3B63BCFE7AC1910027990F7F758A0E2E15E79",
      "asset": {"currency": "XRP"},
      "asset2": {
        "currency": "USD",
        "issuer": "rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1"
      },
      "amount": "500"
    };
    final transaction = AMMWithdraw.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toBlob(forSigning: false),
        "1200252200080000240000000A201B008271546140000000000001F468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E744630440220616193BABD5D49330D40E933727D4C59455F9E074612AA28CD63174DE9A94616022015A99588E2A95A05DAAE8E2AD9C3B63BCFE7AC1910027990F7F758A0E2E15E79811490FB88B6E10522FAAB709CE7A91120E738BD5CCC03180000000000000000000000000000000000000000041800000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D6735");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("AMMWithdraw XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "AMMWithdraw",
      "Fee": "10",
      "Sequence": 10,
      "Flags": 524288,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "30440220616193BABD5D49330D40E933727D4C59455F9E074612AA28CD63174DE9A94616022015A99588E2A95A05DAAE8E2AD9C3B63BCFE7AC1910027990F7F758A0E2E15E79",
      "Asset": {"currency": "XRP"},
      "Asset2": {
        "currency": "USD",
        "issuer": "rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1"
      },
      "Amount": "500"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "1200252200080000240000000A201B008271546140000000000001F468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E744630440220616193BABD5D49330D40E933727D4C59455F9E074612AA28CD63174DE9A94616022015A99588E2A95A05DAAE8E2AD9C3B63BCFE7AC1910027990F7F758A0E2E15E79811490FB88B6E10522FAAB709CE7A91120E738BD5CCC03180000000000000000000000000000000000000000041800000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D6735");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
  test("AMMWithdraw XRPL 2", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "AMMWithdraw",
      "Fee": "10",
      "Sequence": 10,
      "Flags": 1048576,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "304402203C7E1D0B73BD32405705DA40D8639328ADF7E5FEFEDFA48566CFFDA979C305CF0220345224752F68AF1CC2BCD34FFEDF8D2469A334D1455810C4313ABC9345B4ACDC",
      "Asset": {"currency": "XRP"},
      "Asset2": {
        "currency": "USD",
        "issuer": "rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1"
      },
      "Amount": "50",
      "Amount2": {
        "currency": "USD",
        "issuer": "rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1",
        "value": "50"
      }
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "1200252200100000240000000A201B0082715461400000000000003268400000000000000A6BD4D1C37937E0800000000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D67357321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E7446304402203C7E1D0B73BD32405705DA40D8639328ADF7E5FEFEDFA48566CFFDA979C305CF0220345224752F68AF1CC2BCD34FFEDF8D2469A334D1455810C4313ABC9345B4ACDC811490FB88B6E10522FAAB709CE7A91120E738BD5CCC03180000000000000000000000000000000000000000041800000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D6735");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
