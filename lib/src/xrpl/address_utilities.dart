/// ignore_for_file: non_constant_identifier_names, constant_identifier_names

// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'dart:typed_data';

import "package:blockchain_utils/base58/base58.dart" as bs58;
import 'package:xrp_dart/src/formating/bytes_num_formating.dart';

import 'exception/exceptions.dart';

enum CryptoAlgorithm {
  ED25519(0xED),
  SECP256K1(0x00);

  final int value;
  const CryptoAlgorithm(this.value);
}

class XRPAddressUtilities {
  /// Constants and mappings for XRPL address prefixes and lengths.

  /// Prefixes for different address types
  static final List<int> _CLASSIC_ADDRESS_PREFIX = [0x0];
  static final List<int> _ACCOUNT_PUBLIC_KEY_PREFIX = [0x23];
  static final List<int> _FAMILY_SEED_PREFIX = [0x21];
  static final List<int> _NODE_PUBLIC_KEY_PREFIX = [0x1C];
  static final List<int> _ED25519_SEED_PREFIX = [0x01, 0xE1, 0x4B];

  /// Length constants for various XRPL components
  static const int SEED_LENGTH = 16;
  static const int CLASSIC_ADDRESS_LENGTH = 20;
  static const int NODE_PUBLIC_KEY_LENGTH = 33;
  static const int ACCOUNT_PUBLIC_KEY_LENGTH = 33;

  /// Mapping of crypto algorithms to corresponding address prefixes
  static final Map<CryptoAlgorithm, List<List<int>>> _ALGORITHM_TO_PREFIX_MAP =
      {
    CryptoAlgorithm.ED25519: [_ED25519_SEED_PREFIX, _FAMILY_SEED_PREFIX],
    CryptoAlgorithm.SECP256K1: [_FAMILY_SEED_PREFIX],
  };

  /// This private method encodes a byte string with a given prefix and expected length
  /// into a Ripple address using Base58 encoding with checksum.

  static String _encode(
      Uint8List bytestring, List<int> prefix, int expectedLength) {
    /// Check if the expected length is non-zero and matches the actual byte string length.
    if (expectedLength != 0 && bytestring.length != expectedLength) {
      /// Throw an exception if the lengths do not match, indicating an unexpected payload length.
      throw XRPLAddressCodecException(
          'unexpected_payload_length: len(bytestring) does not match expected_length. Ensure that the bytes are a bytestring.');
    }

    /// Create an encoded prefix as a Uint8List.
    final encodedPrefix = Uint8List.fromList(prefix);

    /// Concatenate the encoded prefix with the input byte string.
    final payload = Uint8List.fromList(encodedPrefix + bytestring);

    /// Encode the payload using Base58 encoding with a checksum and return the result.
    return bs58.encodeCheck(payload, alphabet: bs58.ripple);
  }

  /// This private method decodes a Base58 encoded string with a provided prefix
  /// and returns the decoded byte string after validating the prefix.

  static Uint8List _decode(String b58String, Uint8List prefix) {
    /// Get the length of the prefix.
    final prefixLength = prefix.length;

    /// Decode the Base58 encoded string with a checksum.
    final decoded = bs58.decodeCheck(b58String, alphabet: bs58.ripple);

    /// Check if the decoded bytes match the provided prefix.
    if (!bytesListEqual(decoded.sublist(0, prefixLength), prefix)) {
      /// Throw an exception if the prefix does not match, indicating an incorrect prefix.
      throw XRPLAddressCodecException('Provided prefix is incorrect');
    }

    /// Return the decoded byte string after removing the prefix.
    return Uint8List.fromList(decoded.sublist(prefixLength));
  }

  /// This method encodes a seed (entropy) into a Ripple address using the specified encoding type.

  static String encodeSeed(Uint8List entropy, CryptoAlgorithm encodingType) {
    /// Check if the entropy length matches the expected seed length.
    if (entropy.length != SEED_LENGTH) {
      throw XRPLAddressCodecException('Entropy must have length $SEED_LENGTH');
    }

    /// Check if the provided encoding type is valid and exists in the mapping.
    if (!_ALGORITHM_TO_PREFIX_MAP.containsKey(encodingType)) {
      throw XRPLAddressCodecException(
          'Encoding type must be one of CryptoAlgorithm');
    }

    /// Get the appropriate prefix for the specified encoding type.
    final prefix = _ALGORITHM_TO_PREFIX_MAP[encodingType]![0];

    /// Encode the entropy with the prefix and return the resulting Ripple address.
    return _encode(entropy, prefix, SEED_LENGTH);
  }

  /// This method decodes a Ripple address (seed) into its corresponding entropy and encoding algorithm.

  static (Uint8List, CryptoAlgorithm) decodeSeed(String seed,
      [CryptoAlgorithm? algorithm]) {
    if (algorithm != null) {
      /// If a specific algorithm is provided, attempt to decode with that algorithm's prefix.
      for (final prefix in _ALGORITHM_TO_PREFIX_MAP[algorithm]!) {
        try {
          final decodedResult = _decode(seed, Uint8List.fromList(prefix));
          return (decodedResult, algorithm);
        } catch (e) {
          /// Prefix is incorrect, continue to the next prefix.
          continue;
        }
      }
      throw XRPLAddressCodecException('Wrong algorithm for the seed type.');
    }

    /// If no specific algorithm is provided, try all possible algorithms.
    for (final algorithm in CryptoAlgorithm.values) {
      final prefix = _ALGORITHM_TO_PREFIX_MAP[algorithm]![0];
      try {
        final decodedResult = _decode(seed, Uint8List.fromList(prefix));
        return (decodedResult, algorithm);
      } catch (e) {
        /// Prefix is incorrect, continue to the next algorithm.
        continue;
      }
    }
    throw XRPLAddressCodecException(
        'Invalid seed; could not determine encoding algorithm');
  }

  /// These methods provide encoding and decoding functionality for Classic Addresses and Node Public Keys.

  /// Encode a byte string into a Classic Address.
  static String encodeClassicAddress(Uint8List bytestring) {
    return _encode(bytestring, _CLASSIC_ADDRESS_PREFIX, CLASSIC_ADDRESS_LENGTH);
  }

  /// Decode a Classic Address into a byte string.
  static Uint8List decodeClassicAddress(String classicAddress) {
    return _decode(classicAddress, Uint8List.fromList(_CLASSIC_ADDRESS_PREFIX));
  }

  /// Encode a byte string into a Node Public Key.
  static String encodeNodePublicKey(Uint8List bytestring) {
    return _encode(bytestring, _NODE_PUBLIC_KEY_PREFIX, NODE_PUBLIC_KEY_LENGTH);
  }

  /// Decode a Node Public Key into a byte string.
  static Uint8List decodeNodePublicKey(String nodePublicKey) {
    return _decode(nodePublicKey, Uint8List.fromList(_NODE_PUBLIC_KEY_PREFIX));
  }

  /// These methods provide encoding and decoding functionality for Account Public Keys
  /// and a utility method for checking the validity of Classic Addresses.

  /// Encode a byte string into an Account Public Key.
  static String encodeAccountPublicKey(Uint8List bytestring) {
    return _encode(
        bytestring, _ACCOUNT_PUBLIC_KEY_PREFIX, ACCOUNT_PUBLIC_KEY_LENGTH);
  }

  /// Decode an Account Public Key into a byte string.
  static Uint8List decodeAccountPublicKey(String accountPublicKey) {
    return _decode(
        accountPublicKey, Uint8List.fromList(_ACCOUNT_PUBLIC_KEY_PREFIX));
  }

  /// Check if a given Classic Address is valid.
  static bool isValidClassicAddress(String classicAddress) {
    try {
      decodeClassicAddress(classicAddress);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// These methods provide utility functions for working with X-Addresses and Classic Addresses.

  /// Check if a given X-Address is valid.
  static bool isValidXAddress(String xAddress) {
    try {
      xAddressToClassicAddress(xAddress);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Convert an address to its corresponding Classic Address.
  static String toClassicAddress(String address) {
    if (isValidClassicAddress(address)) return address;
    final decoded = bs58.decodeCheck(address, alphabet: bs58.ripple);
    final classicAddressBytes = decoded.sublist(2, 22);
    final classicAddress = encodeClassicAddress(classicAddressBytes);
    return classicAddress;
  }

  /// Convert an X-Address to its corresponding Classic Address, tag, and network information.
  static (String, int?, bool) xAddressToClassicAddress(String xAddress) {
    final decoded = bs58.decodeCheck(xAddress, alphabet: bs58.ripple);
    final isTestNetwork = isTestAddress(decoded.sublist(0, 2));
    final classicAddressBytes = decoded.sublist(2, 22);
    final tag = getTagFromBuffer(decoded.sublist(22));

    final classicAddress = encodeClassicAddress(classicAddressBytes);
    return (classicAddress, tag, isTestNetwork);
  }

  /// get address tag from bytes
  static int? getTagFromBuffer(Uint8List buffer) {
    int flag = buffer[0];
    if (flag >= 2) {
      throw XRPLAddressCodecException("Unsupported X-Address");
    }
    if (flag == 1) {
      /// Little-endian to big-endian
      return buffer[1] +
          buffer[2] * 0x100 +
          buffer[3] * 0x10000 +
          buffer[4] * 0x1000000;

      /// Inverse of what happens in encode
    }
    if (flag != 0) {
      throw XRPLAddressCodecException("Flag must be zero to indicate no tag");
    }
    if (!bytesListEqual(
        Uint8List.fromList([0, 0, 0, 0, 0, 0, 0, 0]), buffer.sublist(1, 9))) {
      throw XRPLAddressCodecException("Remaining bytes must be zero");
    }
    return null;
  }

  /// These methods deal with X-Addresses and their encoding and decoding.

  /// Prefix bytes for Main and Test networks
  static final _PREFIX_BYTES_MAIN = Uint8List.fromList([0x05, 0x44]);

  /// 5, 68
  static final _PREFIX_BYTES_TEST = Uint8List.fromList([0x04, 0x93]);

  /// Maximum 32-bit unsigned integer value
  static const int MAX_32_BIT_UNSIGNED_INT = 0xFFFFFFFF;

  /// Check if the provided bytes correspond to a Test network address.
  static bool isTestAddress(Uint8List bytes) {
    if (bytesListEqual(bytes, _PREFIX_BYTES_MAIN)) {
      return false;
    } else if (bytesListEqual(bytes, _PREFIX_BYTES_TEST)) {
      return true;
    }
    throw XRPLAddressCodecException('Invalid Prefix address');
  }

  /// Convert a Classic Address to an X-Address with an optional tag and network flag.
  static String toXAddress(String address,
      {int? tag, bool isTestNetwork = false}) {
    /// Decode the Classic Address.
    Uint8List classicAddressBytes = decodeClassicAddress(address);

    /// Check if the Classic Address has the expected length.
    if (classicAddressBytes.length != 20) {
      throw ArgumentError("Account ID must be 20 bytes");
    }

    /// Validate and set the tag.
    if (tag != null && tag > MAX_32_BIT_UNSIGNED_INT) {
      throw ArgumentError("Invalid tag");
    }
    bool flag = tag != null;
    tag ??= 0;

    /// Determine the prefix bytes based on the network.
    Uint8List prefixBytes =
        isTestNetwork ? _PREFIX_BYTES_TEST : _PREFIX_BYTES_MAIN;

    /// Create the byte string by combining prefix, Classic Address, and encoded tag.
    Uint8List bytestring =
        Uint8List.fromList([...prefixBytes, ...classicAddressBytes]);
    Uint8List encodedTag = Uint8List.fromList([
      flag ? 1 : 0,
      tag & 0xFF,
      (tag >> 8) & 0xFF,
      (tag >> 16) & 0xFF,
      (tag >> 24) & 0xFF,
      0,
      0,
      0,
      0,
    ]);
    bytestring = Uint8List.fromList([...bytestring, ...encodedTag]);

    /// Encode the byte string into an X-Address and return it.
    return bs58.encodeCheck(Uint8List.fromList(bytestring),
        alphabet: bs58.ripple);
  }
}
