import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

/// Represents a `PaymentChannelCreate
/// <https://xrpl.org/paymentchannelcreate.html>`_ transaction, which creates a
/// `payment channel <https://xrpl.org/payment-channels.html>`_ and funds it with
/// XRP. The sender of this transaction is the "source address" of the payment
/// channel.
class PaymentChannelCreate extends XRPTransaction {
  final BigInt amount;
  final String destination;
  final int settleDelay;
  final String publicKey;
  late final int? cancelAfter;
  final int? destinationTag;

  /// [amount] The amount of XRP, in drops, to set aside in this channel.
  /// [destination] can receive XRP from this channel, also known as the
  /// "destination address" of the channel. Cannot be the same as the sender.
  /// [settleDelay] The amount of time, in seconds, the source address must wait between
  /// requesting to close the channel and fully closing it.
  /// [publicKey] The public key of the key pair that the source will use to authorize
  /// claims against this  channel, as hexadecimal. This can be any valid
  /// secp256k1 or Ed25519 public key.
  /// [cancelAfterTime] An immutable expiration time for the channel.
  /// The channel can be closed sooner than this but cannot remain open
  /// later than this time.
  PaymentChannelCreate({
    required super.account,
    required this.amount,
    required this.destination,
    required this.settleDelay,
    required this.publicKey,
    super.memos,
    super.ticketSequance,
    DateTime? cancelAfterTime,
    this.destinationTag,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  }) : super(transactionType: XRPLTransactionType.PAYMENT_CHANNEL_CREATE) {
    if (cancelAfterTime != null) {
      cancelAfter = datetimeToRippleTime(cancelAfterTime);
    } else {
      cancelAfter = null;
    }
  }
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "amount", amount.toString());
    addWhenNotNull(json, "destination", destination);
    addWhenNotNull(json, "settle_delay", settleDelay);
    addWhenNotNull(json, "public_key", publicKey);
    addWhenNotNull(json, "cancel_after", cancelAfter);
    addWhenNotNull(json, "destination_tag", destinationTag);

    return json;
  }

  PaymentChannelCreate.fromJson(Map<String, dynamic> json)
      : amount = parseBigInt(json["amount"])!,
        cancelAfter = json["cancel_after"],
        destination = json["destination"],
        destinationTag = json["destination_tag"],
        publicKey = json["public_key"],
        settleDelay = json["settle_delay"],
        super.json(json);
}
