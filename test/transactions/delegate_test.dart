import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("DelegateSet JSON", () {
    final json = {
      "account": "rUGMV6yM7o1cZnBRdJT9yKPgfsMuKG7HxJ",
      "transaction_type": "DelegateSet",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "304502210094018852DC7ACC3D5F7E2C710FC9F7016B721DE035D6EF3A44E447496031BD9602203A9A96E688BDF73E4BF79BD4A289D8CB218CBDA939D809322E54695064492AAE",
      "authorize": "r3Mu9XsqmQVKAgv6h9d3qgFYpkhirJji1x",
      "permissions": [
        {
          "permission": {"permission_value": "Payment"}
        },
        {
          "permission": {"permission_value": "AccountDomainSet"}
        }
      ]
    };
    final transaction = DelegateSet.fromJson(json);
    // print(transaction.permissions.length);
    // return;
    expect(transaction.toJson(), json);
    expect(transaction.toTransactionBlob(),
        "120040240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E7447304502210094018852DC7ACC3D5F7E2C710FC9F7016B721DE035D6EF3A44E447496031BD9602203A9A96E688BDF73E4BF79BD4A289D8CB218CBDA939D809322E54695064492AAE81147B90BB3A7B4F593A9EE92161F43A7E14D35DD68C851450BCBACFB36B6EFDE9A6F81747E5D42C6DDBF57EF01DEF203400000001E1EF203400010004E1F1");
    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toTransactionBlob());
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
    final wallet = QuickWallet.create(154);

    final signature =
        wallet.privateKey.sign(fromBlob.toSigningBlobBytes(wallet.toAddress));
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), transaction.toTransactionBlob());
  });

  test("DelegateSet XRPL", () {
    final json = {
      "Account": "rUGMV6yM7o1cZnBRdJT9yKPgfsMuKG7HxJ",
      "TransactionType": "DelegateSet",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "304502210094018852DC7ACC3D5F7E2C710FC9F7016B721DE035D6EF3A44E447496031BD9602203A9A96E688BDF73E4BF79BD4A289D8CB218CBDA939D809322E54695064492AAE",
      "Authorize": "r3Mu9XsqmQVKAgv6h9d3qgFYpkhirJji1x",
      "Permissions": [
        {
          "Permission": {"PermissionValue": "Payment"}
        },
        {
          "Permission": {"PermissionValue": "AccountDomainSet"}
        }
      ]
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toTransactionBlob(),
        "120040240000000A201B0082715468400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E7447304502210094018852DC7ACC3D5F7E2C710FC9F7016B721DE035D6EF3A44E447496031BD9602203A9A96E688BDF73E4BF79BD4A289D8CB218CBDA939D809322E54695064492AAE81147B90BB3A7B4F593A9EE92161F43A7E14D35DD68C851450BCBACFB36B6EFDE9A6F81747E5D42C6DDBF57EF01DEF203400000001E1EF203400010004E1F1");
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
