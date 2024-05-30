import 'package:blockchain_utils/bip/coin_conf/coins_conf.dart';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/crypto/crypto.dart';
import 'package:xrpl_dart/src/xrpl/exception/exceptions.dart';

class XRPAddress {
  final String address;
  final int? tag;
  const XRPAddress._(this.address, this.tag);

  /// Creates an XRPAddress from a byte representation.
  factory XRPAddress.fromPublicKeyBytes(
      List<int> bytes, XRPKeyAlgorithm algorithm) {
    return XRPAddress._(
        XrpAddrEncoder().encodeKey(bytes, {"curve_type": algorithm.curveType}),
        null);
  }

  /// Creates an XRPAddress from a byte representation.
  factory XRPAddress.fromXAddress(String xAddress, {bool isTestnet = false}) {
    final List<int> addrNetVar = isTestnet
        ? CoinsConf.rippleTestNet.params.addrNetVer!
        : CoinsConf.ripple.params.addrNetVer!;
    final decodeXAddress = XRPAddressUtils.decodeXAddress(xAddress, addrNetVar);
    final toClassic = XRPAddressUtils.hashToAddress(decodeXAddress.item1);
    return XRPAddress._(toClassic, decodeXAddress.item2);
  }

  /// Converts the XRP address to an X-Address.
  String toXAddress({bool forTestnet = false, int? tag}) {
    final List<int> addrNetVar = forTestnet
        ? CoinsConf.rippleTestNet.params.addrNetVer!
        : CoinsConf.ripple.params.addrNetVer!;
    return XRPAddressUtils.classicToXAddress(address, addrNetVar, tag: tag);
  }

  /// Creates an XRP address from a base58-encoded string.
  factory XRPAddress(String address, {bool allowXAddress = false}) {
    try {
      if (allowXAddress && XRPAddressUtils.isXAddress(address)) {
        return XRPAddress.fromXAddress(address);
      }
      XrpAddrDecoder().decodeAddr(address);
      return XRPAddress._(address, null);
    } catch (e) {
      throw const XRPLAddressCodecException("Invalid ripple address");
    }
  }

  /// Converts the XRP address to a list<int> of bytes.
  List<int> toBytes() {
    return XrpAddrDecoder().decodeAddr(address);
  }

  @override
  String toString() {
    return address;
  }
}
