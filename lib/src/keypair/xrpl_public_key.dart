import 'package:blockchain_utils/bip/address/p2pkh_addr.dart';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:blockchain_utils/compare/compare.dart';
import 'package:xrp_dart/src/xrpl/address/xrpl.dart';

import 'xrpl_private_key.dart';

typedef PubKeyMode = P2PKHPubKeyModes;

class XRPPublicKey {
  final XrpKeyAlgorithm algorithm;
  final IPublicKey _publicKey;

  XRPPublicKey._(this._publicKey, this.algorithm);

  /// Creates an XRPPublicKey from bytes.
  factory XRPPublicKey.fromBytes(List<int> keyBytes,
      {XrpKeyAlgorithm? algorithm}) {
    algorithm ??= _findAlgorithm(keyBytes);
    final publicKey = _toPublicKey(keyBytes, algorithm);

    return XRPPublicKey._(publicKey, algorithm);
  }
  static XrpKeyAlgorithm _findAlgorithm(List<int> keyBytes) {
    if (keyBytes.length ==
        Ed25519KeysConst.xrpPubKeyPrefix.length +
            Ed25519KeysConst.pubKeyByteLen) {
      final prefix =
          keyBytes.sublist(0, Ed25519KeysConst.xrpPubKeyPrefix.length);
      if (bytesEqual(prefix, Ed25519KeysConst.xrpPubKeyPrefix)) {
        return XrpKeyAlgorithm.ed25519;
      }
    }
    if (Secp256k1PublicKeyEcdsa.isValidBytes(keyBytes)) {
      return XrpKeyAlgorithm.secp256k1;
    } else if (Ed25519PublicKey.isValidBytes(keyBytes)) {
      return XrpKeyAlgorithm.ed25519;
    }
    throw ArgumentError("invalid public key");
  }

  static IPublicKey _toPublicKey(
      List<int> keyBytes, XrpKeyAlgorithm algorithm) {
    try {
      if (algorithm == XrpKeyAlgorithm.ed25519 &&
          keyBytes.length ==
              Ed25519KeysConst.xrpPubKeyPrefix.length +
                  Ed25519KeysConst.pubKeyByteLen) {
        keyBytes = keyBytes.sublist(1);
      }
      return IPublicKey.fromBytes(keyBytes, algorithm.curveType);
    } catch (e) {
      throw ArgumentError("invalid public key");
    }
  }

  /// Creates an XRPPublicKey from a hexadecimal string.
  factory XRPPublicKey.fromHex(String public) {
    return XRPPublicKey.fromBytes(BytesUtils.fromHexString(public));
  }

  /// Converts the XRPPublicKey to an XRPAddress.
  XRPAddress toAddress() {
    return XRPAddress.fromPublicKeyBytes(toBytes());
  }

  /// Returns the hexadecimal representation of the XRPPublicKey.
  String toHex([PubKeyMode mode = PubKeyMode.compressed]) {
    return BytesUtils.toHexString(toBytes(mode), false);
  }

  /// Returns the public key as a list of bytes based on the specified [mode].
  ///
  /// This method converts the public key to a list of bytes based on the provided [mode],
  /// which defaults to [PubKeyMode.compressed] if not specified. It performs different
  /// operations based on the algorithm's curve type and the specified mode, and returns
  /// the resulting bytes representing the public key.
  ///
  /// [mode] The mode for encoding the public key (compressed or uncompressed).
  /// returns A list of bytes representing the public key.
  List<int> toBytes([PubKeyMode mode = PubKeyMode.compressed]) {
    if (algorithm.curveType == EllipticCurveTypes.ed25519) {
      return List.from([
        ...Ed25519KeysConst.xrpPubKeyPrefix,
        ..._publicKey.compressed.sublist(1)
      ]);
    }
    if (mode == PubKeyMode.compressed) {
      return _publicKey.compressed;
    }
    return _publicKey.uncompressed;
  }

  /// Verifies the signature of a blob using the provided verifying key.
  ///
  /// This method takes a blob and a signature as input and uses the verifying key
  /// to verify the signature of the blob. It then returns a boolean indicating
  /// whether the signature is valid.
  ///
  /// [blob] The data blob to be verified.
  /// [signature] The signature to be verified.
  /// returns A boolean value indicating whether the signature is valid.
  bool verifySignature(String blob, String signature) {
    final verifyingKey =
        XrpVerifier.fromKeyBytes(toBytes(), algorithm.curveType);
    return verifyingKey.verify(
        BytesUtils.fromHexString(blob), BytesUtils.fromHexString(signature));
  }
}
