import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/crypto/crypto.dart';
import 'package:xrpl_dart/src/xrpl/exception/exceptions.dart';

class XRPAddressConst {
  static final XRPAddress accountZero =
      XRPAddress("rrrrrrrrrrrrrrrrrrrrrhoLvTp");
  static final XRPAddress accountOne = XRPAddress("rrrrrrrrrrrrrrrrrrrrBZbvji");
  static final XRPAddress genesisAccount =
      XRPAddress("rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh");
  static final XRPAddress nanAddress =
      XRPAddress("rrrrrrrrrrrrrrrrrrrn5RM1rHd");
}

class XRPAddress {
  /// return classic address as string
  final String address;

  /// X-address tag. if decoded address is x-address otherwise is null
  final int? tag;

  /// X-address testnet. if decoded address is x-address otherwise is null
  final bool? isTesnet;
  const XRPAddress._(this.address, this.tag, this.isTesnet);

  /// Creates an XRPAddress from a byte representation.
  factory XRPAddress.fromPublicKeyBytes(
      List<int> bytes, XRPKeyAlgorithm algorithm) {
    return XRPAddress._(
        XrpAddrEncoder().encodeKey(bytes, {"curve_type": algorithm.curveType}),
        null,
        null);
  }

  /// Creates an XRP X-Address from a byte representation.
  factory XRPAddress.xAddressfromPublicKeyBytes(
      List<int> bytes, XRPKeyAlgorithm algorithm,
      {bool isTestnet = false, int? tag}) {
    return XRPAddress._(
        XrpAddrEncoder().encodeKey(bytes, {"curve_type": algorithm.curveType}),
        tag,
        isTestnet);
  }

  /// Creates an XRPAddress from a byte representation.
  factory XRPAddress.fromXAddress(String xAddress, {bool? isTestnet}) {
    List<int>? addrNetVar;
    if (isTestnet != null) {
      addrNetVar = isTestnet
          ? CoinsConf.rippleTestNet.params.addrNetVer!
          : CoinsConf.ripple.params.addrNetVer!;
    }
    final decodeXAddress = XRPAddressUtils.decodeXAddress(xAddress, addrNetVar);
    final toClassic = XRPAddressUtils.hashToAddress(decodeXAddress.bytes);
    return XRPAddress._(
        toClassic, decodeXAddress.tag, decodeXAddress.isTestnet);
  }

  /// Creates an XRP address from a base58-encoded string.
  factory XRPAddress(String address, {bool? allowXAddress, bool? isTestnet}) {
    try {
      if (allowXAddress != false && XRPAddressUtils.isXAddress(address)) {
        return XRPAddress.fromXAddress(address, isTestnet: isTestnet);
      }
      XrpAddrDecoder().decodeAddr(address);
      return XRPAddress._(address, null, null);
    } catch (e) {
      throw const XRPLAddressCodecException("Invalid ripple address");
    }
  }

  /// Converts the XRP address to an X-Address.
  String toXAddress({bool isTestnet = false, int? tag}) {
    final List<int> addrNetVar = isTestnet
        ? CoinsConf.rippleTestNet.params.addrNetVer!
        : CoinsConf.ripple.params.addrNetVer!;
    return XRPAddressUtils.classicToXAddress(address, addrNetVar, tag: tag);
  }

  /// The same decoded address. otherwise classic address
  String toAddress() {
    if (tag != null) {
      return toXAddress(isTestnet: isTesnet!, tag: tag);
    }
    return address;
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
