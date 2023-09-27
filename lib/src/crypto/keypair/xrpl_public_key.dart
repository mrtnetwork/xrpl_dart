import 'dart:typed_data';

import 'package:xrp_dart/src/crypto/crypto.dart';
import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/xrpl/address/xrpl.dart';
import 'package:xrp_dart/src/xrpl/address_utilities.dart';
import 'ec_encryption.dart' as ec;
import 'ed_curve.dart' as xrpl;

class XRPPublicKey {
  final CryptoAlgorithm algorithm;

  XRPPublicKey._(this._publicKey, this.algorithm);

  /// Creates an XRPPublicKey from a Uint8List of bytes.
  factory XRPPublicKey.fromBytes(Uint8List bytes) {
    if (bytes.length != 33) {
      throw ArgumentError(
          "Invalid public key length. Public key must be 32 bytes long for `SECP256K1` or 33 bytes long for ED25519 algorithm.");
    }
    if (bytes[0] == CryptoAlgorithm.ED25519.value) {
      return XRPPublicKey._(bytes.sublist(1), CryptoAlgorithm.ED25519);
    }
    if (!ec.isPoint(bytes)) {
      throw ArgumentError(
          "Invalid ${CryptoAlgorithm.SECP256K1.name} public key.");
    }
    return XRPPublicKey._(bytes, CryptoAlgorithm.SECP256K1);
  }

  /// Creates an XRPPublicKey from a hexadecimal string.
  factory XRPPublicKey.fromHex(String public) {
    String pub = strip0x(public);
    return XRPPublicKey.fromBytes(hexToBytes(pub));
  }

  final Uint8List _publicKey;

  /// Converts the XRPPublicKey to an XRPAddress.
  XRPAddress toAddress() {
    return XRPAddress.fromBytes(hexToBytes(toHex()));
  }

  /// Returns the hexadecimal representation of the XRPPublicKey.
  String toHex() {
    String toString = bytesToHex(_publicKey);
    switch (algorithm) {
      case CryptoAlgorithm.ED25519:
        return "ED$toString".toUpperCase();
      default:
        return toString.toUpperCase();
    }
  }

  /// Verifies an ECDSA signature for a given message.
  bool _verifyECBlob(String message, String signature) {
    final decodeDer = ec.decodeDerSignature(hexToBytes(signature));
    final msg = hash512Half(hexToBytes(message));
    return ec.verify(msg, _publicKey, decodeDer);
  }

  /// Verify the transaction signature blob.
  /// It is used when you sign the blob with Transaction.blob(forsigning = true), otherwise, it will return false.
  bool verifyBlob(String blob, String signature) {
    switch (algorithm) {
      case CryptoAlgorithm.ED25519:
        return xrpl.verifyEDBlob(blob, signature, _publicKey);
      default:
        return _verifyECBlob(blob, signature);
    }
  }
}
