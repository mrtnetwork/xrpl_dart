import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'package:xrpl_dart/src/crypto/crypto.dart';

/// The NFTokenBurn transaction is used to remove an NFToken object from the
/// NFTokenPage in which it is being held, effectively removing the token from
/// the ledger ("burning" it).

/// If this operation succeeds, the corresponding NFToken is removed. If this
/// operation empties the NFTokenPage holding the NFToken or results in the
/// consolidation, thus removing an NFTokenPage, the owner’s reserve requirement
/// is reduced by one.
class NFTokenBurn extends XRPTransaction {
  /// [nfTokenId] Identifies the NFToken to be burned. This field is required.
  final String nfTokenId;

  /// [owner] Indicates which account currently owns the token if it is different than
  /// Account. Only used to burn tokens which have the lsfBurnable flag enabled
  /// and are not owned by the signing account.
  final String? owner;

  NFTokenBurn({
    required String account,
    required this.nfTokenId,
    this.owner,
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
            transactionType: XRPLTransactionType.nftokenBurn);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {"nftoken_id": nfTokenId, "owner": owner, ...super.toJson()};
  }

  NFTokenBurn.fromJson(Map<String, dynamic> json)
      : nfTokenId = json["nftoken_id"],
        owner = json["owner"],
        super.json(json);
}
