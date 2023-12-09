import 'package:xrp_dart/src/xrpl/models/currencies/currencies.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// Represents a CheckCreate [https://xrpl.org/checkcreate.html](https://xrpl.org/checkcreate.html) transaction,
/// which creates a Check object. A Check object is a deferred payment
/// that can be cashed by its intended destination. The sender of this
/// transaction is the sender of the Check.
class CheckCreate extends XRPTransaction {
  final String destination;
  final CurrencyAmount sendMax;
  final String? destinationTag;
  late final int? expiration;
  final String? invoiceId;

  /// [destination] The address of the account that can cash the Check
  /// [sendMax] Maximum amount of source token the Check is allowed to debit the
  /// sender, including transfer fees on non-XRP tokens. The Check can only
  /// credit the destination with the same token (from the same issuer, for
  /// non-XRP tokens).
  /// [expiration] Time after which the Check is no longer valid
  /// [invoiceId] Arbitrary 256-bit hash representing a specific reason or identifier for
  /// this Check.
  CheckCreate({
    required super.account,
    required this.destination,
    required this.sendMax,
    super.memos,
    super.ticketSequance,
    this.destinationTag,
    DateTime? expirationTime,
    this.invoiceId,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  }) : super(transactionType: XRPLTransactionType.checkCreate) {
    if (expirationTime != null) {
      expiration = datetimeToRippleTime(expirationTime);
    } else {
      expiration = null;
    }
  }

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "destination", destination);
    addWhenNotNull(json, "send_max", sendMax.toJson());
    addWhenNotNull(json, "destination_tag", destinationTag);
    addWhenNotNull(json, "expiration", expiration);
    addWhenNotNull(json, "invoice_id", invoiceId);
    return json;
  }

  CheckCreate.fromJson(super.json)
      : destination = json["destination"],
        destinationTag = json["destination_tag"],
        sendMax = CurrencyAmount.fromJson(json["send_max"]),
        expiration = json["expiration"],
        invoiceId = json["invoice_id"],
        super.json();
}
