// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'dart:typed_data';

import "package:xrp_dart/src/base58/base58.dart" as bs58;
import 'package:xrp_dart/src/formating/bytes_num_formating.dart';

import 'exception/exceptions.dart';

enum CryptoAlgorithm {
  ED25519(0xED),
  SECP256K1(0x00);

  final int value;
  const CryptoAlgorithm(this.value);
}

class XRPAddressUtilities {
  static final List<int> _CLASSIC_ADDRESS_PREFIX = [0x0];
  static final List<int> _ACCOUNT_PUBLIC_KEY_PREFIX = [0x23];
  static final List<int> _FAMILY_SEED_PREFIX = [0x21];
  static final List<int> _NODE_PUBLIC_KEY_PREFIX = [0x1C];
  static final List<int> _ED25519_SEED_PREFIX = [0x01, 0xE1, 0x4B];

  static const int SEED_LENGTH = 16;
  static const int CLASSIC_ADDRESS_LENGTH = 20;
  static const int NODE_PUBLIC_KEY_LENGTH = 33;
  static const int ACCOUNT_PUBLIC_KEY_LENGTH = 33;

  static final Map<CryptoAlgorithm, List<List<int>>> _ALGORITHM_TO_PREFIX_MAP =
      {
    CryptoAlgorithm.ED25519: [_ED25519_SEED_PREFIX, _FAMILY_SEED_PREFIX],
    CryptoAlgorithm.SECP256K1: [_FAMILY_SEED_PREFIX],
  };

  static String _encode(
      Uint8List bytestring, List<int> prefix, int expectedLength) {
    if (expectedLength != 0 && bytestring.length != expectedLength) {
      throw XRPLAddressCodecException(
          'unexpected_payload_length: len(bytestring) does not match expected_length. Ensure that the bytes are a bytestring.');
    }

    final encodedPrefix = Uint8List.fromList(prefix);
    final payload = Uint8List.fromList(encodedPrefix + bytestring);
    return bs58.xrplBase58.encodeCheck(payload);
  }

  static Uint8List _decode(String b58String, Uint8List prefix) {
    final prefixLength = prefix.length;
    final decoded = bs58.xrplBase58.decodeCheck(b58String);
    if (!bytesListEqual(decoded.sublist(0, prefixLength), prefix)) {
      throw XRPLAddressCodecException('Provided prefix is incorrect');
    }
    return Uint8List.fromList(decoded.sublist(prefixLength));
  }

  static String encodeSeed(Uint8List entropy, CryptoAlgorithm encodingType) {
    if (entropy.length != SEED_LENGTH) {
      throw XRPLAddressCodecException('Entropy must have length $SEED_LENGTH');
    }

    if (!_ALGORITHM_TO_PREFIX_MAP.containsKey(encodingType)) {
      throw XRPLAddressCodecException(
          'Encoding type must be one of CryptoAlgorithm');
    }

    final prefix = _ALGORITHM_TO_PREFIX_MAP[encodingType]![0];
    return _encode(entropy, prefix, SEED_LENGTH);
  }

  static (Uint8List, CryptoAlgorithm) decodeSeed(String seed,
      [CryptoAlgorithm? algorithm]) {
    if (algorithm != null) {
      for (final prefix in _ALGORITHM_TO_PREFIX_MAP[algorithm]!) {
        try {
          final decodedResult = _decode(seed, Uint8List.fromList(prefix));
          return (decodedResult, algorithm);
        } catch (e) {
          // Prefix is incorrect, wrong prefix
          continue;
        }
      }
      throw XRPLAddressCodecException('Wrong algorithm for the seed type.');
    }

    for (final algorithm in CryptoAlgorithm.values) {
      final prefix = _ALGORITHM_TO_PREFIX_MAP[algorithm]![0];
      try {
        final decodedResult = _decode(seed, Uint8List.fromList(prefix));
        return (decodedResult, algorithm);
      } catch (e) {
        // Prefix is incorrect, wrong algorithm
        continue;
      }
    }
    throw XRPLAddressCodecException(
        'Invalid seed; could not determine encoding algorithm');
  }

  static String encodeClassicAddress(Uint8List bytestring) {
    return _encode(bytestring, _CLASSIC_ADDRESS_PREFIX, CLASSIC_ADDRESS_LENGTH);
  }

  static Uint8List decodeClassicAddress(String classicAddress) {
    return _decode(classicAddress, Uint8List.fromList(_CLASSIC_ADDRESS_PREFIX));
  }

  static String encodeNodePublicKey(Uint8List bytestring) {
    return _encode(bytestring, _NODE_PUBLIC_KEY_PREFIX, NODE_PUBLIC_KEY_LENGTH);
  }

  static Uint8List decodeNodePublicKey(String nodePublicKey) {
    return _decode(nodePublicKey, Uint8List.fromList(_NODE_PUBLIC_KEY_PREFIX));
  }

  static String encodeAccountPublicKey(Uint8List bytestring) {
    return _encode(
        bytestring, _ACCOUNT_PUBLIC_KEY_PREFIX, ACCOUNT_PUBLIC_KEY_LENGTH);
  }

  static Uint8List decodeAccountPublicKey(String accountPublicKey) {
    return _decode(
        accountPublicKey, Uint8List.fromList(_ACCOUNT_PUBLIC_KEY_PREFIX));
  }

  static bool isValidClassicAddress(String classicAddress) {
    try {
      decodeClassicAddress(classicAddress);
      return true;
    } catch (e) {
      return false;
    }
  }

  static bool isValidXAddress(String classicAddress) {
    try {
      xAddressToClassicAddress(classicAddress);
      return true;
    } catch (e) {
      return false;
    }
  }

  static String toCalssicAddress(String address) {
    if (isValidClassicAddress(address)) return address;
    final decoded = bs58.xrplBase58.decodeCheck(address);
    final classicAddressBytes = decoded.sublist(2, 22);
    final classicAddress = encodeClassicAddress(classicAddressBytes);
    return classicAddress;
  }

  static (String, int?, bool) xAddressToClassicAddress(String xAddress) {
    final decoded = bs58.xrplBase58.decodeCheck(xAddress);
    final isTestNetwork = isTestAddress(decoded.sublist(0, 2));
    final classicAddressBytes = decoded.sublist(2, 22);
    final tag = getTagFromBuffer(decoded.sublist(22));

    final classicAddress = encodeClassicAddress(classicAddressBytes);
    return (classicAddress, tag, isTestNetwork);
  }

  static int? getTagFromBuffer(Uint8List buffer) {
    int flag = buffer[0];
    if (flag >= 2) {
      throw XRPLAddressCodecException("Unsupported X-Address");
    }
    if (flag == 1) {
      // Little-endian to big-endian
      return buffer[1] +
          buffer[2] * 0x100 +
          buffer[3] * 0x10000 +
          buffer[4] * 0x1000000; // Inverse of what happens in encode
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

  static final _PREFIX_BYTES_MAIN = Uint8List.fromList([0x05, 0x44]); // 5, 68
  static final _PREFIX_BYTES_TEST = Uint8List.fromList([0x04, 0x93]);
  static const int MAX_32_BIT_UNSIGNED_INT = 0xFFFFFFFF;
  static bool isTestAddress(Uint8List bytes) {
    if (bytesListEqual(bytes, _PREFIX_BYTES_MAIN)) {
      return false;
    } else if (bytesListEqual(bytes, _PREFIX_BYTES_TEST)) {
      return true;
    }
    throw XRPLAddressCodecException('Invalid PRefix address');
  }

  static String toXAddress(String address,
      {int? tag, bool isTestNetwork = false}) {
    Uint8List classicAddressBytes = decodeClassicAddress(address);
    if (classicAddressBytes.length != 20) {
      throw ArgumentError("Account ID must be 20 bytes");
    }

    if (tag != null && tag > MAX_32_BIT_UNSIGNED_INT) {
      throw ArgumentError("Invalid tag");
    }

    bool flag = tag != null;
    tag ??= 0;

    Uint8List prefixBytes =
        isTestNetwork ? _PREFIX_BYTES_TEST : _PREFIX_BYTES_MAIN;
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

    return bs58.xrplBase58.encodeCheck(Uint8List.fromList(bytestring));
  }
}
