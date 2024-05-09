import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'package:xrpl_dart/src/crypto/crypto.dart';

/// Represents an [EscrowCancel](https://xrpl.org/escrowcancel.html)
/// transaction, which returns escrowed XRP to the sender after the Escrow has
/// expired.
class EscrowCancel extends XRPTransaction {
  /// [owner] The address of the account that funded the Escrow.
  final String owner;

  /// [offerSequence] Transaction sequence (or Ticket number) of the EscrowCreate transaction that created the Escrow.
  final int offerSequence;

  EscrowCancel({
    required String account,
    required this.owner,
    required this.offerSequence,
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
            transactionType: XRPLTransactionType.escrowCancel);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {"owner": owner, "offer_sequence": offerSequence, ...super.toJson()};
  }

  EscrowCancel.fromJson(Map<String, dynamic> json)
      : owner = json["owner"],
        offerSequence = json["offer_sequence"],
        super.json(json);
}
