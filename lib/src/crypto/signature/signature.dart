class XRPLSignature {
  XRPLSignature._({required this.signature, required this.signingPubKey});
  factory XRPLSignature.signer(String signingPubKey) {
    return XRPLSignature._(signature: null, signingPubKey: signingPubKey);
  }
  factory XRPLSignature.sign(String signingPubKey, String txnSignature) {
    return XRPLSignature._(
        signature: txnSignature.isEmpty ? null : txnSignature,
        signingPubKey: signingPubKey);
  }
  static XRPLSignature? fromJson(Map<String, dynamic> json) {
    final String? signingPubKey = json['signing_pub_key'];
    final String txnSignature = json['txn_signature'] ?? '';
    if (signingPubKey?.isEmpty ?? true) {
      return null;
    }
    return XRPLSignature._(
        signature: (txnSignature.isEmpty ? null : txnSignature),
        signingPubKey: signingPubKey!);
  }

  /// [signature] The signature that this Signer provided for this transaction.
  final String? signature;

  /// [signingPubKey] The public key that should be used to verify this Signer's signature.
  final String signingPubKey;

  bool get isReady => signature != null;
}
