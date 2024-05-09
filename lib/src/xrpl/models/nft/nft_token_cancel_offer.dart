import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'package:xrpl_dart/src/crypto/crypto.dart';

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
    required String account,
    List<XRPLMemo>? memos = const [],
    XRPLSignature? signer,
    int? ticketSequance,
    BigInt? fee,
    int? lastLedgerSequence,
    int? sequence,
    List<XRPLSigners>? multisigSigners,
    int? flags,
    int? sourceTag,
  }) : super(
            account: account,
            fee: fee,
            lastLedgerSequence: lastLedgerSequence,
            memos: memos,
            sequence: sequence,
            multisigSigners: multisigSigners,
            sourceTag: sourceTag,
            flags: flags,
            ticketSequance: ticketSequance,
            signer: signer,
            transactionType: XRPLTransactionType.nftokenCancelOffer);

  @override
  String? get validate {
    if (nftokenOffers.isEmpty) {
      return "nftokenOffers Must specify at least one NFTokenOffer to cancel";
    }
    return super.validate;
  }

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {"nftoken_offers": nftokenOffers, ...super.toJson()};
  }

  NFTokenCancelOffer.fromJson(Map<String, dynamic> json)
      : nftokenOffers = (json["nftoken_offers"] as List).cast(),
        super.json(json);
}
