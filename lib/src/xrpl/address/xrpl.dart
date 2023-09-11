import 'dart:typed_data';
import 'package:xrp_dart/src/crypto/crypto.dart';

import 'package:xrp_dart/src/base58/base58.dart' as bs58;
import 'package:xrp_dart/src/xrpl/address_utilities.dart';

class XRPAddress {
  XRPAddress._(this.address);

  /// must be valid bytes
  factory XRPAddress.fromBytes(Uint8List bytes) {
    if (bytes.length != 33 && bytes.length != 32) {
      throw ArgumentError("Invalid xrpl public");
    }
    try {
      final toBase58 = toClassicAddress(bytes);
      return XRPAddress._(toBase58);
      // ignore: empty_catches
    } catch (e) {}
    throw ArgumentError("Invalid solana public");
  }
  static String toClassicAddress(Uint8List public) {
    final h168 = hash160(public);
    if (h168.length != 20) {
      throw ArgumentError("invalid digest len");
    }
    final toNetworkBytes = Uint8List.fromList([0x0, ...h168]);
    return bs58.xrplBase58.encodeCheck(toNetworkBytes);
  }

  String toXAddress({int? tag, bool isTestNetwork = false}) =>
      XRPAddressUtilities.toXAddress(address,
          tag: tag, isTestNetwork: isTestNetwork);

  /// must be valid base58
  factory XRPAddress.fromBase58(String base58) {
    try {
      final prefix = base58.substring(0, 1).toLowerCase();
      if (base58.length != 34 || (prefix != "r" && prefix != "x")) {
        throw ArgumentError(
            "Invalid ripple address. address should be 34 charcter start with X or r");
      }
      final tob64 = bs58.xrplBase58.decode(base58);

      if (tob64.length != 25) {
        throw ArgumentError("Invalid ripple address");
      }
      return XRPAddress._(base58);
      // ignore: empty_catches
    } catch (e) {}
    throw ArgumentError("Invalid ripple address");
  }

  Uint8List toBytes() {
    return bs58.xrplBase58.decodeCheck(address);
  }

  final String address;

  @override
  String toString() {
    return address;
  }
}
