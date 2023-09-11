import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// The NFTokenCancelOffer transaction deletes existing NFTokenOffer objects.
/// It is useful if you want to free up space on your account to lower your
/// reserve requirement.

/// The transaction can be executed by the account that originally created
/// the NFTokenOffer, the account in the `Recipient` field of the NFTokenOffer
/// (if present), or any account if the NFTokenOffer has an `Expiration` and
/// the NFTokenOffer has already expired.
class NFTokenCancelOffer extends XRPTransaction {
  /// [nftokenOffers] An array of identifiers of NFTokenOffer objects that should be cancelled
  /// by this transaction.

  /// It is an error if an entry in this list points to an
  /// object that is not an NFTokenOffer object. It is not an
  /// error if an entry in this list points to an object that
  /// does not exist. This field is required.
  NFTokenCancelOffer({
    required this.nftokenOffers,
    required super.account,
    super.memos,
    super.ticketSequance,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  })  : assert(nftokenOffers.isNotEmpty,
            "Must specify at least one NFTokenOffer to cancel"),
        super(transactionType: XRPLTransactionType.NFTOKEN_CANCEL_OFFER);
  final List<String> nftokenOffers;
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "nftoken_offers", nftokenOffers);
    return json;
  }

  NFTokenCancelOffer.fromJson(Map<String, dynamic> json)
      : nftokenOffers = (json["nftoken_offers"] as List).cast(),
        super.json(json);
}
