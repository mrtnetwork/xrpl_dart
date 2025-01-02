import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// One Signer in a multi-signature. A multi-signed transaction can have an
/// array of up to 8 Signers, each contributing a signature, in the Signers
/// field.
class XRPLSigners extends XRPLBase {
  XRPLSigners(
      {required this.account,
      required this.txnSignature,
      required this.signingPubKey});
  XRPLSigners.singer({required this.account, required this.signingPubKey})
      : txnSignature = '';

  /// [account] The address of the Signer. This can be a funded account in the XRP Ledger or an unfunded address.
  final String account;

  /// [txnSignature] The signature that this Signer provided for this transaction.
  final String? txnSignature;

  /// [signingPubKey] The public key that should be used to verify this Signer's signature.
  final String signingPubKey;
  XRPLSigners.fromJson(Map<String, dynamic> json)
      : account = json['signer']['account'],
        txnSignature = json['signer']['txn_signature'],
        signingPubKey = json['signer']['signing_pub_key'];

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'signer': {
        'account': account,
        'txn_signature': txnSignature,
        'signing_pub_key': signingPubKey,
      }
    };
  }

  bool get isReady => txnSignature != null;
}
