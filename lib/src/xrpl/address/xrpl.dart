import 'dart:typed_data';
import 'package:xrp_dart/src/crypto/crypto.dart';

import 'package:blockchain_utils/base58/base58.dart' as bs58;
import 'package:xrp_dart/src/xrpl/address_utilities.dart';

class XRPAddress {
  XRPAddress._(this.address);

  /// Creates an XRPAddress from a byte representation.
  factory XRPAddress.fromBytes(Uint8List bytes) {
    if (bytes.length != 33 && bytes.length != 32) {
      throw ArgumentError("Invalid xrpl public");
    }
    try {
      final toBase58 = toClassicAddress(bytes);
      return XRPAddress._(toBase58);
    } catch (e) {
      /// If an error occurs during conversion, it's treated as an invalid solana public.
    }
    throw ArgumentError("Invalid solana public");
  }

  /// Converts a public key to a classic XRP address.
  static String toClassicAddress(Uint8List public) {
    final h168 = hash160(public);
    if (h168.length != 20) {
      throw ArgumentError("invalid digest len");
    }
    final toNetworkBytes = Uint8List.fromList([0x0, ...h168]);
    return bs58.encodeCheck(toNetworkBytes, alphabet: bs58.ripple);
  }

  /// Converts the XRP address to an X-Address.
  String toXAddress({int? tag, bool isTestNetwork = false}) =>
      XRPAddressUtilities.toXAddress(address,
          tag: tag, isTestNetwork: isTestNetwork);

  /// Creates an XRP address from a base58-encoded string.
  factory XRPAddress.fromBase58(String base58) {
    try {
      final prefix = base58.substring(0, 1).toLowerCase();
      if (base58.length != 34 || (prefix != "r" && prefix != "x")) {
        throw ArgumentError(
            "Invalid ripple address. Address should be 34 characters long and start with 'X' or 'r'");
      }
      final toBase64 = bs58.decode(base58, alphabet: bs58.ripple);

      if (toBase64.length != 25) {
        throw ArgumentError("Invalid ripple address");
      }
      return XRPAddress._(base58);

      /// ignore: empty_catches
    } catch (e) {}
    throw ArgumentError("Invalid ripple address");
  }

  /// Converts the XRP address to a Uint8List of bytes.
  Uint8List toBytes() {
    return bs58.decodeCheck(address, alphabet: bs58.ripple);
  }

  final String address;

  @override
  String toString() {
    return address;
  }
}
