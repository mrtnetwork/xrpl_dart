import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// A TicketCreate transaction sets aside one or more [sequence numbers](https://xrpl.org/basic-data-types.html#account-sequence)
///  as [Tickets](https://xrpl.org/tickets.html).
class TicketCreate extends XRPTransaction {
  /// [ticketCount] How many Tickets to create. This must be a positive number and cannot cause the
  /// account to own more than 250 Tickets after executing this transaction.
  /// :meta hide-value:
  final int ticketCount;

  TicketCreate({
    required super.account,
    required this.ticketCount,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: XRPLTransactionType.ticketCreate);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {'ticket_count': ticketCount, ...super.toJson()};
  }

  TicketCreate.fromJson(super.json)
      : ticketCount = json['ticket_count'],
        super.json();
}
