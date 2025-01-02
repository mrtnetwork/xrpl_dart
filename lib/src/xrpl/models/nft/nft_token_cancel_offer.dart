import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// The NFTokenCancelOffer transaction deletes existing NFTokenOffer objects.
/// It is useful if you want to free up space on your account to lower your
/// reserve requirement.

/// The transaction can be executed by the account that originally created
/// the NFTokenOffer, the account in the Recipient field of the NFTokenOffer
/// (if present), or any account if the NFTokenOffer has an Expiration and
/// the NFTokenOffer has already expired.
class NFTokenCancelOffer extends XRPTransaction {
  /// [nftokenOffers] An array of identifiers of NFTokenOffer objects that should be cancelled
  /// by this transaction.
  final List<String> nftokenOffers;

  /// It is an error if an entry in this list points to an
  /// object that is not an NFTokenOffer object. It is not an
  /// error if an entry in this list points to an object that
  /// does not exist. This field is required.
  NFTokenCancelOffer({
    required this.nftokenOffers,
    required super.account,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: XRPLTransactionType.nftokenCancelOffer);

  @override
  String? get validate {
    if (nftokenOffers.isEmpty) {
      return 'nftokenOffers Must specify at least one NFTokenOffer to cancel';
    }
    return super.validate;
  }

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {'nftoken_offers': nftokenOffers, ...super.toJson()};
  }

  NFTokenCancelOffer.fromJson(super.json)
      : nftokenOffers = (json['nftoken_offers'] as List).cast(),
        super.json();
}
