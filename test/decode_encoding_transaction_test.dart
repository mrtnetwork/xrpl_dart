import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/base/transaction.dart';

void main() {
  test('TEST DECODE ENCODE MULTISIG TRANSACTION', () async {
    const String blob =
        '120000220000000024027244b3201b02735719614000000000989680684000000000000028730081147bfa3a8691c65a6c4139a3a28ed78905c9380b1883143e5577e288c198474bb5475168d814a99b20d51df3e0107321ed5e6ea31bf810bb9f40fdd2b057104eaf3f82d0a04ef521626c1aed13849a681074405336e7ecbba920507febb599dbaaad403ffaa90a3a109957a6505cb35452539727bc562829653d9d27ad2e947734c07cd2d1c60c744e1f51b05fe556252f090581143e5577e288c198474bb5475168d814a99b20d51de1e0107321edfb7c70e528fe161addfda8cb224bc19b9e6455916970f7992a356c3e77ac7ef87440b13468e436ca288c149daad7f7e32bd0e730775b7ce0ed023fd4dfa7d1fef8fc7107ec3928b4bb0191a54b48b32ebc87a73f9dd149b082443f12d35bef762a0f81149d2d88149343a4650954aef4662cd39e534a2db3e1f1';
    final trJson = {
      'account': 'rUJX187xSmNQNh9VjwGsAcuPeLkwvpFfiz',
      'flags': 0,
      'signing_pub_key': '',
      'last_ledger_sequence': 41113369,
      'sequence': 41043123,
      'fee': '40',
      'transaction_type': 'Payment',
      'signers': [
        {
          'signer': {
            'account': 'ragbHLSHyQzWraW46nBiyHuXgVNwCHHoBM',
            'txn_signature':
                '5336e7ecbba920507febb599dbaaad403ffaa90a3a109957a6505cb35452539727bc562829653d9d27ad2e947734c07cd2d1c60c744e1f51b05fe556252f0905',
            'signing_pub_key':
                'ED5E6EA31BF810BB9F40FDD2B057104EAF3F82D0A04EF521626C1AED13849A6810'
          }
        },
        {
          'signer': {
            'account': 'rELnd6Ae5ZYDhHkaqjSVg2vgtBnzjeDshm',
            'txn_signature':
                'b13468e436ca288c149daad7f7e32bd0e730775b7ce0ed023fd4dfa7d1fef8fc7107ec3928b4bb0191a54b48b32ebc87a73f9dd149b082443f12d35bef762a0f',
            'signing_pub_key':
                'EDFB7C70E528FE161ADDFDA8CB224BC19B9E6455916970F7992A356C3E77AC7EF8'
          }
        }
      ],
      'amount': '10000000',
      'destination': 'ragbHLSHyQzWraW46nBiyHuXgVNwCHHoBM'
    };
    final trXrpl = {
      'Account': 'rUJX187xSmNQNh9VjwGsAcuPeLkwvpFfiz',
      'Flags': 0,
      'SigningPubKey': '',
      'LastLedgerSequence': 41113369,
      'Sequence': 41043123,
      'Fee': '40',
      'TransactionType': 'Payment',
      'Signers': [
        {
          'Signer': {
            'Account': 'ragbHLSHyQzWraW46nBiyHuXgVNwCHHoBM',
            'TxnSignature':
                '5336e7ecbba920507febb599dbaaad403ffaa90a3a109957a6505cb35452539727bc562829653d9d27ad2e947734c07cd2d1c60c744e1f51b05fe556252f0905',
            'SigningPubKey':
                'ED5E6EA31BF810BB9F40FDD2B057104EAF3F82D0A04EF521626C1AED13849A6810'
          }
        },
        {
          'Signer': {
            'Account': 'rELnd6Ae5ZYDhHkaqjSVg2vgtBnzjeDshm',
            'TxnSignature':
                'b13468e436ca288c149daad7f7e32bd0e730775b7ce0ed023fd4dfa7d1fef8fc7107ec3928b4bb0191a54b48b32ebc87a73f9dd149b082443f12d35bef762a0f',
            'SigningPubKey':
                'EDFB7C70E528FE161ADDFDA8CB224BC19B9E6455916970F7992A356C3E77AC7EF8'
          }
        }
      ],
      'Amount': '10000000',
      'Destination': 'ragbHLSHyQzWraW46nBiyHuXgVNwCHHoBM'
    };

    expect(XRPTransaction.fromBlob(blob).toBlob(forSigning: false),
        blob.toUpperCase());
    expect(XRPTransaction.fromJson(trJson).toBlob(forSigning: false),
        blob.toUpperCase());
    expect(XRPTransaction.fromXrpl(trXrpl).toBlob(forSigning: false),
        blob.toUpperCase());
  });

  test('TEST DECODE ENCODE PAYMENT TRANSACTION USING PATH', () async {
    const String blob =
        '12000022000000002402727b12201b0273579861d3c38d7ea4c680000000000000000000000000005553440000000000054f6f784a58f9efb0a9eb90b83464f9d166461968400000000000000a7321edcf55885df122e325636455ddebe21172fb8e96e2bfc56e70ad035b3b3218a4c874403a25316b0fbc6948b345e9830afc525d0f87969787fc64321cd0f27920eb2a08e94c5df847aefa23c059ee4af7c42931794ebb9c78e859f1931817259d40fc0b8114c7d3b4c4a7a343765b13b08af6a1310220faca5f8314ca6edc7a28252daea6f2045b24f4d7c333e14617f9ea7c04546578747d2068747470733a2f2f6769746875622e636f6d2f4d6f6873656e486179646172697e0a746578742f706c61696ee1f10112300000000000000000000000005553440000000000054f6f784a58f9efb0a9eb90b83464f9d166461900';
    final trJson = {
      'account': 'rKDbnm11tWgSPgG5wEe4X61iCY2q9RXdB7',
      'flags': 0,
      'signing_pub_key':
          'EDCF55885DF122E325636455DDEBE21172FB8E96E2BFC56E70AD035B3B3218A4C8',
      'last_ledger_sequence': 41113496,
      'sequence': 41057042,
      'txn_signature':
          '3a25316b0fbc6948b345e9830afc525d0f87969787fc64321cd0f27920eb2a08e94c5df847aefa23c059ee4af7c42931794ebb9c78e859f1931817259d40fc0b',
      'fee': '10',
      'transaction_type': 'Payment',
      'memos': [
        {
          'memo': {
            'memo_data':
                '68747470733a2f2f6769746875622e636f6d2f4d6f6873656e48617964617269',
            'memo_format': '746578742f706c61696e',
            'memo_type': '54657874'
          }
        }
      ],
      'amount': {
        'currency': 'USD',
        'issuer': 'rVnYNK9yuxBz4uP8zC8LEFokM2nqH3poc',
        'value': '0.001'
      },
      'destination': 'rKT4JX4cCof6LcDYRz8o3rGRu7qxzZ2Zwj',
      'paths': [
        [
          {
            'currency': 'USD',
            'issuer': 'rVnYNK9yuxBz4uP8zC8LEFokM2nqH3poc',
            'type': 48
          }
        ]
      ]
    };
    final trXrpl = {
      'Account': 'rKDbnm11tWgSPgG5wEe4X61iCY2q9RXdB7',
      'Flags': 0,
      'SigningPubKey':
          'EDCF55885DF122E325636455DDEBE21172FB8E96E2BFC56E70AD035B3B3218A4C8',
      'LastLedgerSequence': 41113496,
      'Sequence': 41057042,
      'TxnSignature':
          '3a25316b0fbc6948b345e9830afc525d0f87969787fc64321cd0f27920eb2a08e94c5df847aefa23c059ee4af7c42931794ebb9c78e859f1931817259d40fc0b',
      'Fee': '10',
      'TransactionType': 'Payment',
      'Memos': [
        {
          'Memo': {
            'MemoData':
                '68747470733a2f2f6769746875622e636f6d2f4d6f6873656e48617964617269',
            'MemoFormat': '746578742f706c61696e',
            'MemoType': '54657874'
          }
        }
      ],
      'Amount': {
        'Currency': 'USD',
        'Issuer': 'rVnYNK9yuxBz4uP8zC8LEFokM2nqH3poc',
        'Value': '0.001'
      },
      'Destination': 'rKT4JX4cCof6LcDYRz8o3rGRu7qxzZ2Zwj',
      'Paths': [
        [
          {
            'Currency': 'USD',
            'Issuer': 'rVnYNK9yuxBz4uP8zC8LEFokM2nqH3poc',
            'Type': 48
          }
        ]
      ]
    };

    expect(XRPTransaction.fromBlob(blob).toBlob(forSigning: false),
        blob.toUpperCase());
    expect(XRPTransaction.fromJson(trJson).toBlob(forSigning: false),
        blob.toUpperCase());
    expect(XRPTransaction.fromXrpl(trXrpl).toBlob(forSigning: false),
        blob.toUpperCase());
  });
}
