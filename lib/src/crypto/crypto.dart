library bitcoin_crypto;

import 'package:pointycastle/export.dart';
import "dart:typed_data";

/// ignore: implementation_imports
import 'package:pointycastle/src/platform_check/platform_check.dart'
    as platform;

/// Computes the RIPEMD160 hash of the given [buffer] after applying SHA-256 hash.
///
/// This function first applies the SHA-256 hash to the [buffer] and then computes
/// the RIPEMD160 hash of the result.
///
/// Returns a [Uint8List] containing the RIPEMD160 hash.
Uint8List hash160(Uint8List buffer) {
  /// Apply SHA-256 hash to the buffer
  Uint8List tmp = SHA256Digest().process(buffer);

  /// Compute the RIPEMD160 hash of the SHA-256 result
  return RIPEMD160Digest().process(tmp);
}

/// Computes the SHA-512 hash of the given [data].
///
/// This function calculates the SHA-512 hash of the provided [data] and returns
/// the result as a [Uint8List].
///
/// Returns a [Uint8List] containing the SHA-512 hash.
Uint8List hash512(Uint8List data) {
  return SHA512Digest().process(data);
}

/// Computes the first 32 bytes of the SHA-512 hash of the given [data].
///
/// This function calculates the SHA-512 hash of the provided [data] and returns
/// the first 32 bytes of the hash as a [Uint8List].
///
/// Returns a [Uint8List] containing the first 32 bytes of the SHA-512 hash.
Uint8List hash512Half(Uint8List data) {
  final sha512 = hash512(data);
  return sha512.sublist(0, 32);
}

FortunaRandom? _randomGenerator;

/// Generates a random [Uint8List] of the specified [size].
///
/// This function generates a random [Uint8List] of the specified [size] using
/// the Fortuna cryptographic random number generator. If the [_randomGenerator]
/// instance is not yet initialized, it is seeded with platform entropy.
///
/// Returns a [Uint8List] containing random bytes of the specified [size].
Uint8List generateRandom(int size) {
  if (_randomGenerator == null) {
    _randomGenerator = FortunaRandom();
    _randomGenerator!.seed(KeyParameter(
        platform.Platform.instance.platformEntropySource().getBytes(32)));
  }

  final randomBytes = _randomGenerator!.nextBytes(size);

  return randomBytes;
}
