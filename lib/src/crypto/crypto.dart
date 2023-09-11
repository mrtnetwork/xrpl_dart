library bitcoin_crypto;

import 'dart:convert';
import 'package:pointycastle/export.dart';
import "dart:typed_data";
// ignore: implementation_imports
import 'package:pointycastle/src/platform_check/platform_check.dart'
    as platform;

Uint8List hash160(Uint8List buffer) {
  Uint8List tmp = SHA256Digest().process(buffer);
  return RIPEMD160Digest().process(tmp);
}

Uint8List hmacSHA512(Uint8List key, Uint8List data) {
  final tmp = HMac(SHA512Digest(), 128)..init(KeyParameter(key));
  return tmp.process(data);
}

Uint8List hash512(Uint8List data) {
  return SHA512Digest().process(data);
}

Uint8List hash512Half(Uint8List data) {
  return SHA512Digest().process(data).sublist(0, 32);
}

Uint8List doubleHash(Uint8List buffer) {
  Uint8List tmp = SHA256Digest().process(buffer);
  return SHA256Digest().process(tmp);
}

Uint8List singleHash(Uint8List buffer) {
  Uint8List tmp = SHA256Digest().process(buffer);
  return tmp;
}

FortunaRandom? _randomGenerator;
Uint8List generateRandom(int size) {
  if (_randomGenerator == null) {
    _randomGenerator = FortunaRandom();
    _randomGenerator!.seed(KeyParameter(
        platform.Platform.instance.platformEntropySource().getBytes(32)));
  }

  final r = _randomGenerator!.nextBytes(size);

  return r;
}

Uint8List keccakAscii(String input) {
  return keccak256(ascii.encode(input));
}

final KeccakDigest _keccakDigest = KeccakDigest(256);

Uint8List keccak256(Uint8List input) {
  _keccakDigest.reset();
  return _keccakDigest.process(input);
}

Uint8List pbkdfDeriveDigest(String mnemonic, String salt) {
  final toBytesSalt = Uint8List.fromList(utf8.encode(salt));
  final derive = PBKDF2KeyDerivator(HMac(SHA512Digest(), 128));
  derive.reset();
  derive.init(Pbkdf2Parameters(toBytesSalt, 2048, 64));
  return derive.process(Uint8List.fromList(mnemonic.codeUnits));
}
