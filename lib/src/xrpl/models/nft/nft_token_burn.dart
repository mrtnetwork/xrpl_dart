import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// The NFTokenBurn transaction is used to remove an NFToken object from the
/// NFTokenPage in which it is being held, effectively removing the token from
/// the ledger ("burning" it).

/// If this operation succeeds, the corresponding NFToken is removed. If this
/// operation empties the NFTokenPage holding the NFToken or results in the
/// consolidation, thus removing an NFTokenPage, the owner’s reserve requirement
/// is reduced by one.
class NFTokenBurn extends XRPTransaction {
  /// [account] Identifies the AccountID that submitted this transaction. The account must
  /// be the present owner of the token or, if the lsfBurnable flag is set
  /// on the NFToken, either the issuer account or an account authorized by the
  /// issuer (i.e. MintAccount).
  ///
  /// [nfTokenId] Identifies the NFToken to be burned. This field is required.
  /// [owner] Indicates which account currently owns the token if it is different than
  /// Account. Only used to burn tokens which have the lsfBurnable flag enabled
  /// and are not owned by the signing account.
  NFTokenBurn({
    required super.account,
    required this.nfTokenId,
    super.memos,
    super.ticketSequance,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
    this.owner,
  }) : super(transactionType: XRPLTransactionType.NFTOKEN_BURN);
  final String nfTokenId;
  final String? owner;
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "nftoken_id", nfTokenId);
    addWhenNotNull(json, "owner", owner);
    return json;
  }

  NFTokenBurn.fromJson(Map<String, dynamic> json)
      : nfTokenId = json["nftoken_id"],
        owner = json["owner"],
        super.json(json);
}
