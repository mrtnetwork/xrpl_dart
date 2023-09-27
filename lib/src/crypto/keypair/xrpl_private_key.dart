import 'dart:typed_data';

import 'package:xrp_dart/src/crypto/crypto.dart';
import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/xrpl/address_utilities.dart';
import 'ed_curve.dart' as xrpl;
import 'xrpl_public_key.dart';
import 'ec_encryption.dart' as ec;

class XRPPrivateKey {
  XRPPrivateKey._(this._privateKey, this._publicKey, this.algorithm);

  /// Factory constructor for generating a random XRP private key.
  /// [algorithm] specifies the cryptographic algorithm, with ED25519 being the default.
  factory XRPPrivateKey.random(
      {CryptoAlgorithm algorithm = CryptoAlgorithm.ED25519}) {
    /// Generate 16 random bytes as entropy
    final rand = generateRandom(16);

    /// Create an XRP private key from the generated entropy
    return XRPPrivateKey.fromEntropy(bytesToHex(rand), algorithm: algorithm);
  }

  /// Factory constructor for creating an XRP private key from entropy.
  ///
  /// [entropy] is the entropy for generating the private key.
  /// [algorithm] specifies the cryptographic algorithm, with ED25519 being the default.
  factory XRPPrivateKey.fromEntropy(String entropy,
      {CryptoAlgorithm algorithm = CryptoAlgorithm.ED25519}) {
    /// Encode the seed using XRPAddressUtilities
    XRPAddressUtilities.encodeSeed(hexToBytes(entropy), algorithm);

    switch (algorithm) {
      case CryptoAlgorithm.ED25519:

        /// For ED25519, derive the private key and corresponding public key
        final privateKey = hash512Half(hexToBytes(entropy));
        final public = xrpl.getMaterial(privateKey);
        return XRPPrivateKey._(privateKey, public.$1, algorithm);
      default:

        /// For other algorithms, derive the private key and corresponding public key
        final privateKey = ec.deriveKeyPair(entropy);
        final public = ec.pointFromScalar(privateKey, true);
        return XRPPrivateKey._(privateKey, public!, algorithm);
    }
  }

  /// Factory constructor for creating an XRP private key from a seed.
  ///
  /// [seed] is the seed value for generating the private key.
  factory XRPPrivateKey.fromSeed(String seed) {
    /// Decode the seed to retrieve entropy and algorithm
    final entropy = XRPAddressUtilities.decodeSeed(seed);

    /// Create an XRPPrivateKey from the entropy and specified algorithm
    return XRPPrivateKey.fromEntropy(bytesToHex(entropy.$1),
        algorithm: entropy.$2);
  }

  /// Factory constructor for creating an XRP private key from a hexadecimal representation.
  ///
  /// [privateKey] is the hexadecimal private key to be used for XRP transactions.
  factory XRPPrivateKey.fromHex(String privateKey) {
    if (privateKey.length != 66) {
      throw ArgumentError(
          "Invalid privateKey, private key must be 66 characters");
    }
    Uint8List bytes = hexToBytes(privateKey);

    if (bytes[0] == CryptoAlgorithm.ED25519.value) {
      /// Remove the algorithm prefix (1 byte)
      bytes = bytes.sublist(1);

      /// Derive the public key material
      final public = xrpl.getMaterial(bytes);

      /// Create and return the XRPPrivateKey instance
      return XRPPrivateKey._(bytes, public.$1, CryptoAlgorithm.ED25519);
    } else if (bytes[0] != CryptoAlgorithm.SECP256K1.value) {
      throw ArgumentError("Invalid prefix");
    }

    /// Remove the algorithm prefix (1 byte)
    bytes = bytes.sublist(1);

    if (!ec.isPrivate(bytes)) {
      throw ArgumentError("Invalid SECP256K1 private key");
    }

    /// Derive the corresponding public key
    final public = ec.pointFromScalar(bytes, true);

    /// Create and return the XRPPrivateKey instance
    return XRPPrivateKey._(bytes, public!, CryptoAlgorithm.SECP256K1);
  }

  /// Factory constructor for creating an XRP private key from a byte representation.
  ///
  /// [privateKey] is the byte representation of the private key.
  /// [algorithm] is the cryptographic algorithm used for the private key.
  factory XRPPrivateKey.fromBytes(
      Uint8List privateKey, CryptoAlgorithm algorithm) {
    if (privateKey.length != 32) {
      throw ArgumentError(
          "Invalid privateKey, private key must be 32 bytes in length");
    }

    switch (algorithm) {
      case CryptoAlgorithm.SECP256K1:
        if (!ec.isPrivate(privateKey)) {
          throw ArgumentError("Invalid SECP256K1 private key");
        }

        /// Derive the corresponding public key
        final public = ec.pointFromScalar(privateKey, true);

        /// Create and return the XRPPrivateKey instance for SECP256K1
        return XRPPrivateKey._(privateKey, public!, CryptoAlgorithm.SECP256K1);

      default:

        /// Derive the public key material
        final public = xrpl.getMaterial(privateKey);

        /// Create and return the XRPPrivateKey instance for ED25519
        return XRPPrivateKey._(privateKey, public.$1, CryptoAlgorithm.ED25519);
    }
  }

  final CryptoAlgorithm algorithm;

  /// Signs the given [message] using the private key and returns the signature as a hexadecimal string.
  ///
  /// [message] is the message to be signed.
  String sign(String message) {
    switch (algorithm) {
      case CryptoAlgorithm.ED25519:

        /// Use the XRPL signing method for ED25519
        return xrpl.signED(message, _privateKey);

      default:

        /// Use the SEC format signing for other algorithms
        return _signSEC(message);
    }
  }

  /// Signs the given [message] using the private key and returns the signature as a hexadecimal string
  /// in the SEC (Standards for Efficient Cryptography) format.
  ///
  /// [message] is the message to be signed.
  String _signSEC(String message) {
    final sign = ec.signDer(hash512Half(hexToBytes(message)), toBytes());
    return bytesToHex(sign);
  }

  final Uint8List _privateKey;
  final Uint8List _publicKey;

  /// Returns the private key as a Uint8List.
  Uint8List toBytes() {
    return _privateKey;
  }

  /// Returns the private key as a hexadecimal string with the appropriate prefix based on the algorithm.
  String toHex() {
    String toString = bytesToHex(_privateKey);
    if (toString.length < 64) {
      toString = toString.padLeft(64, '0');
    }
    switch (algorithm) {
      case CryptoAlgorithm.ED25519:
        return "ED$toString".toUpperCase();
      default:
        return "00$toString".toUpperCase();
    }
  }

  /// Returns the public key as a hexadecimal string with the appropriate prefix based on the algorithm.
  String toHexPublic() {
    String toString = bytesToHex(_publicKey);
    if (toString.length < 64) {
      toString = toString.padLeft(64, '0');
    }
    switch (algorithm) {
      case CryptoAlgorithm.ED25519:
        return "ED$toString".toUpperCase();
      default:
        return toString.toUpperCase();
    }
  }

  /// Gets the public key associated with this private key.
  XRPPublicKey getPublic() {
    return XRPPublicKey.fromHex(toHexPublic());
  }
}
