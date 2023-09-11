// ignore_for_file: unused_field

library hd_wallet;

import 'dart:convert';
import 'dart:typed_data';
import 'package:xrp_dart/src/crypto/crypto.dart';
import 'package:xrp_dart/src/bip39/bip39_base.dart';
import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/crypto/keypair/ec_encryption.dart' as ec;

enum WalletType { ed25519, secp256k1 }

class HdWallet {
  static const String bitcoinKey = "Bitcoin seed";
  static const String ed25519Key = "ed25519 seed";
  HdWallet._base(
    this._private,
    this._public,
    this._chainCode,
  ) : isMaster = true;
  int _depth = 0;
  int _index = 0;
  int get index => _index;
  int get depth => _depth;
  Uint8List _fingerPrint = Uint8List(4);
  Uint8List get fingerPrint => _fingerPrint;
  final bool isMaster;
  HdWallet._child(this._private, this._public, this._chainCode, this._depth,
      this._index, this._fingerPrint)
      : isMaster = false;
  factory HdWallet.fromMnemonic(String mnemonic,
      {String passphrase = "", String key = bitcoinKey}) {
    final seed = BIP39.toSeed(mnemonic, passphrase: passphrase);
    if (seed.length < 16) {
      throw ArgumentError("Seed should be at least 128 bits");
    }
    if (seed.length > 64) {
      throw ArgumentError("Seed should be at most 512 bits");
    }

    final hash = hmacSHA512(utf8.encode(key) as Uint8List, seed);
    final private = hash.sublist(0, 32);
    final chainCode = hash.sublist(32);
    final compressedPub = ec.pointFromScalar(private, true);
    final wallet = HdWallet._base(private, compressedPub!, chainCode);
    return wallet;
  }

  Uint8List _private;
  Uint8List get private => _private;
  Uint8List _public;

  final Uint8List _chainCode;
  String chainToHex() {
    return bytesToHex(_chainCode);
  }

  static const _highBit = 0x80000000;
  static const _maxUint31 = 2147483647;
  static const _maxUint32 = 4294967295;
  HdWallet _addDrive(int index) {
    if (index > _maxUint32 || index < 0) throw ArgumentError("Expected UInt32");
    final isHardened = index >= _highBit;
    Uint8List data = Uint8List(37);

    if (isHardened) {
      data[0] = 0x00;
      data.setRange(1, 33, _private);
      data.buffer.asByteData().setUint32(33, index);
    } else {
      final compressedPub = ec.pointFromScalar(_private, true);
      data.setRange(0, 33, compressedPub!);
      data.buffer.asByteData().setUint32(33, index);
    }
    final I = hmacSHA512(_chainCode, data);
    final il = I.sublist(0, 32);
    final ir = I.sublist(32);
    if (!ec.isPrivate(il)) {
      return _addDrive(index + 1);
    }
    final newPrivate = ec.generateTweek(_private, il);
    final childDeph = depth + 1;
    final childIndex = index;
    final previusPUb = ec.pointFromScalar(_private, true);
    final finger = hash160(previusPUb!).sublist(0, 4);
    final newPublic = ec.pointFromScalar(newPrivate!, true);
    final hd = HdWallet._child(
        newPrivate, newPublic!, ir, childDeph, childIndex, finger);
    return hd;
  }

  static bool isValidPath(String path) {
    final regex = RegExp(r"^(m\/)?(\d+'?\/)*\d+'?$");
    return regex.hasMatch(path);
  }

  Uint8List packUint32BE(int value) {
    var bytes = Uint8List(4);
    bytes[0] = (value >> 24) & 0xFF;
    bytes[1] = (value >> 16) & 0xFF;
    bytes[2] = (value >> 8) & 0xFF;
    bytes[3] = value & 0xFF;
    return bytes;
  }

  static HdWallet drivePath(HdWallet base, String path) {
    if (!isValidPath(path)) throw ArgumentError("Expected BIP32 Path");
    List<String> splitPath = path.split("/");
    if (splitPath[0] == "m") {
      if (!base.isMaster) {
        throw ArgumentError("wallet is not master");
      }
      splitPath = splitPath.sublist(1);
    }
    return splitPath.fold(base, (HdWallet prevHd, String indexStr) {
      int index;
      if (indexStr.substring(indexStr.length - 1) == "'") {
        index = int.parse(indexStr.substring(0, indexStr.length - 1));
        if (index > _maxUint31 || index < 0) {
          throw ArgumentError("Expected UInt31");
        }
        final f = prevHd._addDrive(index + _highBit);
        return f;
      } else {
        index = int.parse(indexStr);
        final f = prevHd._addDrive(index);
        return f;
      }
    });
  }

  static HdWallet driveEdPath(HdWallet base, String path) {
    if (!base.isMaster) {
      throw ArgumentError("wallet is not master");
    }
    if (!isValidPath(path)) throw ArgumentError("Expected BIP32 Path");
    List<String> splitPath = path.split("/");
    splitPath = splitPath.sublist(1);
    Uint8List prive = base._private;
    Uint8List chainCode = base._chainCode;
    for (String segment in splitPath) {
      bool isHardened = segment.contains("'");
      int index = int.parse(segment.replaceAll("'", ''));
      final indexResult = isHardened
          ? _getCKDPriv(prive, chainCode, index + _highBit)
          : _getCKDPriv(prive, chainCode, index);
      prive = indexResult.$1;
      chainCode = indexResult.$2;
    }
    // throw UnimplementedError();
    return HdWallet._child(prive, Uint8List(0), chainCode, 0, 0, Uint8List(4));
  }

  static (Uint8List, Uint8List) _getCKDPriv(
      Uint8List data, Uint8List chainCode, int index) {
    Uint8List dataBytes = Uint8List(37);
    dataBytes[0] = 0x00;
    dataBytes.setRange(1, 33, data);
    dataBytes.buffer.asByteData().setUint32(33, index);
    return _getKeys(dataBytes, chainCode);
  }

  static (Uint8List, Uint8List) _getKeys(
      Uint8List data, List<int> keyParameter) {
    final hmac = hmacSHA512(keyParameter as Uint8List, data);
    final private = hmac.sublist(0, 32);
    final chainCode = hmac.sublist(32);
    return (private, chainCode);
  }

  String toWif() => throw UnimplementedError("XRP DOES NOT SUPPORT WIF");
  factory HdWallet.fromWIF() {
    throw UnimplementedError("XRP DOES NOT SUPPORT WIF");
  }
}
