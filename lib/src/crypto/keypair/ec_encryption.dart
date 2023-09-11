import 'package:xrp_dart/src/crypto/crypto.dart';
import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/formating/der.dart'
    show decodeDERToListBigInt, listBigIntToDER;
import 'package:flutter/foundation.dart';
import "package:pointycastle/ecc/curves/secp256k1.dart" show ECCurve_secp256k1;
import "package:pointycastle/api.dart"
    show PrivateKeyParameter, PublicKeyParameter;
import 'package:pointycastle/ecc/api.dart'
    show ECPrivateKey, ECPublicKey, ECSignature, ECPoint;

import "package:pointycastle/signers/ecdsa_signer.dart" show ECDSASigner;
import 'package:pointycastle/macs/hmac.dart';
import "package:pointycastle/digests/sha256.dart";
import 'ec_curve.dart' as ec;

final _zero32 = Uint8List.fromList(List.generate(32, (index) => 0));
final _ecGroupOrder = hexToBytes(
    "fffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141");
final _ecp = hexToBytes(
    "fffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f");
final secp256k1 = ECCurve_secp256k1();
final n = secp256k1.n;
final G = secp256k1.G;
BigInt nDiv2 = n >> 1;

bool isPrivate(Uint8List x) {
  if (!isScalar(x)) return false;
  return _compare(x, _zero32) > 0 && // > 0
      _compare(x, _ecGroupOrder) < 0; // < G
}

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

bool isScalar(Uint8List x) {
  return x.length == 32;
}

bool isOrderScalar(x) {
  if (!isScalar(x)) return false;
  return _compare(x, _ecGroupOrder) < 0; // < G
}

bool isSignature(Uint8List value) {
  Uint8List r = value.sublist(0, 32);
  Uint8List s = value.sublist(32, 64);

  return value.length == 64 &&
      _compare(r, _ecGroupOrder) < 0 &&
      _compare(s, _ecGroupOrder) < 0;
}

bool _isPointCompressed(Uint8List p) {
  return p[0] != 0x04;
}

Uint8List? pointFromScalar(Uint8List d, bool compress) {
  if (!isPrivate(d)) throw ArgumentError("Bad Private");
  BigInt dd = decodeBigInt(d);
  ECPoint pp = (G * dd) as ECPoint;
  if (pp.isInfinity) return null;
  return pp.getEncoded(compress);
}

Uint8List signDer(Uint8List hash, Uint8List x) {
  if (!isScalar(hash)) throw ArgumentError("Bad hash");
  if (!isPrivate(x)) throw ArgumentError("Bad Private");
  ECSignature sig = _deterministicGenerateK(hash, x);
  BigInt s;
  if (sig.s.compareTo(nDiv2) > 0) {
    s = n - sig.s;
  } else {
    s = sig.s;
  }

  return listBigIntToDER([sig.r, s]);
}

Uint8List decodeDerSignatur(Uint8List derSignature) {
  final tobigint = decodeDERToListBigInt(derSignature);
  final r = padUint8ListTo32(_encodeBigInt(tobigint.first));
  final s = padUint8ListTo32(_encodeBigInt(tobigint.last));
  return Uint8List.fromList([...r, ...s]);
}

bool verify(Uint8List hash, Uint8List q, Uint8List signature) {
  if (!isScalar(hash)) throw ArgumentError("Bad hash");
  if (!isPoint(q)) throw ArgumentError("Bad Point");
  if (!isSignature(signature)) throw ArgumentError("Bad signatur");
  ECPoint? Q = _decodeFrom(q);
  BigInt r = decodeBigInt(signature.sublist(0, 32));
  BigInt s = decodeBigInt(signature.sublist(32, 64));
  final signer = ECDSASigner(null, HMac(SHA256Digest(), 64));
  signer.init(false, PublicKeyParameter(ECPublicKey(Q, secp256k1)));
  return signer.verifySignature(hash, ECSignature(r, s));
}

ECPoint? _decodeFrom(Uint8List P) {
  return secp256k1.curve.decodePoint(P);
}

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

ECSignature _deterministicGenerateK(Uint8List hash, Uint8List x) {
  final signer = ec.CustomECDSASigner(null, HMac(SHA256Digest(), 64), null);

  final ds = decodeBigInt(x);
  var pkp = PrivateKeyParameter(ECPrivateKey(ds, secp256k1));
  signer.init(true, pkp);
  final sig = signer.generateSignature(hash) as ECSignature;
  return sig;
}

int _compare(Uint8List a, Uint8List b) {
  BigInt aa = decodeBigInt(a);
  BigInt bb = decodeBigInt(b);
  if (aa == bb) return 0;
  if (aa > bb) return 1;
  return -1;
}

BigInt decodeBigInt(List<int> bytes) {
  BigInt result = BigInt.from(0);
  for (int i = 0; i < bytes.length; i++) {
    result += BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
  }
  return result;
}

/// Encode a BigInt into bytes using big-endian encoding.
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

Uint8List deriveKeyPair(String seed) {
  final Uint8List bytes = hexToBytes(seed);
  final Uint8List root = _getSecret(bytes);
  final Uint8List pub = pointFromScalar(root, true)!;
  // ECPrivate.fromBytes(root).getPublic().toCompressedBytes();
  final Uint8List mid = _getSecret(pub, isMid: true);
  final BigInt rootD = decodeBigInt(root);
  final BigInt midD = decodeBigInt(mid);
  final BigInt finalPair = (rootD + midD) % n;
  return _encodeBigInt(finalPair);
}

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
