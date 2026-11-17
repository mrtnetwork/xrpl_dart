import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/crypto/signature/signature.dart';
import 'xrpl_public_key.dart';

/// Enum representing different XRP key algorithms.
enum XRPKeyAlgorithm {
  /// ed25519 algorithm with a prefix of 0xED and the curve type ed25519.
  ed25519(0xED, CryptoKeyType.ed25519),

  /// secp256k1 algorithm with a prefix of 0x00 and the curve type secp256k1.
  secp256k1(0x00, CryptoKeyType.secp256k1);

  /// Prefix value associated with the key algorithm.
  final int prefix;

  /// Elliptic curve type used by the key algorithm.
  final CryptoKeyType curveType;

  /// Private constructor to initialize the prefix and curve type for each key algorithm.
  const XRPKeyAlgorithm(this.prefix, this.curveType);

  @override
  String toString() {
    return curveType.name;
  }

  static XRPKeyAlgorithm fromKeyType(CryptoKeyType type) {
    return values.firstWhere(
      (e) => e.curveType == type,
      orElse:
          () =>
              throw BuError(DefaultErrorType.unsupported, 
                'Unsupported key type ${type.name}.',
              ),
    );
  }
}

class XrpKeyConst {
  static const List<int> ed255PrivateKeyPrefix = [0xed];
  static const List<int> secpPrivateKey = [0x00];
  static const int privateKeyWithPrefix = 33;
  static const List<int> _secp256k1SeedMidBytes = [0, 0, 0, 0];
  static const String _ed25519KeyHexPrefix = 'ED';
  static const String _secp2561KeyHexPrefix = '00';
}

class XrpSeedUtils {
  /// Derives an ED25519 key from the given seed using the SHA-512 hash function.
  ///
  /// This method takes a seed as input and applies the SHA-512 hash function to it
  /// to derive an ED25519 key. It returns the derived key as a list of integers.
  static BuBytes deriveED25519(List<int> seed) {
    return QuickCrypto.sha512HashHalves(seed).$1;
  }

  /// Derives a key pair from the given seed using a multi-step process.
  ///
  /// This method takes a seed as input and performs a series of steps to derive a key pair.
  /// It then returns the derived key pair as a list of integers.
  static BuBytes deriveKeyPair(List<int> seed) {
    // Calculate the root value using the provided seed.
    final BuBytes root = _getSecret(seed);

    // Generate a new public point using the Secp256k1 curve and the root value.
    final newPubPoint = blockchainUtils.api.secp256k1.multBase(root);

    // Calculate the intermediate value using the new public point.
    final BuBytes mid = _getSecret(
      newPubPoint,
      seedMidBytes: XrpKeyConst._secp256k1SeedMidBytes,
    );

    // Calculate the final key pair value by combining the root and intermediate values.
    return blockchainUtils.api.secp256k1.scAdd(root, mid);
    // (root + mid) % order;
  }

  /// Calculates the secret value from the given data using an iterative process.
  ///
  /// This method takes the given data as input and iteratively calculates a secret value.
  /// It then returns the calculated secret as a BigInt.
  static BuBytes _getSecret(
    List<int> data, {
    List<int> seedMidBytes = const [],
  }) {
    const int sqSize = 4;
    final BigInt sqMax = BigInt.from(256) << (sqSize * 8);
    for (BigInt rawRoot = BigInt.zero; rawRoot < sqMax; rawRoot += BigInt.one) {
      final List<int> root = List<int>.filled(sqSize, 0);
      for (int i = 0; i < sqSize; i++) {
        root[i] =
            ((rawRoot >> (8 * (sqSize - 1 - i))) & BinaryOps.maskBig8).toInt();
      }
      final List<int> combine = List<int>.from([
        ...data,
        ...seedMidBytes,
        ...root,
      ]);
      final hash = QuickCrypto.sha512Hash(combine).sublist(0, 32);
      if (Secp256k1PrivateKey.isValidBytes(hash)) {
        return hash;
      }
    }
    throw const BuError(DefaultErrorType.badPrivateKey, 
      'Cannot derive secret key from provided value.',
    );
  }

  /// Prefix used for seed values in key pair derivation.
  static const List<int> _seedPrefix = [0x21];

  /// Prefix used for ED25519 seed values in key pair derivation.
  static const List<int> _ed25519SeedPrefix = [0x01, 0xE1, 0x4B];

  /// Length constants for various XRPL components
  static const int seedLength = 16;

  /// Mapping of crypto algorithms to corresponding address prefixes
  static const Map<XRPKeyAlgorithm, List<List<int>>> _algorithmSeedPrefix = {
    XRPKeyAlgorithm.ed25519: [_ed25519SeedPrefix, _seedPrefix],
    XRPKeyAlgorithm.secp256k1: [_seedPrefix],
  };

  /// This private method encodes a byte string with a given prefix and expected length
  /// into a Ripple family seed string using Base58 encoding with checksum.
  static String _encode(
    List<int> bytestring,
    List<int> prefix,
    int expectedLength,
  ) {
    /// Check if the expected length is non-zero and matches the actual byte string length.
    if (expectedLength != 0 && bytestring.length != expectedLength) {
      /// Throw an exception if the lengths do not match, indicating an unexpected payload length.
      throw const BuError(DefaultErrorType.invalidLength, 
        'unexpected_payload_length: len(bytestring) does not match expected_length. Ensure that the bytes are a bytestring.',
      );
    }

    /// Encode the payload using Base58 encoding with a checksum and return the result.
    return Base58Encoder.encodeWithChecksum([
      ...prefix,
      ...bytestring,
    ], Base58Alphabets.ripple);
  }

  /// This private method decodes a Base58 encoded string with a provided prefix
  /// and returns the decoded byte string after validating the prefix.
  static BuBytes _decode(String b58String, List<int> prefix) {
    /// Get the length of the prefix.
    final prefixLength = prefix.length;

    /// Decode the Base58 encoded string with a checksum.
    final decoded = Base58Decoder.decodeWithChecksum(
      b58String,
      Base58Alphabets.ripple,
    );
    try {
      /// Check if the decoded bytes match the provided prefix.
      if (!BytesUtils.bytesEqual(decoded.sublist(0, prefixLength), prefix)) {
        /// Throw an exception if the prefix does not match, indicating an incorrect prefix.
        throw const BuError(DefaultErrorType.invalidArgument, 'Provided prefix is incorrect');
      }

      /// Return the decoded byte string after removing the prefix.
      return decoded.sublist(prefixLength);
    } finally {
      decoded.forceZero();
    }
  }

  /// This method encodes a seed (entropy) into a Ripple family seed string using the specified encoding type.
  static String encodeSeed(List<int> entropy, XRPKeyAlgorithm encodingType) {
    /// Check if the entropy length matches the expected seed length.
    if (entropy.length != seedLength) {
      throw const BuError(DefaultErrorType.invalidLength, 
        'Entropy must have length $seedLength',
      );
    }

    /// Get the appropriate prefix for the specified encoding type.
    final prefix = _algorithmSeedPrefix[encodingType]![0];

    /// Encode the entropy with the prefix and return the resulting Ripple family seed string.
    return _encode(entropy, prefix, seedLength);
  }

  /// This method decodes a Ripple family seed string into its corresponding entropy and encoding algorithm.
  static (BuBytes, XRPKeyAlgorithm) decodeSeed(
    String seed, [
    XRPKeyAlgorithm? algorithm,
  ]) {
    if (algorithm != null) {
      /// If a specific algorithm is provided, attempt to decode with that algorithm's prefix.
      for (final prefix in _algorithmSeedPrefix[algorithm]!) {
        try {
          final decodedResult = _decode(seed, prefix);
          return (decodedResult, algorithm);
        } catch (e) {
          /// Prefix is incorrect, continue to the next prefix.
          continue;
        }
      }
      throw BuError(DefaultErrorType.invalidArgument, 
        'Wrong algorithm ${algorithm.name} for the seed type.',
      );
    }

    /// If no specific algorithm is provided, try all possible algorithms.
    for (final algorithm in XRPKeyAlgorithm.values) {
      final prefix = _algorithmSeedPrefix[algorithm]![0];
      try {
        final decodedResult = _decode(seed, prefix);
        return (decodedResult, algorithm);
      } catch (e) {
        /// Prefix is incorrect, continue to the next algorithm.
        continue;
      }
    }
    throw const BuError(DefaultErrorType.invalidSeed, 
      'Invalid seed; could not determine encoding algorithm',
    );
  }
}

class XRPPrivateKey with SecretState {
  const XRPPrivateKey._(this.privateKey, this.algorithm);
  final IPrivateKey privateKey;

  factory XRPPrivateKey.from(IPrivateKey privateKey) {
    switch (privateKey.type) {
      case CryptoKeyType.ed25519:
        return XRPPrivateKey._(privateKey, XRPKeyAlgorithm.ed25519);
      case CryptoKeyType.secp256k1:
        return XRPPrivateKey._(privateKey, XRPKeyAlgorithm.secp256k1);
      default:
        throw BuError(DefaultErrorType.unsupported, 
          'Unsupported key type ${privateKey.type.name}: expected ed25519 or secp256k1.',
        );
    }
  }

  /// Factory constructor for generating a random XRP private key.
  /// [algorithm] specifies the cryptographic algorithm, with ED25519 being the default.
  factory XRPPrivateKey.random({
    XRPKeyAlgorithm algorithm = XRPKeyAlgorithm.ed25519,
    CbGenerateRandom? randomGenerator,
  }) {
    /// Generate 16 random bytes as entropy
    final rand =
        randomGenerator?.call(XrpSeedUtils.seedLength) ??
        QuickCrypto.generateRandom(length: XrpSeedUtils.seedLength);
    if (rand.length != XrpSeedUtils.seedLength) {
      throw BuError(DefaultErrorType.invalidArgument, 
        'Incorrect random generated size.',
        details: {
          'expected': XrpSeedUtils.seedLength.toString(),
          'length': rand.length.toString(),
        },
      );
    }

    /// Create an XRP private key from the generated entropy
    return XRPPrivateKey.fromEntropyBytes(rand, algorithm: algorithm);
  }

  /// Factory constructor for creating an XRP private key from entropy.
  ///
  /// [entropy] is the entropy for generating the private key.
  /// [algorithm] specifies the cryptographic algorithm, with ED25519 being the default.
  factory XRPPrivateKey.fromEntropy(
    String entropy, {
    XRPKeyAlgorithm algorithm = XRPKeyAlgorithm.ed25519,
  }) {
    final entropyBytes = BytesUtils.fromHexString(entropy);
    try {
      return XRPPrivateKey.fromEntropyBytes(entropyBytes, algorithm: algorithm);
    } finally {
      entropyBytes.forceZero();
    }
  }

  /// Factory constructor for creating an XRP private key from entropy.
  ///
  /// [entropyBytes] is the entropy for generating the private key.
  /// [algorithm] specifies the cryptographic algorithm, with ED25519 being the default.
  factory XRPPrivateKey.fromEntropyBytes(
    List<int> entropyBytes, {
    XRPKeyAlgorithm algorithm = XRPKeyAlgorithm.ed25519,
  }) {
    /// Encode the seed using XRPAddressUtilities
    XrpSeedUtils.encodeSeed(entropyBytes, algorithm);

    switch (algorithm) {
      case XRPKeyAlgorithm.secp256k1:
        final derive = XrpSeedUtils.deriveKeyPair(entropyBytes);
        final privateKey = Secp256k1PrivateKey.fromBytes(derive);
        derive.forceZero();
        return XRPPrivateKey._(privateKey, algorithm);
      default:
        final privateBytes = XrpSeedUtils.deriveED25519(entropyBytes);
        final prive = ED25519PrivateKey.fromBytes(privateBytes);
        privateBytes.forceZero();
        return XRPPrivateKey._(prive, algorithm);
    }
  }

  /// Factory constructor for creating an XRP private key from a seed.
  ///
  /// [seed] is the seed value for generating the private key.
  factory XRPPrivateKey.fromSeed(String seed) {
    /// Decode the seed to retrieve entropy and algorithm
    final entropy = XrpSeedUtils.decodeSeed(seed);
    try {
      /// Create an XRPPrivateKey from the entropy and specified algorithm
      return XRPPrivateKey.fromEntropyBytes(entropy.$1, algorithm: entropy.$2);
    } finally {
      entropy.$1.forceZero();
    }
  }

  /// Factory constructor for creating an XRP private key from a hexadecimal representation.
  ///
  /// [privateKey] is the hexadecimal private key to be used for XRP transactions.
  factory XRPPrivateKey.fromHex(
    String privateKey, {
    XRPKeyAlgorithm? algorithm,
  }) {
    final BuBytes bytes = BytesUtils.fromHexString(privateKey);
    try {
      return XRPPrivateKey.fromBytes(bytes, algorithm: algorithm);
    } finally {
      bytes.forceZero();
    }
  }

  /// Factory constructor for creating an XRP private key from a byte representation.
  ///
  /// [keyBytes] is the byte representation of the private key.
  /// [algorithm] is the cryptographic algorithm used for the private key.
  factory XRPPrivateKey.fromBytes(
    List<int> keyBytes, {
    XRPKeyAlgorithm? algorithm,
  }) {
    algorithm ??= findAlgorithm(keyBytes);
    final privateKey = _toPrivateKey(keyBytes, algorithm);
    return XRPPrivateKey._(privateKey, algorithm);
  }

  /// Finds the XRP key algorithm based on the given key bytes.
  ///
  /// This method takes the key bytes as input and determines the XRP key algorithm
  /// based on the validity of the key bytes for different algorithms.
  static XRPKeyAlgorithm findAlgorithm(List<int> keyBytes) {
    if (keyBytes.length == XrpKeyConst.privateKeyWithPrefix) {
      final keyPrefix = keyBytes.sublist(0, 1);
      if (BytesUtils.bytesEqual(keyPrefix, XrpKeyConst.secpPrivateKey)) {
        return XRPKeyAlgorithm.secp256k1;
      } else if (BytesUtils.bytesEqual(
        keyPrefix,
        XrpKeyConst.ed255PrivateKeyPrefix,
      )) {
        return XRPKeyAlgorithm.ed25519;
      }
    }
    throw BuError(DefaultErrorType.notFound, 
      'Cannot find key algorithm for ${keyBytes.length} bytes: expected 33 bytes with 0x00 (secp256k1) or 0xED (ed25519) prefix.',
    );
  }

  /// Converts the given [keyBytes] to an instance of IPrivateKey based on the provided XRP key [algorithm].
  ///
  /// This method takes the [keyBytes] and the XRP key [algorithm] as input and attempts
  /// to convert the [keyBytes] to an instance of IPrivateKey. It handles the conversion logic
  /// based on the provided [algorithm] and returns the resulting private key.
  ///
  /// [keyBytes] The byte representation of the private key.
  /// [algorithm] The XRP key algorithm associated with the key.
  /// returns An instance of IPrivateKey representing the private key.
  static IPrivateKey _toPrivateKey(
    List<int> keyBytes,
    XRPKeyAlgorithm algorithm,
  ) {
    try {
      if (keyBytes.length == Ed25519KeysConst.privKeyByteLen + 1) {
        keyBytes = keyBytes.sublist(1);
      }
      final toPrive = IPrivateKey.fromBytes(keyBytes, algorithm.curveType);
      return toPrive;
    } catch (e) {
      throw BuError(DefaultErrorType.invalidLength, 
        'Invalid private key with length ${keyBytes.length}.',
      );
    }
  }

  /// The XRP key algorithm associated with the private key.
  final XRPKeyAlgorithm algorithm;

  /// Signs the given [message] using the private key and returns the signature as a hexadecimal string.
  ///
  /// [message] is the message to be signed.
  XRPLSignature sign(List<int> message) {
    final signer = XrpSigner.from(privateKey);
    final signature = signer.sign(message);
    return XRPLSignature.sign(getPublic().toHex(), signature.encoded.toHex());
  }

  /// Returns the private key as a bytes.
  SecretBytes toBytes() {
    return privateKey.toBytes();
  }

  /// Returns the private key as a hexadecimal string with the appropriate prefix based on the algorithm.
  String toHex() {
    return _keyPrefixInHex + privateKey.takeSecretKey().toHex(lowerCase: false);
  }

  String get _keyPrefixInHex {
    switch (algorithm) {
      case XRPKeyAlgorithm.ed25519:
        return XrpKeyConst._ed25519KeyHexPrefix;
      default:
        return XrpKeyConst._secp2561KeyHexPrefix;
    }
  }

  /// Gets the public key associated with this private key.
  XRPPublicKey getPublic() {
    return XRPPublicKey.from(privateKey.publicKey);
  }

  @override
  void dispose() {
    privateKey.dispose();
  }
}
