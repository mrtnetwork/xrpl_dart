import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// A TicketCreate transaction sets aside one or more [sequence numbers](https://xrpl.org/basic-data-types.html#account-sequence)
///  as [Tickets](https://xrpl.org/tickets.html).
class TicketCreate extends XRPTransaction {
  final int ticketCount;

  /// [ticketCount] How many Tickets to create. This must be a positive number and cannot cause the
  /// account to own more than 250 Tickets after executing this transaction.
  /// :meta hide-value:
  TicketCreate({
    required super.account,
    required this.ticketCount,
    super.memos,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  }) : super(transactionType: XRPLTransactionType.TICKET_CREATE);
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "ticket_count", ticketCount);
    return json;
  }

  TicketCreate.fromJson(Map<String, dynamic> json)
      : ticketCount = json["ticket_count"],
        super.json(json);
}
