import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("AMMCreate JSON", () {
    final json = {
      'account': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1',
      'transaction_type': 'AMMCreate',
      'fee': '200000',
      'sequence': 8545338,
      'last_ledger_sequence': 8547204,
      'signing_pub_key':
          '031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E',
      'txn_signature':
          '304402206967004A30F07082F7B5E6C4FDFD88C777264CD7AE433A8C3B31A18498DA377D022025399E1B4C91EC9411936B6C235BBFC958D9569889E6254794CE66F49F56C8BB',
      'amount': '250',
      'amount2': {
        'currency': 'USD',
        'issuer': 'rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f',
        'value': '250'
      },
      'trading_fee': 12
    };
    final transaction = SubmittableTransaction.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toBlob(forSigning: false),
        "12002315000C240082643A201B00826B846140000000000000FA684000000000030D406BD508E1BC9BF04000000000000000000000000000555344000000000090FB88B6E10522FAAB709CE7A91120E738BD5CCC7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E7446304402206967004A30F07082F7B5E6C4FDFD88C777264CD7AE433A8C3B31A18498DA377D022025399E1B4C91EC9411936B6C235BBFC958D9569889E6254794CE66F49F56C8BB81142F128223E9380492BD2E02A1D7A6C259F25D6735");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("AMMCreate XRPL", () {
    final json = {
      'Account': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1',
      'TransactionType': 'AMMCreate',
      'Fee': '200000',
      'Sequence': 8545338,
      'LastLedgerSequence': 8547204,
      'SigningPubKey':
          '031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E',
      'TxnSignature':
          '304402206967004A30F07082F7B5E6C4FDFD88C777264CD7AE433A8C3B31A18498DA377D022025399E1B4C91EC9411936B6C235BBFC958D9569889E6254794CE66F49F56C8BB',
      'Amount': '250',
      'Amount2': {
        'currency': 'USD',
        'issuer': 'rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f',
        'value': '250'
      },
      'TradingFee': 12
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "12002315000C240082643A201B00826B846140000000000000FA684000000000030D406BD508E1BC9BF04000000000000000000000000000555344000000000090FB88B6E10522FAAB709CE7A91120E738BD5CCC7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E7446304402206967004A30F07082F7B5E6C4FDFD88C777264CD7AE433A8C3B31A18498DA377D022025399E1B4C91EC9411936B6C235BBFC958D9569889E6254794CE66F49F56C8BB81142F128223E9380492BD2E02A1D7A6C259F25D6735");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
