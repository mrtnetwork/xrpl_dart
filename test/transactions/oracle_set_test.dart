import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("OracleSet JSON", () {
    final json = {
      "account": "rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1",
      "transaction_type": "OracleSet",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3045022100900DB20CBAD910AE9197A0C4ED29BA97CDD98A966D3D0C1D928FCE3C832C491702206BC3A7034189CE40BAA99B0D6A1DEBA1E161E47C5981305BE766CB0E42DBA16A",
      "oracle_document_id": 3123,
      "provider": "636861696e6c696e6b",
      "asset_class": "63757272656e6379",
      "last_update_time": 1751377811,
      "price_data_series": [
        {
          "price_data": {
            "base_asset": "XRP",
            "quote_asset": "USD",
            "asset_price": '740',
            "scale": 1
          }
        },
        {
          "price_data": {
            "base_asset": "BTC",
            "quote_asset": "EUR",
            "asset_price": '100',
            "scale": 2
          }
        }
      ]
    };
    final transaction = OracleSet.fromJson(json);

    expect(transaction.toJson(), json);
    expect(transaction.toBlob(forSigning: false),
        "120033240000000A2F6863E793201B00827154203300000C3368400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100900DB20CBAD910AE9197A0C4ED29BA97CDD98A966D3D0C1D928FCE3C832C491702206BC3A7034189CE40BAA99B0D6A1DEBA1E161E47C5981305BE766CB0E42DBA16A701C0863757272656E6379701D09636861696E6C696E6B81142F128223E9380492BD2E02A1D7A6C259F25D6735F018E020301700000000000002E4041001011A0000000000000000000000000000000000000000021A0000000000000000000000005553440000000000E1E02030170000000000000064041002011A0000000000000000000000004254430000000000021A0000000000000000000000004555520000000000E1F1");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("OracleSet XRPL", () {
    final json = {
      "Account": "rnHtvzyB7tHRJJisyDtTte77dE3Ts6NuN1",
      "TransactionType": "OracleSet",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100900DB20CBAD910AE9197A0C4ED29BA97CDD98A966D3D0C1D928FCE3C832C491702206BC3A7034189CE40BAA99B0D6A1DEBA1E161E47C5981305BE766CB0E42DBA16A",
      "OracleDocumentID": 3123,
      "Provider": "636861696e6c696e6b",
      "AssetClass": "63757272656e6379",
      "LastUpdateTime": 1751377811,
      "PriceDataSeries": [
        {
          "PriceData": {
            "BaseAsset": "XRP",
            "QuoteAsset": "USD",
            "AssetPrice": '740',
            "Scale": 1
          }
        },
        {
          "PriceData": {
            "BaseAsset": "BTC",
            "QuoteAsset": "EUR",
            "AssetPrice": '100',
            "Scale": 2
          }
        }
      ]
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "120033240000000A2F6863E793201B00827154203300000C3368400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100900DB20CBAD910AE9197A0C4ED29BA97CDD98A966D3D0C1D928FCE3C832C491702206BC3A7034189CE40BAA99B0D6A1DEBA1E161E47C5981305BE766CB0E42DBA16A701C0863757272656E6379701D09636861696E6C696E6B81142F128223E9380492BD2E02A1D7A6C259F25D6735F018E020301700000000000002E4041001011A0000000000000000000000000000000000000000021A0000000000000000000000005553440000000000E1E02030170000000000000064041002011A0000000000000000000000004254430000000000021A0000000000000000000000004555520000000000E1F1");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("OracleSet XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "OracleSet",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100AC5B27F267FFE060B3E520A39021F2498BFD235C307C9BF387ABFE9FBDC73E7802207AC7723EFAF6D6ABF17EB37AB0FCDFE29B2AE8332609A882130D1A8495B277AD",
      "OracleDocumentID": 33122,
      "Provider": "70726f7669646572",
      "AssetClass": "63757272656e6379",
      "LastUpdateTime": 1751393031,
      "PriceDataSeries": [
        {
          "PriceData": {
            "BaseAsset": "XRP",
            "QuoteAsset": "USD",
            "AssetPrice": '740',
            "Scale": 1
          }
        },
        {
          "PriceData": {
            "BaseAsset": "BTC",
            "QuoteAsset": "EUR",
            "AssetPrice": '100',
            "Scale": 2
          }
        },
        {
          "PriceData": {
            "BaseAsset": "BTC",
            "QuoteAsset": "INR",
            "AssetPrice": '18446744073709551615',
            "Scale": 2
          }
        }
      ]
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);

    expect(transaction.toBlob(forSigning: false),
        "120033240000000A2F68642307201B0082715420330000816268400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100AC5B27F267FFE060B3E520A39021F2498BFD235C307C9BF387ABFE9FBDC73E7802207AC7723EFAF6D6ABF17EB37AB0FCDFE29B2AE8332609A882130D1A8495B277AD701C0863757272656E6379701D0870726F7669646572811490FB88B6E10522FAAB709CE7A91120E738BD5CCCF018E020301700000000000002E4041001011A0000000000000000000000000000000000000000021A0000000000000000000000005553440000000000E1E02030170000000000000064041002011A0000000000000000000000004254430000000000021A0000000000000000000000004555520000000000E1E0203017FFFFFFFFFFFFFFFF041002011A0000000000000000000000004254430000000000021A000000000000000000000000494E520000000000E1F1");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
