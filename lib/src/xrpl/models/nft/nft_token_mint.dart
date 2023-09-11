// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

const int _MAX_URI_LENGTH = 512;
const int _MAX_TRANSFER_FEE = 50000;

/// Transaction Flags for an NFTokenMint Transaction.
enum NFTokenMintFlag {
  TF_BURNABLE(0x00000001),
  TF_ONLY_XRP(0x00000002),
  TF_TRUSTLINE(0x00000004),
  TF_TRANSFERABLE(0x00000008);

  final int value;
  const NFTokenMintFlag(this.value);
}

class NFTokenMintFlagInterface {
  final bool TF_BURNABLE;
  final bool TF_ONLY_XRP;
  final bool TF_TRUSTLINE;
  final bool TF_TRANSFERABLE;

  NFTokenMintFlagInterface({
    required this.TF_BURNABLE,
    required this.TF_ONLY_XRP,
    required this.TF_TRUSTLINE,
    required this.TF_TRANSFERABLE,
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
  })  : assert(uri == null || (uri.length <= _MAX_URI_LENGTH),
            'Must not be longer than $_MAX_URI_LENGTH characters'),
        assert(transferFee == null || (transferFee <= _MAX_TRANSFER_FEE),
            'Must not be longer than $_MAX_URI_LENGTH characters'),
        assert(issuer == null || (issuer != account),
            'Must not be the same as the account'),
        super(transactionType: XRPLTransactionType.NFTOKEN_MINT);

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "nftoken_taxon", nftokenTaxon);
    addWhenNotNull(json, "issuer", issuer);
    addWhenNotNull(json, "transfer_fee", transferFee);
    addWhenNotNull(json, "uri", uri);
    return json;
  }

  NFTokenMint.fromJson(Map<String, dynamic> json)
      : nftokenTaxon = json["nftoken_taxon"],
        issuer = json["issuer"],
        transferFee = json["transfer_fee"],
        uri = json["uri"],
        super.json(json);
}
