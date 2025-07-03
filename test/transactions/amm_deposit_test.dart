import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("AMMDeposit JSON", () {
    final json = {
      'account': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1',
      'transaction_type': 'AMMDeposit',
      'fee': '10',
      'sequence': 8545338,
      'flags': 524288,
      'last_ledger_sequence': 8547382,
      'signing_pub_key':
          '031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E',
      'txn_signature':
          '3044022001092E06F545C23F76092718B19E934978CC0B7778B47ED8416468DF9A258B3002204E9B520126E036EA7BEDD5C88387ADC757B037CE103233CEC15B96A7FCA5D8AE',
      'asset': {'currency': 'XRP'},
      'asset2': {
        'currency': 'USD',
        'issuer': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1'
      },
      'amount': '1000'
    };
    final transaction = SubmittableTransaction.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toBlob(forSigning: false),
        "1200242200080000240082643A201B00826C366140000000000003E868400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74463044022001092E06F545C23F76092718B19E934978CC0B7778B47ED8416468DF9A258B3002204E9B520126E036EA7BEDD5C88387ADC757B037CE103233CEC15B96A7FCA5D8AE81142F128223E9380492BD2E02A1D7A6C259F25D673503180000000000000000000000000000000000000000041800000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D6735");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("AMMDeposit XRPL", () {
    final json = {
      'Account': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1',
      'TransactionType': 'AMMDeposit',
      'Fee': '10',
      'Sequence': 8545338,
      'Flags': 524288,
      'LastLedgerSequence': 8547382,
      'SigningPubKey':
          '031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E',
      'TxnSignature':
          '3044022001092E06F545C23F76092718B19E934978CC0B7778B47ED8416468DF9A258B3002204E9B520126E036EA7BEDD5C88387ADC757B037CE103233CEC15B96A7FCA5D8AE',
      'Asset': {'currency': 'XRP'},
      'Asset2': {
        'currency': 'USD',
        'issuer': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1'
      },
      'Amount': '1000'
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "1200242200080000240082643A201B00826C366140000000000003E868400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74463044022001092E06F545C23F76092718B19E934978CC0B7778B47ED8416468DF9A258B3002204E9B520126E036EA7BEDD5C88387ADC757B037CE103233CEC15B96A7FCA5D8AE81142F128223E9380492BD2E02A1D7A6C259F25D673503180000000000000000000000000000000000000000041800000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D6735");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
  test("AMMDeposit XRPL 2", () {
    final json = {
      'Account': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1',
      'TransactionType': 'AMMDeposit',
      'Fee': '10',
      'Sequence': 8545338,
      'Flags': 65536,
      'LastLedgerSequence': 8548672,
      'SigningPubKey':
          '031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E',
      'TxnSignature':
          '3044022070608EB2673661D4E9BCBE85E910624EAD696C7FE3C1E562CB452CA5A88DA7CB02200EC7E071E5B62F475E08DCCA730E6CDA5FD0C9ADE8907D3F873A47840DF53BBD',
      'Asset': {'currency': 'XRP'},
      'Asset2': {
        'currency': 'USD',
        'issuer': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1'
      },
      'LPTokenOut': {
        'currency': 'USD',
        'issuer': 'rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f',
        'value': '5'
      }
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "1200242200010000240082643A201B0082714068400000000000000A6019D491C37937E08000000000000000000000000000555344000000000090FB88B6E10522FAAB709CE7A91120E738BD5CCC7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74463044022070608EB2673661D4E9BCBE85E910624EAD696C7FE3C1E562CB452CA5A88DA7CB02200EC7E071E5B62F475E08DCCA730E6CDA5FD0C9ADE8907D3F873A47840DF53BBD81142F128223E9380492BD2E02A1D7A6C259F25D673503180000000000000000000000000000000000000000041800000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D6735");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
  test("AMMDeposit XRPL 3", () {
    final json = {
      "Account": "rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1",
      "TransactionType": "AMMDeposit",
      "Fee": "10",
      "Sequence": 10,
      "Flags": 1048576,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3044022052553DDE733466E35425ADC35350012FAC39F23C517E9ECA9700FBA8182AC8B5022067110ACF7A0EAC34A03EDF07396E1B93946BB020ED59545F53F24BC2EDC92A0F",
      "Asset": {"currency": "XRP"},
      "Asset2": {
        "currency": "USD",
        "issuer": "rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1"
      },
      "Amount": "100",
      "Amount2": {
        "currency": "USD",
        "issuer": "rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1",
        "value": "100"
      }
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "1200242200100000240000000A201B0082715461400000000000006468400000000000000A6BD5038D7EA4C6800000000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D67357321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74463044022052553DDE733466E35425ADC35350012FAC39F23C517E9ECA9700FBA8182AC8B5022067110ACF7A0EAC34A03EDF07396E1B93946BB020ED59545F53F24BC2EDC92A0F81142F128223E9380492BD2E02A1D7A6C259F25D673503180000000000000000000000000000000000000000041800000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D6735");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
