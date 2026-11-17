import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import '../utils.dart';

const _credentialId =
    "E7B0D8C4D6A8B5F8F9B0B5C7D8E9F0A1B2C3D4E5F60718293A4B5C6D7E8F90A1";
const _domainId =
    "17060E04AD63975CDE5E4B0C6ACB95ABFA2BA1D569473559448B6E556F261D4A";

void expectJsonRoundTrip(
  BaseTransaction Function(Map<String, dynamic>) fromJson,
  Map<String, dynamic> json,
) {
  final transaction = fromJson(json);
  final encoded = transaction.toJson();
  expect(fromJson(encoded).toJson(), encoded);
  final blob = transaction.toTransactionBlob();
  final fromBlob = SubmittableTransaction.fromBlob(blob);
  expect(fromBlob.toTransactionBlob(), blob);
  expect(
    SubmittableTransaction.fromXrpl(transaction.toXrpl()).toXrpl(),
    transaction.toXrpl(),
  );
}

void recentAmendmentsTest() {
  test("NFTokenMint tfMutable flag", () {
    expect(NFTokenMintFlag.tfMutable.value, 0x00000010);
    expect(NFTokenMintFlag.values.contains(NFTokenMintFlag.tfMutable), isTrue);
    final json = {
      "account": "rvYAfWj5gh67oV6fW32ZzP3Aw4Eubs59B",
      "transaction_type": "NFTokenMint",
      "fee": "10",
      "sequence": 1,
      "flags": 16,
      "nftoken_taxon": 0,
      "uri": "69706673",
    };
    final transaction = NFTokenMint.fromJson(json);
    expect(transaction.toJson()["flags"], 16);
    expectJsonRoundTrip(NFTokenMint.fromJson, json);
  });

  test("TrustSet deep freeze flags", () {
    expect(TrustSetFlag.tfSetDeepFreeze.value, 0x00400000);
    expect(TrustSetFlag.tfClearDeepFreeze.value, 0x00800000);
    expect(TrustSetFlag.values.contains(TrustSetFlag.tfSetDeepFreeze), isTrue);
    expect(
      TrustSetFlag.values.contains(TrustSetFlag.tfClearDeepFreeze),
      isTrue,
    );
    final json = {
      "account": "ra5nK24KXen9AHvsdFTKHSANinZseWnPcX",
      "transaction_type": "TrustSet",
      "fee": "12",
      "sequence": 12,
      "flags": 4194304,
      "limit_amount": {
        "currency": "USD",
        "issuer": "rsP3mgGb2tcYUrxiLFiHJiQXhsziegtwBc",
        "value": "100",
      },
    };
    final transaction = TrustSet.fromJson(json);
    expect(transaction.toJson()["flags"], 4194304);
    expectJsonRoundTrip(TrustSet.fromJson, json);
  });

  test("OfferCreate domain_id and tfHybrid", () {
    expect(OfferCreateFlag.tfHybrid.value, 0x00100000);
    final json = {
      "account": "ra5nK24KXen9AHvsdFTKHSANinZseWnPcX",
      "transaction_type": "OfferCreate",
      "fee": "12",
      "sequence": 8,
      "flags": 1048576,
      "taker_gets": "6000000",
      "taker_pays": {
        "currency": "GKO",
        "issuer": "ruazs5h1qEsqpke88pcqnaseXdm6od2xc",
        "value": "2",
      },
      "domain_id": _domainId,
    };
    final transaction = OfferCreate.fromJson(json);
    expect(transaction.domainID, _domainId);
    expectJsonRoundTrip(OfferCreate.fromJson, json);
    expect(
      (SubmittableTransaction.fromBlob(transaction.toTransactionBlob())
              as OfferCreate)
          .domainID,
      _domainId,
    );
    final flags = OfferCreateFlagInterface(
      tfPassive: false,
      tfImmediateOrCancel: false,
      tfFillOrKill: false,
      tfSell: false,
      tfHybrid: true,
    );
    expect(flags.tfHybrid, isTrue);
  });

  test("Payment credential_ids and domain_id", () {
    final json = {
      "account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
      "transaction_type": "Payment",
      "fee": "12",
      "sequence": 2,
      "amount": "10000",
      "destination": "ra5nK24KXen9AHvsdFTKHSANinZseWnPcX",
      "credential_ids": [_credentialId],
      "domain_id": _domainId,
    };
    final transaction = Payment.fromJson(json);
    expect(transaction.credentialIDs, [_credentialId]);
    expect(transaction.domainID, _domainId);
    expectJsonRoundTrip(Payment.fromJson, json);
    expect(
      (SubmittableTransaction.fromBlob(transaction.toTransactionBlob())
              as Payment)
          .credentialIDs,
      [_credentialId],
    );
    final xrpl = transaction.toXrpl();
    expect(xrpl["CredentialIDs"], [_credentialId]);
    expect(xrpl["DomainID"], _domainId);
  });

  test("EscrowFinish credential_ids", () {
    final json = {
      "account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
      "transaction_type": "EscrowFinish",
      "fee": "10",
      "sequence": 3,
      "owner": "rsA2LpzuawewSBQXkiju3YQTMzW13pAAdW",
      "offer_sequence": 7,
      "credential_ids": [_credentialId],
    };
    expectJsonRoundTrip(EscrowFinish.fromJson, json);
  });

  test("PaymentChannelClaim credential_ids", () {
    final json = {
      "account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
      "transaction_type": "PaymentChannelClaim",
      "fee": "10",
      "sequence": 4,
      "channel": _credentialId,
      "credential_ids": [_credentialId],
    };
    expectJsonRoundTrip(PaymentChannelClaim.fromJson, json);
  });

  test("AccountDelete credential_ids", () {
    final json = {
      "account": "rf1BiGeXwwQoi8Z2ueFYTEXSwuJYfV2Jpn",
      "transaction_type": "AccountDelete",
      "fee": "10",
      "sequence": 5,
      "destination": "ra5nK24KXen9AHvsdFTKHSANinZseWnPcX",
      "credential_ids": [_credentialId],
    };
    expectJsonRoundTrip(AccountDelete.fromJson, json);
  });
}

void main() {
  XrplTestApi.runTest(recentAmendmentsTest, 'Recent Amendments');
}
