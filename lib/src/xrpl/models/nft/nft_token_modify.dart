import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// The NFTokenModify transaction updates the `URI` field of a dynamic NFT,
/// changing the supporting data for the NFT. Only the issuer, or their
/// authorized minter, can modify an NFT, and only if it was minted with the
/// `tfMutable` flag enabled.
/// Requires the [DynamicNFT amendment](https://xrpl.org/resources/known-amendments#dynamicnft).
class NFTokenModify extends SubmittableTransaction {
  /// [nfTokenId] Identifies the NFToken to modify. This field is required.
  final String nfTokenId;

  /// [owner] Address of the owner of the NFT. If the `account` and `owner`
  /// are the same address, omit this field.
  final String? owner;

  /// [uri] Up to 256 bytes of arbitrary data, as hexadecimal. If you do not
  /// specify a URI, the existing URI is deleted.
  final String? uri;

  NFTokenModify({
    required super.account,
    required this.nfTokenId,
    this.owner,
    this.uri,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.accountTxId,
    super.delegate,
    super.networkId,
    super.sourceTag,
  }) : super(transactionType: SubmittableTransactionType.nftokenModify);

  @override
  String? get validate {
    if (nfTokenId.isEmpty) {
      return 'nftoken_id must not be empty.';
    }
    if (uri != null && (uri!.length > NFTTokenConst.maxUriLength)) {
      return 'uri Must not be longer than ${NFTTokenConst.maxUriLength} characters';
    }
    return super.validate;
  }

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'nftoken_id': nfTokenId,
      'owner': owner,
      'uri': uri,
      ...super.toJson(),
    }..removeWhere((_, v) => v == null);
  }

  NFTokenModify.fromJson(super.json)
    : nfTokenId = json['nftoken_id'],
      owner = json['owner'],
      uri = json['uri'],
      super.json();
}
