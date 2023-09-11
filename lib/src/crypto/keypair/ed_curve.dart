import 'dart:typed_data';
import 'package:xrp_dart/src/formating/bytes_num_formating.dart';

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

(BigInt, BigInt, BigInt, BigInt) _aff2ext(BigInt x, BigInt y, BigInt q) {
  BigInt z = BigInt.one;
  final t = (x * y * z) % q;
  x = (x * z) % q;
  y = (y * z) % q;
  return (x, y, z, t);
}

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

EDPoint _ext2aff(BigInt x, BigInt y, BigInt z, BigInt xy, BigInt q) {
  final invz = z.modPow(q - BigInt.two, q);
  x = (x * invz) % q;
  y = (y * invz) % q;
  return EDPoint(x, y);
}

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

Uint8List bigIntToLittleEndianBytes(BigInt number, int size) {
  final bytes = List<int>.filled(size, 0);

  for (int i = 0; i < size; i++) {
    bytes[i] = number.toUnsigned(8).toInt();
    number >>= 8;
  }

  return Uint8List.fromList(bytes);
}

BigInt liteEddianToBigInt(Uint8List bytes) {
  BigInt result = BigInt.zero;
  for (int i = bytes.length - 1; i >= 0; i--) {
    result = result << 8 | BigInt.from(bytes[i]);
  }
  return result;
}

class EDCurve {
  static final BigInt field = BigInt.parse(
      "7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed",
      radix: 16);
  static final BigInt d = BigInt.parse(
      "52036cee2b6ffe738cc740797779e89800700a4d4141d8ab75eb4dca135978a3",
      radix: 16);
  static final BigInt a = BigInt.from(-1);
  static final BigInt order = BigInt.parse(
      "1000000000000000000000000000000014DEF9DEA2F79CD65812631A5CF5D3ED",
      radix: 16);
  static final EDPoint generator = EDPoint(
      BigInt.parse(
          "15112221349535400772501151409588531511454012693041857206046113283949847762202"),
      BigInt.parse(
          "46316835694926478169428394003475163141307993866256225615783033603165251855960"));
}

class EDPoint {
  EDPoint(this.x, this.y);
  final BigInt x;
  final BigInt y;
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

  static final EDPoint infinity = EDPoint(BigInt.from(0), BigInt.from(0));
  Uint8List encodePoint() {
    int size = 32;
    List<int> bytes = bigIntToLittleEndianBytes(y, size);
    if (x.isOdd) {
      bytes[bytes.length - 1] |= 0x80;
    }
    return Uint8List.fromList(bytes);
  }

  static EDPoint decodePoint(Uint8List data) {
    final yData = Uint8List.fromList(data);
    int sign = yData[yData.length - 1] & 0x80;
    yData[yData.length - 1] &= ~0x80;
    final yPoint = liteEddianToBigInt(yData);
    return EDPoint(_xRecover(yPoint, sign), yPoint);
  }

  EDPoint operator *(BigInt k) {
    return _mulPoint(k);
  }

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
