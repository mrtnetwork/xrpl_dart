import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("AMMClawback JSON", () {
    final json = {
      'account': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1',
      'transaction_type': 'AMMClawback',
      'fee': '10',
      'sequence': 8545338,
      'last_ledger_sequence': 8546888,
      'signing_pub_key':
          '031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E',
      'txn_signature':
          '3045022100CCD6CAE4D85B19E96AA7FFC20AF70D62633E3B7FD0732998D68F09F0AEA2F86F0220217575AB4C20D19515BF7A1206B95800D61118A14B89F88A2B5ACBBD56D7FDAD',
      'holder': 'rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f',
      'asset': {
        'currency': 'USD',
        'issuer': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1'
      },
      'asset2': {'currency': 'XRP'}
    };
    final transaction = SubmittableTransaction.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toBlob(forSigning: false),
        "12001F240082643A201B00826A4868400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100CCD6CAE4D85B19E96AA7FFC20AF70D62633E3B7FD0732998D68F09F0AEA2F86F0220217575AB4C20D19515BF7A1206B95800D61118A14B89F88A2B5ACBBD56D7FDAD81142F128223E9380492BD2E02A1D7A6C259F25D67358B1490FB88B6E10522FAAB709CE7A91120E738BD5CCC031800000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D673504180000000000000000000000000000000000000000");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("AMMClawback XRPL", () {
    final json = {
      'Account': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1',
      'TransactionType': 'AMMClawback',
      'Fee': '10',
      'Sequence': 8545338,
      'LastLedgerSequence': 8546888,
      'SigningPubKey':
          '031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E',
      'TxnSignature':
          '3045022100CCD6CAE4D85B19E96AA7FFC20AF70D62633E3B7FD0732998D68F09F0AEA2F86F0220217575AB4C20D19515BF7A1206B95800D61118A14B89F88A2B5ACBBD56D7FDAD',
      'Holder': 'rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f',
      'Asset': {
        'currency': 'USD',
        'issuer': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1'
      },
      'Asset2': {'currency': 'XRP'}
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "12001F240082643A201B00826A4868400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100CCD6CAE4D85B19E96AA7FFC20AF70D62633E3B7FD0732998D68F09F0AEA2F86F0220217575AB4C20D19515BF7A1206B95800D61118A14B89F88A2B5ACBBD56D7FDAD81142F128223E9380492BD2E02A1D7A6C259F25D67358B1490FB88B6E10522FAAB709CE7A91120E738BD5CCC031800000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D673504180000000000000000000000000000000000000000");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
