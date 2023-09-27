import 'package:xrp_dart/src/xrpl/models/base/base.dart';

/// One Signer in a multi-signature. A multi-signed transaction can have an
/// array of up to 8 Signers, each contributing a signature, in the Signers
/// field.
class XRPLSigners extends XrplNestedModel {
  /// [account] The address of the Signer. This can be a funded account in the XRP Ledger or an unfunded address.
  /// [txnSignature] The signature that this Signer provided for this transaction.
  /// [signingPubKey] The public key that should be used to verify this Signer's signature.
  XRPLSigners(
      {required this.account,
      required this.txnSignature,
      required this.signingPubKey});
  final String account;
  final String txnSignature;
  final String signingPubKey;
  XRPLSigners.fromJson(Map<String, dynamic> json)
      : account = json["signer"]["account"],
        txnSignature = json["signer"]["txn_signature"],
        signingPubKey = json["signer"]["signing_pub_key"];

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      "account": account,
      "txn_signature": txnSignature,
      "signing_pub_key": signingPubKey,
    };
    return {"signer": json};
  }
}
