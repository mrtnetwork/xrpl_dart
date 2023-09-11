import 'dart:typed_data';

import 'package:xrp_dart/src/crypto/crypto.dart';
import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/xrpl/address_utilities.dart';
import 'ed_curve.dart' as xrpl;
import 'xrpl_public_key.dart';
import 'ec_encryption.dart' as ec;

class XRPPrivateKey {
  XRPPrivateKey._(this._privateKey, this._publicKey, this.algorithm);

  factory XRPPrivateKey.random(
      {CryptoAlgorithm algorithm = CryptoAlgorithm.ED25519}) {
    final rand = generateRandom(16);
    return XRPPrivateKey.fromEntropy(bytesToHex(rand), algorithm: algorithm);
  }
  factory XRPPrivateKey.fromEntropy(String entropy,
      {CryptoAlgorithm algorithm = CryptoAlgorithm.ED25519}) {
    XRPAddressUtilities.encodeSeed(hexToBytes(entropy), algorithm);
    switch (algorithm) {
      case CryptoAlgorithm.ED25519:
        final privateKey = _seedToHash(hexToBytes(entropy));
        final public = _getMaterial(privateKey);
        return XRPPrivateKey._(privateKey, public.$1, algorithm);
      default:
        final privateKey = ec.deriveKeyPair(entropy);
        final public = ec.pointFromScalar(privateKey, true);
        return XRPPrivateKey._(privateKey, public!, algorithm);
    }
  }
  factory XRPPrivateKey.fromSeed(String seed) {
    final entropy = XRPAddressUtilities.decodeSeed(seed);
    return XRPPrivateKey.fromEntropy(bytesToHex(entropy.$1),
        algorithm: entropy.$2);
  }
  factory XRPPrivateKey.fromHex(String privateKey) {
    if (privateKey.length != 66) {
      throw ArgumentError(
          "Invalid privateKey, private key must be 66 character");
    }
    Uint8List bytes = hexToBytes(privateKey);
    if (bytes[0] == CryptoAlgorithm.ED25519.value) {
      bytes = bytes.sublist(1);
      final public = _getMaterial(bytes);
      return XRPPrivateKey._(bytes, public.$1, CryptoAlgorithm.ED25519);
    } else if (bytes[0] != CryptoAlgorithm.SECP256K1.value) {
      throw ArgumentError("Invalid prefix");
    }
    bytes = bytes.sublist(1);
    if (!ec.isPrivate(bytes)) {
      throw ArgumentError("Invalid SECP256K1 privae key");
    }
    final public = ec.pointFromScalar(bytes, true);
    return XRPPrivateKey._(bytes, public!, CryptoAlgorithm.SECP256K1);
  }
  factory XRPPrivateKey.fromBytes(
      Uint8List privateKey, CryptoAlgorithm algorithm) {
    if (privateKey.length != 32) {
      throw ArgumentError(
          "Invalid privateKey, private key must be 32 character in bytes");
    }
    switch (algorithm) {
      case CryptoAlgorithm.SECP256K1:
        if (!ec.isPrivate(privateKey)) {
          throw ArgumentError("Invalid SECP256K1 private key");
        }
        final public = ec.pointFromScalar(privateKey, true);
        return XRPPrivateKey._(privateKey, public!, CryptoAlgorithm.SECP256K1);
      default:
        final public = _getMaterial(privateKey);
        return XRPPrivateKey._(privateKey, public.$1, CryptoAlgorithm.ED25519);
    }
  }

  final CryptoAlgorithm algorithm;

  /// sign with SECP256K1 cryptography
  String _signSEC(
    String message,
  ) {
    final sign = ec.signDer(hash512Half(hexToBytes(message)), toBytes());
    return bytesToHex(sign);
  }

  /// sign xrp blob transaction
  String sign(String message) {
    switch (algorithm) {
      case CryptoAlgorithm.ED25519:
        return _signED(message);
      default:
        return _signSEC(message);
    }
  }

  /// sign with ED25519 cryptography
  String _signED(String hexMessage) {
    final mt = _getMaterial(_privateKey);
    final message = hexToBytes(hexMessage);
    final combine = Uint8List.fromList([...mt.$2, ...message]);
    final hashDigest = hash512(combine);
    BigInt r = xrpl.liteEddianToBigInt(hashDigest);
    r = r % xrpl.EDCurve.order;

    final R = xrpl.EDCurve.generator * r;
    final eR = R.encodePoint();
    final combine2 = hash512(Uint8List.fromList([...eR, ...mt.$1, ...message]));
    final i = xrpl.liteEddianToBigInt(combine2);
    final S = (r + i * mt.$3) % xrpl.EDCurve.order;
    final eRB = xrpl.liteEddianToBigInt(eR);
    final Uint8List encodedDigest = Uint8List.fromList([
      ...xrpl.bigIntToLittleEndianBytes(eRB, 32),
      ...xrpl.bigIntToLittleEndianBytes(S, 32)
    ]);
    return bytesToHex(encodedDigest);
  }

  static Uint8List _seedToHash(Uint8List seed) {
    final seedHash = hash512(seed);
    final privateKey = seedHash.sublist(0, 32);
    return privateKey;
  }

  /// get publick key from ED25519 privateKey
  static (Uint8List, Uint8List, BigInt) _getMaterial(Uint8List privateKey) {
    final digest = hash512(privateKey);
    final a = digest.sublist(0, 32);
    final prefix = digest.sublist(32);
    a[0] &= 0xF8;
    a[31] = (a[31] & 0x7F) | 0x40;
    final aa = xrpl.liteEddianToBigInt(a);
    final mul = xrpl.EDCurve.generator * aa;
    final publicKey = mul.encodePoint();
    return (publicKey, prefix, aa);
  }

  final Uint8List _privateKey;
  final Uint8List _publicKey;

  Uint8List toBytes() {
    return _privateKey;
  }

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

  XRPPublicKey getPublic() {
    return XRPPublicKey.fromHex(toHexPublic());
  }
}
