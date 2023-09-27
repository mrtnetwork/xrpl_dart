import 'dart:typed_data';

import 'package:xrp_dart/src/crypto/crypto.dart';
import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/formating/der.dart'
    show decodeDERToListBigInt, listBigIntToDER;
import "package:pointycastle/ecc/curves/secp256k1.dart" show ECCurve_secp256k1;
import "package:pointycastle/api.dart"
    show PrivateKeyParameter, PublicKeyParameter;
import 'package:pointycastle/ecc/api.dart'
    show ECPrivateKey, ECPublicKey, ECSignature, ECPoint;

import "package:pointycastle/signers/ecdsa_signer.dart" show ECDSASigner;
import 'package:pointycastle/macs/hmac.dart';
import "package:pointycastle/digests/sha256.dart";
import 'ec_curve.dart' as ec;

final _zero32 = Uint8List(0);
final _ecGroupOrder = hexToBytes(
    "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141");
final _ecp = hexToBytes(
    "fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f");
final secp256k1 = ECCurve_secp256k1();
final n = secp256k1.n;
final G = secp256k1.G;
BigInt nDiv2 = n >> 1;

/// Check if a Uint8List represents a valid private key.
///
/// This function checks if the input Uint8List represents a valid private key.
///
/// - [x]: The input Uint8List to check.
///
/// Returns:
/// `true` if the input represents a valid private key, `false` otherwise.
bool isPrivate(Uint8List x) {
  if (!isScalar(x)) return false;
  return _compare(x, _zero32) > 0 &&

      /// > 0
      _compare(x, _ecGroupOrder) < 0;

  /// < G
}

/// Generate a tweaked private key from a given private key and tweak value.
///
/// This function generates a tweaked private key by adding a tweak value to the
/// original private key. It performs necessary checks and ensures the resulting
/// key is valid.
///
/// - [point]: The original private key as a Uint8List.
/// - [tweak]: The tweak value as a Uint8List.
///
/// Returns:
/// A Uint8List representing the tweaked private key if successful, or `null` if
/// the input values are invalid.
Uint8List? generateTweek(Uint8List point, Uint8List tweak) {
  if (!isPrivate(point)) throw ArgumentError("Bad Private");
  if (!isOrderScalar(tweak)) throw ArgumentError("Bad Tweek");
  BigInt dd = decodeBigInt(point);
  BigInt tt = decodeBigInt(tweak);
  Uint8List dt = _encodeBigInt((dd + tt) % n);

  if (dt.length < 32) {
    Uint8List padLeadingZero = Uint8List(32 - dt.length);
    dt = Uint8List.fromList(padLeadingZero + dt);
  }

  if (!isPrivate(dt)) return null;
  return dt;
}

/// Check if a Uint8List represents a valid elliptic curve point.
///
/// This function checks whether a Uint8List [p] represents a valid elliptic curve point
/// on the secp256k1 curve. It performs various checks on the point encoding and structure.
///
/// - [p]: The Uint8List to check.
///
/// Returns:
/// `true` if [p] is a valid elliptic curve point, `false` otherwise.
bool isPoint(Uint8List p) {
  if (p.length < 33) {
    return false;
  }
  var t = p[0];
  var x = p.sublist(1, 33);

  if (_compare(x, _zero32) == 0) {
    return false;
  }
  if (_compare(x, _ecp) == 1) {
    return false;
  }
  try {
    _decodeFrom(p);
  } catch (err) {
    return false;
  }
  if ((t == 0x02 || t == 0x03) && p.length == 33) {
    return true;
  }
  var y = p.sublist(33);
  if (_compare(y, _zero32) == 0) {
    return false;
  }
  if (_compare(y, _ecp) == 1) {
    return false;
  }
  if (t == 0x04 && p.length == 65) {
    return true;
  }
  return false;
}

/// Check if a Uint8List represents a scalar value.
///
/// This function checks whether a Uint8List [x] represents a scalar value
/// by verifying that its length is exactly 32 bytes.
///
/// - [x]: The Uint8List to check.
///
/// Returns:
/// `true` if [x] is a valid scalar value, `false` otherwise.
bool isScalar(Uint8List x) {
  return x.length == 32;
}

/// Check if a Uint8List represents a scalar value less than the curve order.
///
/// This function checks whether a Uint8List [x] represents a scalar value
/// less than the secp256k1 curve order.
///
/// - [x]: The Uint8List to check.
///
/// Returns:
/// `true` if [x] is a valid scalar value less than the curve order, `false` otherwise.
bool isOrderScalar(x) {
  if (!isScalar(x)) return false;
  return _compare(x, _ecGroupOrder) < 0;

  /// < G
}

/// Check if a Uint8List represents a valid ECDSA signature.
///
/// This function checks whether a Uint8List [value] represents a valid ECDSA
/// signature by ensuring it is exactly 64 bytes in length and that both the
/// `r` and `s` components of the signature are less than the secp256k1 curve order.
///
/// - [value]: The Uint8List to check.
///
/// Returns:
/// `true` if [value] is a valid ECDSA signature, `false` otherwise.
bool isSignature(Uint8List value) {
  Uint8List r = value.sublist(0, 32);
  Uint8List s = value.sublist(32, 64);

  return value.length == 64 &&
      _compare(r, _ecGroupOrder) < 0 &&
      _compare(s, _ecGroupOrder) < 0;
}

/// Check if an EC point is compressed.
///
/// This function checks whether an encoded EC point [p] is compressed.
///
/// - [p]: The encoded EC point.
///
/// Returns:
/// `true` if the point is compressed (first byte is not 0x04), `false` otherwise.
bool _isPointCompressed(Uint8List p) {
  return p[0] != 0x04;
}

/// Compute an EC point from a scalar value.
///
/// This function computes an EC point from a scalar value [d] and returns
/// the encoded point as a Uint8List. You can specify whether to compress
/// the point using the [compress] parameter.
///
/// - [d]: The scalar value.
/// - [compress]: Whether to compress the point (default is true).
///
/// Returns:
/// A Uint8List containing the encoded EC point, or null if the point is at infinity.
Uint8List? pointFromScalar(Uint8List d, bool compress) {
  /// Check if the scalar value is valid.
  if (!isPrivate(d)) throw ArgumentError("Bad Private");

  /// Decode the scalar value.
  BigInt dd = decodeBigInt(d);

  /// Compute the EC point using scalar multiplication.
  ECPoint pp = (G * dd) as ECPoint;

  /// Check if the point is at infinity.
  if (pp.isInfinity) return null;

  /// Get the encoded point, optionally compressed.
  return pp.getEncoded(compress);
}

/// Sign a message hash using DER encoding.
///
/// This function signs a message hash ([hash]) using the provided private key ([x])
/// and returns the resulting DER-encoded ECDSA signature as a Uint8List.
///
/// - [hash]: The message hash to sign.
/// - [x]: The private key used for signing.
///
/// Returns:
/// A Uint8List containing the DER-encoded ECDSA signature.
Uint8List signDer(Uint8List hash, Uint8List x) {
  /// Check if the hash and private key are valid.
  if (!isScalar(hash)) throw ArgumentError("Bad hash");
  if (!isPrivate(x)) throw ArgumentError("Bad Private");

  /// Generate a deterministic signature using the hash and private key.
  ECSignature sig = _deterministicGenerateK(hash, x);

  /// Ensure 's' is within the lower half of the curve order.
  BigInt s = (sig.s.compareTo(nDiv2) > 0) ? (n - sig.s) : sig.s;

  /// Encode the 'r' and 's' components into DER format.
  return listBigIntToDER([sig.r, s]);
}

/// Decode a DER-encoded ECDSA signature.
///
/// This function decodes a DER-encoded ECDSA signature in [derSignature] and
/// returns the signature as a 64-byte Uint8List, where the first 32 bytes
/// represent 'r' and the next 32 bytes represent 's'.
///
/// - [derSignature]: The DER-encoded ECDSA signature to decode.
///
/// Returns:
/// A Uint8List containing the decoded signature.
Uint8List decodeDerSignature(Uint8List derSignature) {
  /// Decode the DER-encoded signature to a list of BigInts.
  final toBigInt = decodeDERToListBigInt(derSignature);

  /// Pad and encode the 'r' and 's' components to 32 bytes each.
  final r = padUint8ListTo32(_encodeBigInt(toBigInt.first));
  final s = padUint8ListTo32(_encodeBigInt(toBigInt.last));

  /// Concatenate 'r' and 's' to create the 64-byte signature.
  return Uint8List.fromList([...r, ...s]);
}

/// Verify an ECDSA signature.
///
/// This function verifies an ECDSA signature by taking the hash [hash], the
/// public key point [q], and the signature [signature] as input. It returns
/// `true` if the signature is valid, and `false` otherwise.
///
/// - [hash]: The hash to be verified.
/// - [q]: The public key point.
/// - [signature]: The ECDSA signature to be verified.
///
/// Returns:
/// - `true` if the signature is valid, `false` otherwise.
bool verify(Uint8List hash, Uint8List q, Uint8List signature) {
  /// Check if hash, point, and signature are valid.
  if (!isScalar(hash)) throw ArgumentError("Bad hash");
  if (!isPoint(q)) throw ArgumentError("Bad Point");
  if (!isSignature(signature)) throw ArgumentError("Bad signature");

  /// Decode the public key point.
  ECPoint? Q = _decodeFrom(q);

  /// Extract 'r' and 's' components from the signature.
  BigInt r = decodeBigInt(signature.sublist(0, 32));
  BigInt s = decodeBigInt(signature.sublist(32, 64));

  /// Initialize an ECDSA signer with the public key.
  final signer = ECDSASigner(null, HMac(SHA256Digest(), 64));
  signer.init(false, PublicKeyParameter(ECPublicKey(Q, secp256k1)));

  /// Verify the signature.
  return signer.verifySignature(hash, ECSignature(r, s));
}

/// Decode a point from a Uint8List.
///
/// This function decodes a point from a given [Uint8List] [P] and returns the
/// decoded [ECPoint] if successful, or null if the decoding fails.
///
/// - [P]: The Uint8List representing the point to be decoded.
///
/// Returns:
/// - The decoded [ECPoint] if successful, or null if decoding fails.
ECPoint? _decodeFrom(Uint8List P) {
  /// Use the secp256k1 curve to decode the point.
  return secp256k1.curve.decodePoint(P);
}

/// Re-encodes a point as compressed or uncompressed form.
///
/// This function re-encodes a point represented by the given [p] as either
/// compressed or uncompressed form based on the [compressed] flag.
///
/// - [p]: The point to be re-encoded as a Uint8List.
/// - [compressed]: A boolean flag indicating whether to use compressed form.
///
/// Returns:
/// - A Uint8List representing the re-encoded point.
///
/// Throws:
/// - ArgumentError if the input point [p] is invalid.
Uint8List reEncodedFromForm(Uint8List p, bool compressed) {
  final decode = _decodeFrom(p);
  if (decode == null) {
    throw ArgumentError("Bad point");
  }
  final encode = decode.getEncoded(compressed);
  if (!_isPointCompressed(encode)) {
    return encode.sublist(1, encode.length);
  }

  return encode;
}

/// Generates a deterministic K value for ECDSA signature.
///
/// This function generates a deterministic K value for an ECDSA signature
/// based on the given [hash] and [x] value.
///
/// - [hash]: The hash value for which the K value is generated.
/// - [x]: The private key's x-coordinate as a Uint8List.
///
/// Returns:
/// - An ECSignature representing the generated K value.
ECSignature _deterministicGenerateK(Uint8List hash, Uint8List x) {
  final signer = ec.CustomECDSASigner(null, HMac(SHA256Digest(), 64), null);

  final ds = decodeBigInt(x);
  var pkp = PrivateKeyParameter(ECPrivateKey(ds, secp256k1));
  signer.init(true, pkp);
  final sig = signer.generateSignature(hash) as ECSignature;
  return sig;
}

/// Compares two Uint8List values.
///
/// This function compares two Uint8List values [a] and [b].
///
/// - [a]: The first Uint8List to compare.
/// - [b]: The second Uint8List to compare.
///
/// Returns:
/// - 0 if [a] is equal to [b],
/// - 1 if [a] is greater than [b],
/// - -1 if [a] is less than [b].
int _compare(Uint8List a, Uint8List b) {
  BigInt aa = decodeBigInt(a);
  BigInt bb = decodeBigInt(b);
  if (aa == bb) return 0;
  if (aa > bb) return 1;
  return -1;
}

/// Decodes a list of bytes into a BigInt number.
///
/// This function decodes a list of bytes [bytes] into a BigInt number.
///
/// - [bytes]: The list of bytes to be decoded.
///
/// Returns the decoded BigInt number.
BigInt decodeBigInt(List<int> bytes) {
  BigInt result = BigInt.from(0);
  for (int i = 0; i < bytes.length; i++) {
    result += BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
  }
  return result;
}

/// Encodes a BigInt number as a Uint8List.
///
/// This function encodes a BigInt [number] as a Uint8List. It calculates the minimum
/// number of bytes needed to represent the BigInt and encodes it accordingly.
///
/// - [number]: The BigInt number to be encoded.
///
/// Returns the encoded Uint8List.
Uint8List _encodeBigInt(BigInt number) {
  int needsPaddingByte;
  int rawSize;

  if (number > BigInt.zero) {
    rawSize = (number.bitLength + 7) >> 3;
    needsPaddingByte =
        ((number >> (rawSize - 1) * 8) & BigInt.from(0x80)) == BigInt.from(0x80)
            ? 1
            : 0;

    if (rawSize < 32) {
      needsPaddingByte = 1;
    }
  } else {
    needsPaddingByte = 0;
    rawSize = (number.bitLength + 8) >> 3;
  }

  final size = rawSize < 32 ? rawSize + needsPaddingByte : rawSize;
  var result = Uint8List(size);
  for (int i = 0; i < size; i++) {
    result[size - i - 1] = (number & BigInt.from(0xff)).toInt();
    number = number >> 8;
  }
  return result;
}

/// Derives a key pair (private and public keys) from a given seed.
///
/// This function derives a key pair from a seed represented as a hexadecimal string [seed].
/// It first converts the seed to bytes and computes the root and mid values by combining
/// the seed with brute-forced root values. The public key is then computed from the root
/// value, and a final key pair is derived by adding the root and mid values (mod n).
///
/// - [seed]: The seed value as a hexadecimal string.
///
/// Returns a key pair as a [Uint8List] containing the private key followed by the public key.
Uint8List deriveKeyPair(String seed) {
  final Uint8List bytes = hexToBytes(seed);
  final Uint8List root = _getSecret(bytes);
  final Uint8List pub = pointFromScalar(root, true)!;
  final Uint8List mid = _getSecret(pub, isMid: true);
  final BigInt rootD = decodeBigInt(root);
  final BigInt midD = decodeBigInt(mid);
  final BigInt finalPair = (rootD + midD) % n;
  return _encodeBigInt(finalPair);
}

/// Computes a secret value by combining input data with a brute-forced root value.
///
/// This function iterates through possible root values to create a combination
/// with the input [data]. It checks if the resulting hash is a valid private key
/// (meets certain criteria). If a valid private key is found, it is returned as
/// a [Uint8List]. If no valid private key is found after exhausting all roots,
/// an error is thrown.
///
/// - [data]: The input data to be combined with the root.
/// - [isMid]: A flag indicating whether this is for a mid-state (used internally).
///
/// Returns the computed secret value as a [Uint8List].
///
/// Throws an [ArgumentError] if a valid private key is not found.
Uint8List _getSecret(Uint8List data, {bool isMid = false}) {
  const int sqSize = 4;
  const int sqMax = 256 << (sqSize * 8);
  for (int rawRoot = 0; rawRoot < sqMax; rawRoot++) {
    Uint8List root = Uint8List(sqSize);
    for (int i = 0; i < sqSize; i++) {
      root[i] = (rawRoot >> (8 * (sqSize - 1 - i))) & 0xFF;
    }
    Uint8List combine;
    if (isMid) {
      combine = Uint8List.fromList([
        ...data,
        ...Uint8List.fromList([0, 0, 0, 0]),
        ...root
      ]);
    } else {
      combine = Uint8List.fromList([...data, ...root]);
    }
    final hash = hash512Half(combine);
    if (isPrivate(hash)) {
      return hash;
    }
  }
  throw ArgumentError("error");
}
