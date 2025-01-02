import 'package:blockchain_utils/utils/utils.dart';
import 'package:xrpl_dart/src/utility/helper.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents a [PaymentChannelFund](https://xrpl.org/paymentchannelfund.html)
/// transaction, adds additional XRP to an open [payment channel](https://xrpl.org/payment-channels.html)
/// and optionally updates the expiration time of the channel. Only the source address
/// of the channel can use this transaction.
class PaymentChannelFund extends XRPTransaction {
  /// [channel] The unique ID of the payment channel, as a 64-character hexadecimal
  ///  string.
  final String channel;

  /// [amount] The amount of XRP, in drops, to add to the channel.
  final BigInt amount;

  /// [expiration] A new mutable expiration time to set for the channel,
  /// This must be later than the existing expiration time of the
  /// channel or later than the current time plus the settle delay of the channel.
  /// This is separate from the immutable cancel_after time.
  late final int? expiration;

  PaymentChannelFund({
    required super.account,
    required this.channel,
    required this.amount,
    DateTime? expirationTime,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: XRPLTransactionType.paymentChannelFund) {
    if (expirationTime != null) {
      expiration = XRPHelper.datetimeToRippleTime(expirationTime);
    } else {
      expiration = null;
    }
  }

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'amount': amount.toString(),
      'expiration': expiration,
      ...super.toJson()
    };
  }

  PaymentChannelFund.fromJson(super.json)
      : channel = json['channel'],
        amount = BigintUtils.tryParse(json['amount'])!,
        expiration = json['expiration'],
        super.json();
}
