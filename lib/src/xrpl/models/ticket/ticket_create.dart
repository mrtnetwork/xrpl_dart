import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'package:xrpl_dart/src/crypto/crypto.dart';

/// A TicketCreate transaction sets aside one or more [sequence numbers](https://xrpl.org/basic-data-types.html#account-sequence)
///  as [Tickets](https://xrpl.org/tickets.html).
class TicketCreate extends XRPTransaction {
  /// [ticketCount] How many Tickets to create. This must be a positive number and cannot cause the
  /// account to own more than 250 Tickets after executing this transaction.
  /// :meta hide-value:
  final int ticketCount;

  TicketCreate({
    required String account,
    required this.ticketCount,
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
            transactionType: XRPLTransactionType.ticketCreate);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {"ticket_count": ticketCount, ...super.toJson()};
  }

  TicketCreate.fromJson(Map<String, dynamic> json)
      : ticketCount = json["ticket_count"],
        super.json(json);
}
