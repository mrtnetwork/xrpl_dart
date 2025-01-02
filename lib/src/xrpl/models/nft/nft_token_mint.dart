import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

class NFTTokenConst {
  static const int maxUriLength = 512;
  static const int maxTransferFee = 50000;
}

/// Transaction Flags for an NFTokenMint Transaction.
class NFTokenMintFlag implements FlagsInterface {
  // Indicates that the NFToken is burnable.
  static const NFTokenMintFlag tfBurnable =
      NFTokenMintFlag('Burnable', 0x00000001);

  // Indicates that the NFToken can only be minted with XRP.
  static const NFTokenMintFlag tfOnlyXrp =
      NFTokenMintFlag('OnlyXRP', 0x00000002);

  // Indicates that a trustline is required to mint the NFToken.
  static const NFTokenMintFlag tfTrustline =
      NFTokenMintFlag('TrustLine', 0x00000004);

  // Indicates that the NFToken is transferable.
  static const NFTokenMintFlag tfTransferable =
      NFTokenMintFlag('Transferable', 0x00000008);

  // The integer value associated with each flag.
  final int value;
  final String name;

  // Constructor for NFTokenMintFlag.
  const NFTokenMintFlag(this.name, this.value);

  static const List<NFTokenMintFlag> values = [
    tfBurnable,
    tfOnlyXrp,
    tfTrustline,
    tfTransferable
  ];

  @override
  int get id => value;
}

class NftTokenMintFlagInterface {
  final bool tfBurnable;
  final bool tfOnlyXrp;
  final bool tfTrustline;
  final bool tfTransferable;

  NftTokenMintFlagInterface({
    required this.tfBurnable,
    required this.tfOnlyXrp,
    required this.tfTrustline,
    required this.tfTransferable,
  });
}

/// The NFTokenMint transaction creates an NFToken object and adds it to the
/// relevant NFTokenPage object of the minter. If the transaction is
/// successful, the newly minted token will be owned by the minter account
/// specified by the transaction.
class NFTokenMint extends XRPTransaction {
  /// [nftokenTaxon] Indicates the taxon associated with this token. The taxon is generally a
  /// value chosen by the minter of the token and a given taxon may be used for
  /// multiple tokens. The implementation reserves taxon identifiers greater
  /// than or equal to 2147483648 (0x80000000). If you have no use for this
  /// field, set it to 0.
  final int nftokenTaxon;

  /// [issuer] Indicates the account that should be the issuer of this token. This value
  /// is optional and should only be specified if the account executing the
  /// transaction is not the Issuer of the NFToken object. If it is
  /// present, the MintAccount field in the AccountRoot of the Issuer
  /// field must match the Account, otherwise the transaction will fail.
  final String? issuer;

  /// [transferFee] Specifies the fee charged by the issuer for secondary sales of the Token,
  /// if such sales are allowed. Valid values for this field are between 0 and
  /// 50000 inclusive, allowing transfer rates between 0.000% and 50.000% in
  /// increments of 0.001%. This field must NOT be present if the
  /// tfTransferable flag is not set.
  final int? transferFee;

  /// [uri] that points to the data and/or metadata associated with the NFT.
  /// This field need not be an HTTP or HTTPS URL; it could be an IPFS URI, a
  /// magnet link, immediate data encoded as an RFC2379 "data" URL, or even an
  /// opaque issuer-specific encoding. The URI is not checked for validity.
  /// This field must be hex-encoded. You can use xrpl.utils.str_to_hex to
  /// convert a UTF-8 string to hex.
  final String? uri;
  NFTokenMint({
    required this.nftokenTaxon,
    required super.account,
    this.issuer,
    this.transferFee,
    this.uri,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: XRPLTransactionType.nftokenMint);

  @override
  String? get validate {
    if (uri != null && (uri!.length > NFTTokenConst.maxUriLength)) {
      return 'uri Must not be longer than ${NFTTokenConst.maxUriLength} characters';
    }
    if (transferFee != null && (transferFee! > NFTTokenConst.maxTransferFee)) {
      return 'transferFee Must not be longer than ${NFTTokenConst.maxTransferFee} characters';
    }
    if (issuer == account) {
      return 'issuer Must not be the same as the account';
    }
    return super.validate;
  }

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'nftoken_taxon': nftokenTaxon,
      'issuer': issuer,
      'transfer_fee': transferFee,
      'uri': uri,
      ...super.toJson()
    };
  }

  NFTokenMint.fromJson(super.json)
      : nftokenTaxon = json['nftoken_taxon'],
        issuer = json['issuer'],
        transferFee = json['transfer_fee'],
        uri = json['uri'],
        super.json();
}
