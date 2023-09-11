import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// Represents an [EscrowFinish](https://xrpl.org/escrowfinish.html)
/// transaction, delivers XRP from a held payment to the recipient.
class EscrowFinish extends XRPTransaction {
  /// [owner] The source account that funded the Escrow.
  /// [offerSequence] Transaction sequence (or Ticket number) of the EscrowCreate transaction that created the Escrow.
  /// [condition] The previously-supplied [PREIMAGE-SHA-256 crypto-condition ](https://tools.ietf.org/html/draft-thomas-crypto-conditions-04#section-8.1.)
  /// of the Escrow, if any, as hexadecimal.
  /// [fulfillment] The previously-supplied [PREIMAGE-SHA-256 crypto-condition fulfillment](https://tools.ietf.org/html/draft-thomas-crypto-conditions-04#section-8.1.)
  /// of the Escrow, if any, as hexadecimal.
  EscrowFinish({
    required super.account,
    required this.owner,
    required this.offerSequence,
    super.memos,
    super.ticketSequance,
    this.condition,
    this.fulfillment,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  })  : assert(() {
          if ((condition == null && fulfillment != null) ||
              (condition != null && fulfillment == null)) {
            return false;
          }
          return true;
        }(), "condition and fulfillment must both be specified."),
        super(transactionType: XRPLTransactionType.ESCROW_FINISH);
  final String owner;
  final int offerSequence;
  final String? condition;
  final String? fulfillment;

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "owner", owner);
    addWhenNotNull(json, "offer_sequence", offerSequence);
    addWhenNotNull(json, "condition", condition);
    addWhenNotNull(json, "fulfillment", fulfillment);
    return json;
  }

  EscrowFinish.fromJson(Map<String, dynamic> json)
      : owner = json["owner"],
        offerSequence = json["offer_sequence"],
        condition = json["condition"],
        fulfillment = json["fulfillment"],
        super.json(json);
}
