import 'dart:typed_data';
import 'package:xrp_dart/src/crypto/crypto.dart';
import 'package:xrp_dart/src/formating/bytes_num_formating.dart';

/// Perform extended point doubling on an elliptic curve.
///
/// This function performs extended point doubling operation on an elliptic curve
/// defined by the parameters q and a. The input coordinates (x1, y1, z1, xy1) represent
/// an affine point P(x1, y1) on the curve, and the result is returned as (x3, y3, z3, xy3).
///
/// - [x1]: x-coordinate of the input point.
/// - [y1]: y-coordinate of the input point.
/// - [z1]: Projective coordinate used for optimization.
/// - [xy1]: Projective coordinate used for optimization.
/// - [q]: The prime order of the elliptic curve field.
/// - [a]: The curve coefficient.
///
/// Returns:
/// A tuple containing the x, y, z, and xy coordinates of the doubled point.
(BigInt, BigInt, BigInt, BigInt) _dblExt(
    BigInt x1, BigInt y1, BigInt z1, BigInt xy1, BigInt q, BigInt a) {
  final A = (x1 * x1) % q;
  final B = (y1 * y1) % q;
  final C = (BigInt.two * z1 * z1) % q;
  final D = (a * A) % q;
  final E = ((x1 + y1) * (x1 + y1) - A - B) % q;
  final G = (D + B) % q;
  final F = (G - C) % q;
  final H = (D - B) % q;
  final x3 = (E * F) % q;
  final y3 = (G * H) % q;
  final xy3 = (E * H) % q;
  final z3 = (F * G) % q;
  return (x3, y3, z3, xy3);
}

/// Convert an affine point to extended coordinates on an elliptic curve.
///
/// This function converts an affine point `(x, y)` on an elliptic curve to
/// extended coordinates `(x, y, z, t)`, where `z` is a projective coordinate
/// and `t` is the cross-product `x * y * z`.
///
/// - [x]: x-coordinate of the affine point.
/// - [y]: y-coordinate of the affine point.
/// - [q]: The prime order of the elliptic curve field.
///
/// Returns:
/// A tuple containing the extended coordinates `(x, y, z, t)`.
(BigInt, BigInt, BigInt, BigInt) _aff2ext(BigInt x, BigInt y, BigInt q) {
  BigInt z = BigInt.one;
  final t = (x * y * z) % q;
  x = (x * z) % q;
  y = (y * z) % q;
  return (x, y, z, t);
}

/// Add two points in extended coordinates on an elliptic curve.
///
/// This function adds two points `(x1, y1, z1, xy1)` and `(x2, y2, z2, xy2)` in
/// extended coordinates on an elliptic curve and returns the result as
/// `(x3, y3, z3, xy3)`.
///
/// - [x1], [y1], [z1], [xy1]: Extended coordinates of the first point.
/// - [x2], [y2], [z2], [xy2]: Extended coordinates of the second point.
/// - [q]: The prime order of the elliptic curve field.
/// - [a]: The curve coefficient 'a' in the curve equation `y^2 = x^3 + a*x + b`.
///
/// Returns:
/// A tuple containing the extended coordinates `(x3, y3, z3, xy3)` of the sum of the two points.
(BigInt, BigInt, BigInt, BigInt) _addExt(
    BigInt x1,
    BigInt y1,
    BigInt z1,
    BigInt xy1,
    BigInt x2,
    BigInt y2,
    BigInt z2,
    BigInt xy2,
    BigInt q,
    BigInt a) {
  final A = (x1 * x2) % q;
  final B = (y1 * y2) % q;
  final C = (z1 * xy2) % q;
  final D = (xy1 * z2) % q;
  final E = (D + C) % q;

  final t0 = (x1 - y1) % q;
  final t1 = (x2 + y2) % q;
  final t2 = (t0 * t1) % q;
  final t3 = (t2 + B) % q;
  final F = (t3 - A) % q;

  final t4 = (a * A) % q;
  final G = (B + t4) % q;
  final H = (D - C) % q;

  final x3 = (E * F) % q;
  final y3 = (G * H) % q;
  final xy3 = (E * H) % q;
  final z3 = (F * G) % q;

  return (x3, y3, z3, xy3);
}

/// Convert an extended point to an affine point on an elliptic curve.
///
/// This function converts an extended point `(x, y, z, xy)` to an affine point
/// `(x, y)` on an elliptic curve, where `q` is the prime order of the elliptic
/// curve field.
///
/// - [x], [y], [z], [xy]: Extended coordinates of the point.
/// - [q]: The prime order of the elliptic curve field.
///
/// Returns:
/// An `EDPoint` object representing the affine coordinates `(x, y)` of the point.
EDPoint _ext2aff(BigInt x, BigInt y, BigInt z, BigInt xy, BigInt q) {
  final invz = z.modPow(q - BigInt.two, q);
  x = (x * invz) % q;
  y = (y * invz) % q;
  return EDPoint(x, y);
}

/// Recover the x-coordinate of a point given its y-coordinate and sign.
///
/// This function recovers the x-coordinate of a point on an elliptic curve
/// given its y-coordinate and a sign bit. It uses the curve parameters `a` and `d`
/// and the prime order `q` from the elliptic curve definition.
///
/// - [y]: The y-coordinate of the point.
/// - [sign]: A sign bit (0 or 1) indicating which x-coordinate to choose.
///
/// Returns:
/// The x-coordinate of the point as a `BigInt`.
BigInt _xRecover(BigInt y, int sign) {
  final q = EDCurve.field;
  final a = EDCurve.a;
  final d = EDCurve.d;
  if (sign != 0) {
    sign = 1;
  }
  BigInt yy = (y * y) % q;
  BigInt u = (BigInt.one - yy) % q;
  BigInt v = (a - d * yy).modPow(q - BigInt.two, q);

  BigInt xx = (u * v) % q;
  BigInt x = bigintPow(xx, (q + BigInt.from(3)) ~/ BigInt.from(8), q);
  if ((x * x - xx) % q != BigInt.zero) {
    BigInt I = bigintPow(BigInt.from(2), (q - BigInt.one) ~/ BigInt.from(4), q);
    x = (x * I) % q;
  }
  if (x.isOdd != (sign != 0)) {
    x = q - x;
  }
  return x;
}

/// Convert a BigInt to little-endian bytes of a specified size.
///
/// - [number]: The BigInt to convert.
/// - [size]: The size of the resulting byte array.
///
/// Returns:
/// A Uint8List containing the little-endian representation of the BigInt.
Uint8List bigIntToLittleEndianBytes(BigInt number, int size) {
  final bytes = List<int>.filled(size, 0);

  for (int i = 0; i < size; i++) {
    bytes[i] = number.toUnsigned(8).toInt();
    number >>= 8;
  }

  return Uint8List.fromList(bytes);
}

/// Convert little-endian bytes to a BigInt.
///
/// - [bytes]: The little-endian byte array to convert.
///
/// Returns:
/// The resulting BigInt.
BigInt liteEddianToBigInt(Uint8List bytes) {
  BigInt result = BigInt.zero;
  for (int i = bytes.length - 1; i >= 0; i--) {
    result = result << 8 | BigInt.from(bytes[i]);
  }
  return result;
}

/// The EDCurve class represents the parameters of the Edwards curve used in cryptography.
class EDCurve {
  /// The finite field prime modulus.
  static final BigInt field = BigInt.parse(
      "7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed",
      radix: 16);

  /// The curve parameter 'd'.
  static final BigInt d = BigInt.parse(
      "52036cee2b6ffe738cc740797779e89800700a4d4141d8ab75eb4dca135978a3",
      radix: 16);

  /// The curve parameter 'a'.
  static final BigInt a = BigInt.from(-1);

  /// The order of the base point on the curve.
  static final BigInt order = BigInt.parse(
      "1000000000000000000000000000000014DEF9DEA2F79CD65812631A5CF5D3ED",
      radix: 16);

  /// The generator point of the curve.
  static final EDPoint generator = EDPoint(
      BigInt.parse(
          "15112221349535400772501151409588531511454012693041857206046113283949847762202"),
      BigInt.parse(
          "46316835694926478169428394003475163141307993866256225615783033603165251855960"));
}

/// Represents a point on an Edwards curve.
class EDPoint {
  EDPoint(this.x, this.y);
  final BigInt x;
  final BigInt y;

  /// Multiplies this point by a scalar [k] and returns a new point.
  EDPoint _mulPoint(BigInt scal) {
    scal = scal % EDCurve.order;
    final q = EDCurve.field;
    final a = EDCurve.a;

    final xx = _aff2ext(x, y, q);
    final binary = scal.toRadixString(2);
    final binarySize = binary.length;
    BigInt x1 = xx.$1;
    BigInt y1 = xx.$2;
    BigInt z1 = xx.$3;
    BigInt t1 = xx.$4;
    final x22 = _dblExt(xx.$1, xx.$2, xx.$3, xx.$4, q, a);
    BigInt x2 = x22.$1;
    BigInt y2 = x22.$2;
    BigInt z2 = x22.$3;
    BigInt t2 = x22.$4;
    for (int i = 1; i < binarySize; i++) {
      if (binary[i] == '1') {
        final addTo = _addExt(x2, y2, z2, t2, x1, y1, z1, t1, q, a);
        x1 = addTo.$1;
        y1 = addTo.$2;
        z1 = addTo.$3;
        t1 = addTo.$4;
        final addXt = _dblExt(x2, y2, z2, t2, q, a);
        x2 = addXt.$1;
        y2 = addXt.$2;
        z2 = addXt.$3;
        t2 = addXt.$4;
      } else {
        final addTo = _addExt(x1, y1, z1, t1, x2, y2, z2, t2, q, a);
        x2 = addTo.$1;
        y2 = addTo.$2;
        z2 = addTo.$3;
        t2 = addTo.$4;
        final addXt = _dblExt(x1, y1, z1, t1, q, a);
        x1 = addXt.$1;
        y1 = addXt.$2;
        z1 = addXt.$3;
        t1 = addXt.$4;
      }
    }
    if (z1 != BigInt.zero) {
      final x2aff = _ext2aff(x1, y1, z1, t1, q);
      return x2aff;
    }
    return infinity;
  }

  /// Adds another point [Q] to this point and returns a new point.
  EDPoint _addPoint(EDPoint Q) {
    final q = EDCurve.field;
    final a = EDCurve.a;

    BigInt x1;
    BigInt y1;
    BigInt z;
    BigInt t;
    if (Q == this) {
      final add1 = _aff2ext(x, y, q);
      final db1 = _dblExt(add1.$1, add1.$2, add1.$3, add1.$4, q, a);
      x1 = db1.$1;
      y1 = db1.$2;
      z = db1.$3;
      t = db1.$4;
    } else {
      final add1 = _aff2ext(x, y, q);
      final add2 = _aff2ext(Q.x, Q.y, q);
      final add3 = _addExt(add1.$1, add1.$2, add1.$3, add1.$4, add2.$1, add2.$2,
          add2.$3, add2.$4, q, a);
      x1 = add3.$1;
      y1 = add3.$2;
      z = add3.$3;
      t = add3.$4;
    }
    if (z != BigInt.zero) {
      return _ext2aff(x1, y1, z, t, q);
    }
    return EDPoint(BigInt.zero, BigInt.zero);
  }

  /// The point at infinity.
  static final EDPoint infinity = EDPoint(BigInt.from(0), BigInt.from(0));

  /// Returns the encoded representation of this point as a Uint8List.
  Uint8List encodePoint() {
    int size = 32;
    List<int> bytes = bigIntToLittleEndianBytes(y, size);
    if (x.isOdd) {
      bytes[bytes.length - 1] |= 0x80;
    }
    return Uint8List.fromList(bytes);
  }

  /// Decodes an encoded point [data] and returns an EDPoint
  static EDPoint decodePoint(Uint8List data) {
    final yData = Uint8List.fromList(data);
    int sign = yData[yData.length - 1] & 0x80;
    yData[yData.length - 1] &= ~0x80;
    final yPoint = liteEddianToBigInt(yData);
    return EDPoint(_xRecover(yPoint, sign), yPoint);
  }

  /// Multiplies this point by a scalar [k] and returns a new point.
  EDPoint operator *(BigInt k) {
    return _mulPoint(k);
  }

  /// Adds another point [b] to this point and returns a new point.
  EDPoint operator +(EDPoint b) {
    return _addPoint(b);
  }

  @override
  operator ==(other) {
    if (other is! EDPoint) return false;
    return x == other.x && y == other.y;
  }

  @override
  int get hashCode => Object.hash(x, y);
}

/// Derive material from an Edwards curve private key.
///
/// Parameters:
/// - [privateKey]: The private key as a Uint8List.
///
/// Returns:
/// - A tuple containing the public key as a Uint8List, the prefix as a Uint8List,
///   and the derived BigInt value.
(Uint8List, Uint8List, BigInt) getMaterial(Uint8List privateKey) {
  /// Calculate the hash digest of the private key.
  final digest = hash512(privateKey);

  /// Extract the first 32 bytes as 'a'.
  final a = digest.sublist(0, 32);

  /// Extract the remaining bytes as 'prefix'.
  final prefix = digest.sublist(32);

  /// Adjust the first byte of 'a' and the last byte to satisfy curve requirements.
  a[0] &= 0xF8;
  a[31] = (a[31] & 0x7F) | 0x40;

  /// Convert 'a' to a BigInt.
  final aB = liteEddianToBigInt(a);

  /// Calculate the public key using 'a'.
  final mul = EDCurve.generator * aB;
  final publicKey = mul.encodePoint();

  /// Return the tuple containing the public key, prefix, and 'a' as a BigInt.
  return (publicKey, prefix, aB);
}

/// Sign a message using an Edwards curve private key.
///
/// Parameters:
/// - [hexMessage]: The hexadecimal representation of the message to sign.
/// - [privateKey]: The private key as a Uint8List.
///
/// Returns:
/// - The hexadecimal representation of the signature.
String signED(String hexMessage, Uint8List privateKey) {
  /// Derive material from the private key.
  final mt = getMaterial(privateKey);

  /// Convert the message to bytes and combine it with material.$2.
  final message = hexToBytes(hexMessage);
  final combine = Uint8List.fromList([...mt.$2, ...message]);

  /// Calculate the hash digest and convert it to a BigInt.
  final hashDigest = hash512(combine);
  BigInt r = liteEddianToBigInt(hashDigest);
  r = r % EDCurve.order;

  /// Calculate R and encode it to bytes.
  final R = EDCurve.generator * r;
  final eR = R.encodePoint();

  /// Combine R, material.$1, and the message for the second hash.
  final combine2 = hash512(Uint8List.fromList([...eR, ...mt.$1, ...message]));

  /// Convert the second hash to a BigInt and calculate S.
  final i = liteEddianToBigInt(combine2);
  final S = (r + i * mt.$3) % EDCurve.order;

  /// Encode the R and S components as little-endian bytes.
  final eRB = liteEddianToBigInt(eR);
  final Uint8List encodedDigest = Uint8List.fromList([
    ...bigIntToLittleEndianBytes(eRB, 32),
    ...bigIntToLittleEndianBytes(S, 32)
  ]);

  /// Convert the encoded signature to a hexadecimal string.
  return bytesToHex(encodedDigest);
}

/// Verify an Edwards curve signature for a given message using a public key.
///
/// Parameters:
/// - [messageHex]: The hexadecimal representation of the message.
/// - [signatureHex]: The hexadecimal representation of the signature.
/// - [publicKey]: The public key as a Uint8List.
///
/// Returns:
/// - `true` if the signature is valid for the given message and public key, `false` otherwise.
bool verifyEDBlob(String messageHex, String signatureHex, Uint8List publicKey) {
  /// Convert message and signature from hexadecimal strings to Uint8List.
  final message = hexToBytes(messageHex);
  final signature = hexToBytes(signatureHex);

  /// Decode the provided public key.
  final decodePublic = EDPoint.decodePoint(publicKey);

  /// Check if the length of the signature is even.
  int len = signature.length;
  if (len.isOdd) {
    return false;
  }

  /// Divide the signature into two equal parts.
  len = len >> 1;
  final eR = liteEddianToBigInt(signature.sublist(0, len));
  final S = liteEddianToBigInt(signature.sublist(len));
  final eRB = bigIntToLittleEndianBytes(eR, 32);
  final R = EDPoint.decodePoint(eRB);

  /// Encode the public key and calculate the combined hash.
  final eA = decodePublic.encodePoint();
  final combine = hash512(Uint8List.fromList([...eRB, ...eA, ...message]));

  /// Convert the combined hash to a BigInt.
  BigInt h = liteEddianToBigInt(combine);
  h = h % EDCurve.order;

  /// Calculate points A and B for verification.
  final A = decodePublic * h;
  final left = A + R;
  final right = EDCurve.generator * S;

  /// Verify the signature by comparing points.
  return right == left;
}
