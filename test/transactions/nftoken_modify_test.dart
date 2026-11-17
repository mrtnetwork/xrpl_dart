import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';
import '../utils.dart';

void nftokenModifyTest() {
  test("NFTokenModify JSON", () {
    final json = {
      "account": "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
      "transaction_type": "NFTokenModify",
      "fee": "10",
      "sequence": 33,
      "last_ledger_sequence": 8548692,
      "owner": "rNCFjv8Ek5oDrNiMJ3pw6eLLFtMjZLJnf2",
      "nftoken_id":
          "0008C350C182B4F213B82CCFA4C6F59AD76F0AFCFBDF04D5A048C0A300000007",
      "uri":
          "697066733A2F2F62616679626569636D6E73347A736F6C686C6976346C746D6E356B697062776373637134616C70736D6C61697970666B73746B736D3472746B652F5665742E706E67",
    };
    final transaction = NFTokenModify.fromJson(json);
    final encoded = transaction.toJson();
    expect(encoded["nftoken_id"], json["nftoken_id"]);
    expect(encoded["owner"], json["owner"]);
    expect(encoded["uri"], json["uri"]);
    expect(NFTokenModify.fromJson(encoded).toJson(), encoded);

    final blob = transaction.toTransactionBlob();
    final fromBlob = SubmittableTransaction.fromBlob(blob);
    expect(fromBlob, isA<NFTokenModify>());
    expect(fromBlob.toTransactionBlob(), blob);
    expect((fromBlob as NFTokenModify).toJson(), encoded);

    final xrpl = transaction.toXrpl();
    expect(xrpl["TransactionType"], "NFTokenModify");
    expect(SubmittableTransaction.fromXrpl(xrpl).toXrpl(), xrpl);

    final wallet = QuickWallet.create(154);
    final signature = wallet.privateKey.sign(
      fromBlob.toSigningBlobBytes(wallet.toAddress),
    );
    fromBlob.setSignature(signature);
    expect(fromBlob.toTransactionBlob(), isNotEmpty);
  });

  test("NFTokenModify without optional fields deletes URI", () {
    final json = {
      "account": "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
      "transaction_type": "NFTokenModify",
      "fee": "10",
      "sequence": 34,
      "nftoken_id":
          "0008C350C182B4F213B82CCFA4C6F59AD76F0AFCFBDF04D5A048C0A300000007",
    };
    final transaction = NFTokenModify.fromJson(json);
    expect(transaction.owner, isNull);
    expect(transaction.uri, isNull);
    final encoded = transaction.toJson();
    expect(NFTokenModify.fromJson(encoded).toJson(), encoded);
    final blob = transaction.toTransactionBlob();
    expect(SubmittableTransaction.fromBlob(blob).toTransactionBlob(), blob);
    expect(transaction.toXrpl()["URI"], isNull);
  });

  test("NFTokenModify validation", () {
    final emptyId = NFTokenModify(
      account: "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
      nfTokenId: "",
    );
    expect(emptyId.validate, isNotNull);
    final longUri = NFTokenModify(
      account: "rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh",
      nfTokenId:
          "0008C350C182B4F213B82CCFA4C6F59AD76F0AFCFBDF04D5A048C0A300000007",
      uri: List.filled(300, "ff").join(),
    );
    expect(longUri.validate, isNotNull);
  });
}

void main() {
  XrplTestApi.runTest(nftokenModifyTest, 'Nftoken Modify');
}
