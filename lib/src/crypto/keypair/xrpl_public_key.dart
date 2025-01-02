import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/xrpl/address/xrpl.dart';
import 'package:xrpl_dart/src/xrpl/exception/exceptions.dart';

import 'xrpl_private_key.dart';

class RippleKeyConst {
  static const int publicKeyLength = 33;
}

class XRPPublicKey {
  final XRPKeyAlgorithm algorithm;
  final IPublicKey _publicKey;

  XRPPublicKey._(this._publicKey, this.algorithm);

  /// Creates an XRPPublicKey from bytes.
  factory XRPPublicKey.fromBytes(List<int> keyBytes,
      {XRPKeyAlgorithm? algorithm}) {
    algorithm ??= _findAlgorithm(keyBytes);
    final publicKey = _toPublicKey(keyBytes, algorithm);
    return XRPPublicKey._(publicKey, algorithm);
  }
  static XRPKeyAlgorithm _findAlgorithm(List<int> keyBytes) {
    if (keyBytes.length == Ed25519KeysConst.pubKeyByteLen) {
      return XRPKeyAlgorithm.ed25519;
    }
    if (keyBytes.length == RippleKeyConst.publicKeyLength) {
      final prefix = keyBytes.sublist(0, 1);
      if (BytesUtils.bytesEqual(prefix, Ed25519KeysConst.xrpPubKeyPrefix) ||
          BytesUtils.bytesEqual(prefix, Ed25519KeysConst.pubKeyPrefix)) {
        return XRPKeyAlgorithm.ed25519;
      }
      if (Secp256k1PublicKeyEcdsa.isValidBytes(keyBytes)) {
        return XRPKeyAlgorithm.secp256k1;
      }
    }

    throw const XRPLAddressCodecException(
        'invalid public key. public key length must be ${RippleKeyConst.publicKeyLength} bytes');
  }

  static IPublicKey _toPublicKey(
      List<int> keyBytes, XRPKeyAlgorithm algorithm) {
    try {
      if (algorithm == XRPKeyAlgorithm.ed25519 &&
          keyBytes.length == RippleKeyConst.publicKeyLength) {
        keyBytes = keyBytes.sublist(1);
      }
      return IPublicKey.fromBytes(keyBytes, algorithm.curveType);
    } catch (e) {
      throw const XRPLAddressCodecException('invalid public key');
    }
  }

  /// Creates an XRPPublicKey from a hexadecimal string.
  factory XRPPublicKey.fromHex(String public) {
    return XRPPublicKey.fromBytes(BytesUtils.fromHexString(public));
  }

  /// Converts the XRPPublicKey to an XRPAddress.
  XRPAddress toAddress() {
    return XRPAddress.fromPublicKeyBytes(toBytes(), algorithm);
  }

  /// Returns the hexadecimal representation of the XRPPublicKey.
  String toHex([PubKeyModes mode = PubKeyModes.compressed]) {
    return BytesUtils.toHexString(toBytes(mode), lowerCase: false);
  }

  /// Returns the public key as a list of bytes based on the specified [mode].
  ///
  /// This method converts the public key to a list of bytes based on the provided [mode],
  /// which defaults to [PubKeyModes.compressed] if not specified. It performs different
  /// operations based on the algorithm's curve type and the specified mode, and returns
  /// the resulting bytes representing the public key.
  ///
  /// [mode] The mode for encoding the public key (compressed or uncompressed).
  /// returns A list of bytes representing the public key.
  List<int> toBytes([PubKeyModes mode = PubKeyModes.compressed]) {
    if (algorithm.curveType == EllipticCurveTypes.ed25519) {
      return List.from([
        ...Ed25519KeysConst.xrpPubKeyPrefix,
        ..._publicKey.compressed.sublist(1)
      ]);
    }
    if (mode == PubKeyModes.compressed) {
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
