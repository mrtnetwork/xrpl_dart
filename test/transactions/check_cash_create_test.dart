import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("CheckCreate JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "CheckCreate",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3045022100D1E185CDBC161710ECC01D0F8638A3418C0B403FE84F81E1F029A00294CED1C60220691462FF884FB60E85740C814CE1C7C7C817BF8474DB8C4B4995909A850F1373",
      "destination": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn",
      "send_max": "100000000",
      "destination_tag": 1,
      "expiration": 970113521,
      "invoice_id":
          "6F1DFD1D0FE8A32E40E1F2C05CF1C15545BAB56B617F9C6C2D63A6B704BEF59B"
    };
    final transaction = CheckCreate.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toBlob(forSigning: false),
        "120010240000000A2A39D2C1F12E00000001201B0082715450116F1DFD1D0FE8A32E40E1F2C05CF1C15545BAB56B617F9C6C2D63A6B704BEF59B68400000000000000A694000000005F5E1007321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100D1E185CDBC161710ECC01D0F8638A3418C0B403FE84F81E1F029A00294CED1C60220691462FF884FB60E85740C814CE1C7C7C817BF8474DB8C4B4995909A850F1373811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8314DFF772492C5C618573B27BE95A0D05FD5C00F5E0");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("CheckCreate XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "CheckCreate",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3045022100D1E185CDBC161710ECC01D0F8638A3418C0B403FE84F81E1F029A00294CED1C60220691462FF884FB60E85740C814CE1C7C7C817BF8474DB8C4B4995909A850F1373",
      "Destination": "rMRNfC38abgejshALTCMJL2W9XRzN8SXDn",
      "SendMax": "100000000",
      "DestinationTag": 1,
      "Expiration": 970113521,
      "InvoiceID":
          "6F1DFD1D0FE8A32E40E1F2C05CF1C15545BAB56B617F9C6C2D63A6B704BEF59B"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "120010240000000A2A39D2C1F12E00000001201B0082715450116F1DFD1D0FE8A32E40E1F2C05CF1C15545BAB56B617F9C6C2D63A6B704BEF59B68400000000000000A694000000005F5E1007321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74473045022100D1E185CDBC161710ECC01D0F8638A3418C0B403FE84F81E1F029A00294CED1C60220691462FF884FB60E85740C814CE1C7C7C817BF8474DB8C4B4995909A850F1373811490FB88B6E10522FAAB709CE7A91120E738BD5CCC8314DFF772492C5C618573B27BE95A0D05FD5C00F5E0");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
