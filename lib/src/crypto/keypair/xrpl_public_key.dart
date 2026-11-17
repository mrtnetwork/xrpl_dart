import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/xrpl/address/xrpl.dart';

import 'xrpl_private_key.dart';

class RippleKeyConst {
  static const int publicKeyLength = 33;
}

class XRPPublicKey with Equality {
  final XRPKeyAlgorithm algorithm;
  final IPublicKey publicKey;
  const XRPPublicKey._(this.publicKey, this.algorithm);

  factory XRPPublicKey.from(IPublicKey privateKey) {
    switch (privateKey.type) {
      case CryptoKeyType.ed25519:
        return XRPPublicKey._(privateKey, XRPKeyAlgorithm.ed25519);
      case CryptoKeyType.secp256k1:
        return XRPPublicKey._(privateKey, XRPKeyAlgorithm.secp256k1);
      default:
        throw BuError(DefaultErrorType.unsupported, 
          'Unsupported key type ${privateKey.type.name}: expected ed25519 or secp256k1.',
        );
    }
  }

  /// Creates an XRPPublicKey from bytes.
  factory XRPPublicKey.fromBytes(
    List<int> keyBytes, {
    XRPKeyAlgorithm? algorithm,
  }) {
    algorithm ??= _findAlgorithm(keyBytes);
    final publicKey = _toPublicKey(keyBytes, algorithm);
    return XRPPublicKey._(publicKey, algorithm);
  }
  static XRPKeyAlgorithm _findAlgorithm(List<int> keyBytes) {
    if (keyBytes.length == Ed25519KeysConst.pubKeyByteLen) {
      return XRPKeyAlgorithm.ed25519;
    }
    if (keyBytes.length == EcdsaKeysConst.pubKeyUncompressedByteLen) {
      return XRPKeyAlgorithm.secp256k1;
    }
    if (keyBytes.length == RippleKeyConst.publicKeyLength) {
      final prefix = keyBytes.sublist(0, 1);
      if (BytesUtils.bytesEqual(prefix, Ed25519KeysConst.xrpPubKeyPrefix) ||
          BytesUtils.bytesEqual(prefix, Ed25519KeysConst.pubKeyPrefix)) {
        return XRPKeyAlgorithm.ed25519;
      }
      return XRPKeyAlgorithm.secp256k1;
    }

    throw const BuError(DefaultErrorType.invalidLength, 
      'invalid public key. public key length must be ${RippleKeyConst.publicKeyLength} bytes',
    );
  }

  static IPublicKey _toPublicKey(
    List<int> keyBytes,
    XRPKeyAlgorithm algorithm,
  ) {
    try {
      if (algorithm == XRPKeyAlgorithm.ed25519 &&
          keyBytes.length == RippleKeyConst.publicKeyLength) {
        keyBytes = keyBytes.sublist(1);
      }
      return IPublicKey.fromBytes(keyBytes, algorithm.curveType);
    } catch (e) {
      throw BuError(DefaultErrorType.invalidLength, 
        'Invalid public key with length ${keyBytes.length}: $e.',
      );
    }
  }

  /// Creates an XRPPublicKey from a hexadecimal string.
  factory XRPPublicKey.fromHex(String public, {XRPKeyAlgorithm? algorithm}) {
    return XRPPublicKey.fromBytes(
      BytesUtils.fromHexString(public),
      algorithm: algorithm,
    );
  }

  /// Converts the XRPPublicKey to an [XRPClassicAddress].
  XRPClassicAddress toClassicAddress() {
    return XRPClassicAddress.fromPublicKeyBytes(
      _toBytes(withPrefix: false),
      algorithm: algorithm,
    );
  }

  /// Converts the XRPPublicKey to an [XRPXAddress].
  XRPXAddress toXAddress(ChainType chainType, {int? tag}) {
    return XRPXAddress.fromPublicKeyBytes(
      _toBytes(withPrefix: false),
      algorithm: algorithm,
      tag: tag,
      chainType: chainType,
    );
  }

  /// Returns the hexadecimal representation of the XRPPublicKey.
  String toHex([CryptoKeyEncoding mode = CryptoKeyEncoding.base]) {
    return toBytes(mode).toHex(lowerCase: false);
  }

  BuBytes _toBytes({
    CryptoKeyEncoding mode = CryptoKeyEncoding.base,
    bool withPrefix = true,
  }) {
    if (withPrefix && algorithm.curveType == CryptoKeyType.ed25519) {
      return BuBytes.concat([
        Ed25519KeysConst.xrpPubKeyPrefix,
        publicKey.toBytes(mode: mode),
      ]);
    }
    return publicKey.toBytes(mode: mode);
  }

  /// Returns the public key as a list of bytes based on the specified [mode].
  ///
  /// This method converts the public key to a list of bytes based on the provided [mode],
  /// which defaults to [CryptoKeyEncoding.base] if not specified. It performs different
  /// operations based on the algorithm's curve type and the specified mode, and returns
  /// the resulting bytes representing the public key.
  ///
  /// [mode] The mode for encoding the public key (compressed or uncompressed).
  /// returns A list of bytes representing the public key.
  BuBytes toBytes([CryptoKeyEncoding mode = CryptoKeyEncoding.base]) {
    return _toBytes(mode: mode);
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
    final verifyingKey = XrpVerifier.from(publicKey);
    try {
      final blobBytes = BytesUtils.fromHexString(blob);
      final signatureBytes = BytesUtils.fromHexString(signature);
      return verifyingKey.verify(blobBytes, signatureBytes);
    } catch (_) {
      throw const BuError(DefaultErrorType.badHex, 
        'Cannot verify signature: blob or signature is not valid hex.',
      );
    }
  }

  @override
  List<dynamic> get variables => [publicKey];
}
