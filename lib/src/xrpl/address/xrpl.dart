import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/crypto/crypto.dart';
import 'package:xrpl_dart/src/exception/exceptions.dart';

class XRPClassicAddressConst {
  static const XRPClassicAddress accountZero = XRPClassicAddress._(
    classicAddress: 'rrrrrrrrrrrrrrrrrrrrrhoLvTp',
  );
  static const XRPClassicAddress accountOne = XRPClassicAddress._(
    classicAddress: 'rrrrrrrrrrrrrrrrrrrrBZbvji',
  );
  static const XRPClassicAddress genesisAccount = XRPClassicAddress._(
    classicAddress: 'rHb9CJAWyB4rj91VRWn96DkukG4bwdtyTh',
  );
  static const XRPClassicAddress nanAddress = XRPClassicAddress._(
    classicAddress: 'rrrrrrrrrrrrrrrrrrrn5RM1rHd',
  );
}

sealed class XRPBaseAddress
    with CborTagSerializable, Equality
    implements IAddress {
  final String classicAddress;

  const XRPBaseAddress._({required this.classicAddress});
  factory XRPBaseAddress(String address, {ChainType? chainType}) {
    final decode = XRPAddressUtils.decodeAddress(address);
    if (chainType != null &&
        decode.chainType != null &&
        chainType != decode.chainType) {
      throw const XRPLAddressCodecException('Missmatch chain type.');
    }
    return switch (decode.chainType) {
      null => XRPClassicAddress._(classicAddress: decode.classicAddress),
      ChainType.testnet || ChainType.mainnet => XRPXAddress._(
        address: address,
        classicAddress: decode.classicAddress,
        chainType: decode.chainType!,
        tag: decode.tag,
      ),
    };
  }

  /// construct from iAdress encode bytes.
  factory XRPBaseAddress.deserializeIAddress({
    List<int>? bytes,
    CborObject? object,
  }) {
    final values = CborTagSerializable.decodeTaggedValue(
      identifier: BlockchainNetwork.xrpl.identifier,
      cborBytes: bytes,
      cborObject: object,
    );
    final type = XRPAddressType.fromValue(values.rawValueAt(0));
    return switch (type) {
      XRPAddressType.classic => XRPClassicAddress.fromBytes(
        values.rawValueAt(1),
      ),
      XRPAddressType.xAddress => XRPXAddress.fromBytes(
        values.rawValueAt(1),
        chainType: ChainType.fromValue(values.rawValueAt(2)),
        tag: values.rawValueAt(3),
      ),
    };
    // return XRPBaseAddress.fromBytes(values.rawValueAt(0));
  }

  /// convert address to classic address
  XRPClassicAddress toClassicAddress() {
    return switch (this) {
      XRPXAddress() => XRPClassicAddress._(classicAddress: classicAddress),
      XRPClassicAddress address => address,
    };
  }

  /// convert address to bytes.
  List<int> toBytes() {
    return XrpAddrDecoder().decodeAddr(classicAddress);
  }

  /// convert address to xAddress
  XRPXAddress toXAddress({ChainType chainType = ChainType.mainnet, int? tag}) {
    final address = XRPAddressUtils.hashToXAddress(toBytes(), chainType, tag);
    return XRPXAddress._(
      address: address,
      classicAddress: classicAddress,
      chainType: chainType,
      tag: tag,
    );
  }

  bool get isXAddress => false;
  XRPAddressType get type;

  int? get tag => null;
  ChainType? get chainType => null;
}

class XRPXAddress extends XRPBaseAddress {
  @override
  final String address;
  @override
  final ChainType chainType;
  @override
  final int? tag;
  const XRPXAddress._({
    required this.address,
    required super.classicAddress,
    required this.chainType,
    required this.tag,
  }) : super._();
  factory XRPXAddress(String address, {ChainType? chainType}) {
    try {
      final decode = XRPAddressUtils.decodeXAddress(address);
      if (chainType != null && decode.chainType != chainType) {
        throw const XRPLAddressCodecException('Missmatch chain type.');
      }
      return XRPXAddress._(
        address: address,
        classicAddress: decode.classicAddress,
        chainType: decode.chainType!,
        tag: decode.tag,
      );
    } on XRPLAddressCodecException {
      rethrow;
    } catch (e) {
      throw XRPLAddressCodecException("Invalid address format.");
    }
  }

  /// construct address from public key bytes.
  factory XRPXAddress.fromPublicKeyBytes(
    List<int> bytes, {
    XRPKeyAlgorithm? algorithm,
    ChainType chainType = ChainType.mainnet,
    int? tag,
  }) {
    final encodode = XrpXAddrEncoder().encodeKeyWithClassicAddress(
      bytes,
      pubKeyType: algorithm?.curveType,
      chainType: chainType,
      tag: tag,
    );
    return XRPXAddress._(
      address: encodode.xAddress,
      chainType: chainType,
      tag: tag,
      classicAddress: encodode.classicAddress,
    );
  }

  /// construct address from hash key bytes.
  factory XRPXAddress.fromBytes(
    List<int> bytes, {
    ChainType chainType = ChainType.mainnet,
    int? tag,
  }) {
    final encoded = XRPAddressUtils.hashToXAddress(bytes, chainType, tag);
    return XRPXAddress._(
      address: encoded,
      chainType: chainType,
      tag: tag,
      classicAddress: XRPAddressUtils.hashToAddress(bytes),
    );
  }

  @override
  bool get isXAddress => true;

  @override
  BlockchainNetwork get blockchainNetwork => BlockchainNetwork.xrpl;

  @override
  List<int> encodeAsIAddress() {
    return toCbor().encode();
  }

  @override
  SerializationIdentifier get serializationIdentifier =>
      blockchainNetwork.identifier;

  @override
  List<CborObject?> get serializationItems => [
    type.value.toCbor(),
    toBytes().toCborBytes(),
    chainType.value.toCbor(),
    tag?.toCbor(),
  ];

  @override
  List<dynamic> get variables => [address];

  @override
  XRPAddressType get type => XRPAddressType.xAddress;

  @override
  String toString() {
    return address;
  }

  @override
  String get viewType => "X-Address";
}

class XRPClassicAddress extends XRPBaseAddress {
  const XRPClassicAddress._({required super.classicAddress}) : super._();
  @override
  String get address => classicAddress;

  /// construct address from public key bytes.
  factory XRPClassicAddress.fromPublicKeyBytes(
    List<int> bytes, {
    XRPKeyAlgorithm? algorithm,
  }) {
    final addr = XrpAddrEncoder().encodeKey(
      bytes,
      pubKeyType: algorithm?.curveType,
    );
    return XRPClassicAddress._(classicAddress: addr);
  }

  /// construct address from hash key bytes.
  factory XRPClassicAddress.fromBytes(List<int> bytes) {
    return XRPClassicAddress._(
      classicAddress: XRPAddressUtils.hashToAddress(bytes),
    );
  }

  /// Creates an XRP address from a base58-encoded string.
  factory XRPClassicAddress(String address) {
    try {
      final decode = XRPAddressUtils.decodeAddress(address);
      if (decode.type.isXAddress) {
        throw const XRPLAddressCodecException('Invalid class address.');
      }
      return XRPClassicAddress._(classicAddress: decode.classicAddress);
    } on XRPLAddressCodecException {
      rethrow;
    } catch (e) {
      throw XRPLAddressCodecException("Invalid address format.");
    }
  }

  @override
  String toString() {
    return address;
  }

  @override
  BlockchainNetwork get blockchainNetwork => BlockchainNetwork.xrpl;

  @override
  List<int> encodeAsIAddress() {
    return toCbor().encode();
  }

  @override
  SerializationIdentifier get serializationIdentifier =>
      blockchainNetwork.identifier;

  @override
  List<CborObject?> get serializationItems => [
    type.value.toCbor(),
    toBytes().toCborBytes(),
  ];

  @override
  List<dynamic> get variables => [address];

  @override
  XRPAddressType get type => XRPAddressType.classic;

  @override
  String? get viewType => "Classic";
}
