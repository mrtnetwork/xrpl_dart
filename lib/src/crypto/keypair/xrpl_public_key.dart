import 'package:xrp_dart/src/crypto/crypto.dart';
import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/xrpl/address/xrpl.dart';
import 'package:xrp_dart/src/xrpl/address_utilities.dart';
import 'package:flutter/foundation.dart';
import 'ec_encryption.dart' as ec;
import 'ed_curve.dart';

class XRPPublicKey {
  final CryptoAlgorithm algorithm;

  XRPPublicKey._(this._publicKey, this.algorithm);
  factory XRPPublicKey.fromBytes(Uint8List bytes) {
    if (bytes.length != 33) {
      throw ArgumentError(
          "wrong public key. public key must 32 bytes length for `SECP256K1` or 33 bytes length for ED25519 algorithm");
    }
    if (bytes[0] == CryptoAlgorithm.ED25519.value) {
      return XRPPublicKey._(bytes.sublist(1), CryptoAlgorithm.ED25519);
    }
    if (!ec.isPoint(bytes)) {
      throw ArgumentError("wrong ${CryptoAlgorithm.SECP256K1.name} public key");
    }
    return XRPPublicKey._(bytes, CryptoAlgorithm.SECP256K1);
  }
  factory XRPPublicKey.fromHex(String public) {
    String pub = strip0x(public);
    return XRPPublicKey.fromBytes(hexToBytes(pub));
  }
  final Uint8List _publicKey;
  XRPAddress toAddress() {
    return XRPAddress.fromBytes(hexToBytes(toHex()));
  }

  String toHex() {
    String toString = bytesToHex(_publicKey);
    switch (algorithm) {
      case CryptoAlgorithm.ED25519:
        return "ED$toString".toUpperCase();
      default:
        return toString.toUpperCase();
    }
  }

  bool _verifyEDBlob(String messageHex, String signatureHex) {
    final message = hexToBytes(messageHex);
    final signature = hexToBytes(signatureHex);
    final decodePublic = EDPoint.decodePoint(_publicKey);
    int len = signature.length;
    if (len.isOdd) {
      return false;
    }
    len = len >> 1;
    final eR = liteEddianToBigInt(signature.sublist(0, len));
    final S = liteEddianToBigInt(signature.sublist(len));
    final eRB = bigIntToLittleEndianBytes(eR, 32);
    final R = EDPoint.decodePoint(eRB);
    final eA = decodePublic.encodePoint();
    final combine = hash512(Uint8List.fromList([...eRB, ...eA, ...message]));
    BigInt h = liteEddianToBigInt(combine);
    h = h % EDCurve.order;
    final A = decodePublic * h;
    final left = A + R;
    final right = EDCurve.generator * S;
    return right == left;
  }

  bool _verifyECBlob(String message, String signature) {
    final decodeDer = ec.decodeDerSignatur(hexToBytes(signature));
    final msg = hash512(hexToBytes(message)).sublist(0, 32);
    return ec.verify(msg, _publicKey, decodeDer);
  }

  /// Verify the transaction signature blob.
  /// It is used when you sign the blob with Transaction.blob(forsigning = true), otherwise, it will return false.
  bool verifyBlob(String blob, String signature) {
    switch (algorithm) {
      case CryptoAlgorithm.ED25519:
        return _verifyEDBlob(blob, signature);
      default:
        return _verifyECBlob(blob, signature);
    }
  }
}
