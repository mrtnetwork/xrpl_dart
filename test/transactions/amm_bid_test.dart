import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("AMMBid JSON", () {
    final json = {
      'account': 'rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f',
      'transaction_type': 'AMMBid',
      'fee': '10',
      'sequence': 8543622,
      'last_ledger_sequence': 8545457,
      'signing_pub_key':
          '02D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA',
      'txn_signature':
          '3045022100C6AE0CDF90C22E40063E10045EB79E9CF6ED5C8A2DF6163A1C1065E2AE1AB4BD022032C90283C6D8F60ED362AFCCE21238337F85108C6D0ADC945829C6EFC7D27D4B',
      'asset': {'currency': 'XRP'},
      'asset2': {
        'currency': 'USD',
        'issuer': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1'
      }
    };
    final transaction = SubmittableTransaction.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toBlob(forSigning: false),
        "1200272400825D86201B008264B168400000000000000A732102D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA74473045022100C6AE0CDF90C22E40063E10045EB79E9CF6ED5C8A2DF6163A1C1065E2AE1AB4BD022032C90283C6D8F60ED362AFCCE21238337F85108C6D0ADC945829C6EFC7D27D4B811490FB88B6E10522FAAB709CE7A91120E738BD5CCC03180000000000000000000000000000000000000000041800000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D6735");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(150);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("AMMBid XRPL", () {
    final json = {
      'Account': 'rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f',
      'TransactionType': 'AMMBid',
      'Fee': '10',
      'Sequence': 8543622,
      'LastLedgerSequence': 8545457,
      'SigningPubKey':
          '02D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA',
      'TxnSignature':
          '3045022100C6AE0CDF90C22E40063E10045EB79E9CF6ED5C8A2DF6163A1C1065E2AE1AB4BD022032C90283C6D8F60ED362AFCCE21238337F85108C6D0ADC945829C6EFC7D27D4B',
      'Asset': {'currency': 'XRP'},
      'Asset2': {
        'currency': 'USD',
        'issuer': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1'
      }
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "1200272400825D86201B008264B168400000000000000A732102D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA74473045022100C6AE0CDF90C22E40063E10045EB79E9CF6ED5C8A2DF6163A1C1065E2AE1AB4BD022032C90283C6D8F60ED362AFCCE21238337F85108C6D0ADC945829C6EFC7D27D4B811490FB88B6E10522FAAB709CE7A91120E738BD5CCC03180000000000000000000000000000000000000000041800000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D6735");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());

    final wallet = QuickWallet.create(150);
    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("AMMBid JSON 2", () {
    final json = {
      'account': 'rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f',
      'transaction_type': 'AMMBid',
      'fee': '10',
      'sequence': 8543622,
      'last_ledger_sequence': 8546778,
      'signing_pub_key':
          '02D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA',
      'txn_signature':
          '3044022025438D68E0C90B70C0C5C72CF55B71D32A8E2C2CC9F8A1DA3CBEBC85C3D2DB3A02203F24F91899F81133C4F9029A1AF8B2CCC1B8BEAC172A5968DF210EB1B31F190F',
      'asset': {'currency': 'XRP'},
      'asset2': {
        'currency': 'USD',
        'issuer': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1'
      },
      'bid_min': {
        'currency': 'USD',
        'issuer': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1',
        'value': '5'
      },
      'bid_max': {
        'currency': 'USD',
        'issuer': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1',
        'value': '10'
      },
      'auth_accounts': [
        {
          'auth_account': {'account': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1'}
        }
      ]
    };
    final transaction = SubmittableTransaction.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toBlob(forSigning: false),
        "1200272400825D86201B008269DA68400000000000000A6CD491C37937E0800000000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D67356DD4C38D7EA4C6800000000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D6735732102D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA74463044022025438D68E0C90B70C0C5C72CF55B71D32A8E2C2CC9F8A1DA3CBEBC85C3D2DB3A02203F24F91899F81133C4F9029A1AF8B2CCC1B8BEAC172A5968DF210EB1B31F190F811490FB88B6E10522FAAB709CE7A91120E738BD5CCCF019E01B81142F128223E9380492BD2E02A1D7A6C259F25D6735E1F103180000000000000000000000000000000000000000041800000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D6735");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(150);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("AMMBid XRPL 2", () {
    final json = {
      'Account': 'rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f',
      'TransactionType': 'AMMBid',
      'Fee': '10',
      'Sequence': 8543622,
      'LastLedgerSequence': 8546778,
      'SigningPubKey':
          '02D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA',
      'TxnSignature':
          '3044022025438D68E0C90B70C0C5C72CF55B71D32A8E2C2CC9F8A1DA3CBEBC85C3D2DB3A02203F24F91899F81133C4F9029A1AF8B2CCC1B8BEAC172A5968DF210EB1B31F190F',
      'Asset': {'currency': 'XRP'},
      'Asset2': {
        'currency': 'USD',
        'issuer': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1'
      },
      'BidMin': {
        'currency': 'USD',
        'issuer': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1',
        'value': '5'
      },
      'BidMax': {
        'currency': 'USD',
        'issuer': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1',
        'value': '10'
      },
      'AuthAccounts': [
        {
          'AuthAccount': {'Account': 'rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1'}
        }
      ]
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "1200272400825D86201B008269DA68400000000000000A6CD491C37937E0800000000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D67356DD4C38D7EA4C6800000000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D6735732102D91E5CD171E62D52C83EB33471A55E48AF980225DB6C55E3FE48A46A10C706EA74463044022025438D68E0C90B70C0C5C72CF55B71D32A8E2C2CC9F8A1DA3CBEBC85C3D2DB3A02203F24F91899F81133C4F9029A1AF8B2CCC1B8BEAC172A5968DF210EB1B31F190F811490FB88B6E10522FAAB709CE7A91120E738BD5CCCF019E01B81142F128223E9380492BD2E02A1D7A6C259F25D6735E1F103180000000000000000000000000000000000000000041800000000000000000000000055534400000000002F128223E9380492BD2E02A1D7A6C259F25D6735");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());

    final wallet = QuickWallet.create(150);
    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
