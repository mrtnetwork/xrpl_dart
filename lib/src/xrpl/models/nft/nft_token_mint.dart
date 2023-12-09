import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

class _NFTTokenConst {
  static const int maxUriLength = 512;
  static const int maxTransferFee = 50000;
}

/// Transaction Flags for an NFTokenMint Transaction.
enum NFTokenMintFlag {
  tfBurnable(0x00000001),
  tfOnlyXrp(0x00000002),
  tfTrustline(0x00000004),
  tfTransferable(0x00000008);

  final int value;
  const NFTokenMintFlag(this.value);
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
  final int nftokenTaxon;
  final String? issuer;
  final int? transferFee;
  final String? uri;

  /// [nftokenTaxon] Indicates the taxon associated with this token. The taxon is generally a
  /// value chosen by the minter of the token and a given taxon may be used for
  /// multiple tokens. The implementation reserves taxon identifiers greater
  /// than or equal to 2147483648 (0x80000000). If you have no use for this
  /// field, set it to 0.
  ///
  /// [issuer] Indicates the account that should be the issuer of this token. This value
  /// is optional and should only be specified if the account executing the
  /// transaction is not the `Issuer` of the `NFToken` object. If it is
  /// present, the `MintAccount` field in the `AccountRoot` of the `Issuer`
  /// field must match the `Account`, otherwise the transaction will fail.
  ///
  /// [transferFee] Specifies the fee charged by the issuer for secondary sales of the Token,
  /// if such sales are allowed. Valid values for this field are between 0 and
  /// 50000 inclusive, allowing transfer rates between 0.000% and 50.000% in
  /// increments of 0.001%. This field must NOT be present if the
  /// `tfTransferable` flag is not set.
  ///
  /// [uri] that points to the data and/or metadata associated with the NFT.
  /// This field need not be an HTTP or HTTPS URL; it could be an IPFS URI, a
  /// magnet link, immediate data encoded as an RFC2379 "data" URL, or even an
  /// opaque issuer-specific encoding. The URI is not checked for validity.
  /// This field must be hex-encoded. You can use `xrpl.utils.str_to_hex` to
  /// convert a UTF-8 string to hex.

  NFTokenMint({
    required this.nftokenTaxon,
    required super.account,
    required super.flags,
    super.memos,
    super.ticketSequance,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
    this.issuer,
    this.transferFee,
    this.uri,
  })  : assert(uri == null || (uri.length <= _NFTTokenConst.maxUriLength),
            'Must not be longer than ${_NFTTokenConst.maxUriLength} characters'),
        assert(
            transferFee == null ||
                (transferFee <= _NFTTokenConst.maxTransferFee),
            'Must not be longer than ${_NFTTokenConst.maxTransferFee} characters'),
        assert(issuer == null || (issuer != account),
            'Must not be the same as the account'),
        super(transactionType: XRPLTransactionType.nftokenMint);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "nftoken_taxon", nftokenTaxon);
    addWhenNotNull(json, "issuer", issuer);
    addWhenNotNull(json, "transfer_fee", transferFee);
    addWhenNotNull(json, "uri", uri);
    return json;
  }

  NFTokenMint.fromJson(super.json)
      : nftokenTaxon = json["nftoken_taxon"],
        issuer = json["issuer"],
        transferFee = json["transfer_fee"],
        uri = json["uri"],
        super.json();
}
