import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'utils.dart';

void main() {
  test("PaymentChannelClaim JSON", () {
    final json = {
      "account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "transaction_type": "PaymentChannelClaim",
      "fee": "10",
      "sequence": 10,
      "last_ledger_sequence": 8548692,
      "signing_pub_key":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "txn_signature":
          "3044022066EB031D33D3182D05016DD79436AE4A0451A8011F8742207BEDF1313F96794102203716D898D80E54C8D9D137594095ABE85FB5A63CD304D34D1F0BA92B575E1ED7",
      "channel":
          "57C945850FAFAF1482FA1C0A1D838E6F64EFAC6237683FA79A892CC2FFC156FD"
    };
    final transaction = PaymentChannelClaim.fromJson(json);
    expect(transaction.toJson(), json);
    expect(transaction.toBlob(forSigning: false),
        "12000F240000000A201B00827154501657C945850FAFAF1482FA1C0A1D838E6F64EFAC6237683FA79A892CC2FFC156FD68400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74463044022066EB031D33D3182D05016DD79436AE4A0451A8011F8742207BEDF1313F96794102203716D898D80E54C8D9D137594095ABE85FB5A63CD304D34D1F0BA92B575E1ED7811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");

    final fromBlob =
        SubmittableTransaction.fromBlob(transaction.toBlob(forSigning: false));
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });

  test("PaymentChannelClaim XRPL", () {
    final json = {
      "Account": "rNDbdW1FJ4F3rS7XgLzPHH1GWizYZ3cv1f",
      "TransactionType": "PaymentChannelClaim",
      "Fee": "10",
      "Sequence": 10,
      "LastLedgerSequence": 8548692,
      "SigningPubKey":
          "031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E",
      "TxnSignature":
          "3044022066EB031D33D3182D05016DD79436AE4A0451A8011F8742207BEDF1313F96794102203716D898D80E54C8D9D137594095ABE85FB5A63CD304D34D1F0BA92B575E1ED7",
      "Channel":
          "57C945850FAFAF1482FA1C0A1D838E6F64EFAC6237683FA79A892CC2FFC156FD"
    };
    final transaction = SubmittableTransaction.fromXrpl(json);
    expect(transaction.toXrpl(), json);
    expect(transaction.toBlob(forSigning: false),
        "12000F240000000A201B00827154501657C945850FAFAF1482FA1C0A1D838E6F64EFAC6237683FA79A892CC2FFC156FD68400000000000000A7321031B9797537DC10B29738C43FBDB743D10354A0057B3327338E6EAE6A47BF6791E74463044022066EB031D33D3182D05016DD79436AE4A0451A8011F8742207BEDF1313F96794102203716D898D80E54C8D9D137594095ABE85FB5A63CD304D34D1F0BA92B575E1ED7811490FB88B6E10522FAAB709CE7A91120E738BD5CCC");
    final fromBlob = SubmittableTransaction.fromBlob(transaction.toBlob());
    expect(fromBlob.toBlob(), transaction.toBlob());
    final wallet = QuickWallet.create(154);

    final signature = wallet.privateKey.sign(fromBlob.toBlob());
    fromBlob.setSignature(signature);
    expect(fromBlob.toBlob(), transaction.toBlob());
  });
}
