// ignore_for_file: non_constant_identifier_names, constant_identifier_names
import 'dart:typed_data';

import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';
import 'package:xrp_dart/src/xrpl/models/transaction.dart';
import 'package:xrp_dart/src/xrpl/models/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

enum PaymentChannelClaimFlag {
  TF_RENEW(0x00010000),
  TF_CLOSE(0x00020000);

  final int value;
  const PaymentChannelClaimFlag(this.value);
}

class PaymentChannelClaimFlagInterface {
  PaymentChannelClaimFlagInterface(
      {required this.TF_CLOSE, required this.TF_RENEW});
  final bool TF_RENEW;
  final bool TF_CLOSE;
}

// Represents a `PaymentChannelClaim <https://xrpl.org/paymentchannelclaim.html>`_
// transaction, which claims XRP from a `payment channel
// <https://xrpl.org/payment-channels.html>`_, adjusts
// channel's expiration, or both. This transaction can be used differently
// depending on the transaction sender's role in the specified channel.
class PaymentChannelClaim extends XRPTransaction {
  final String channel;
  final BigInt? balance;
  final BigInt? amount;
  String? signature;
  final String? publicKey;

  ///[channel] The unique ID of the payment channel, as a 64-character hexadecimal
  /// string
  /// [balance] The cumulative amount of XRP to have delivered through this channel after
  /// processing this claim
  /// [amount] The cumulative amount of XRP that has been authorized to deliver by the
  /// attached claim signature
  /// [signature] The signature of the claim, as hexadecimal. This signature must be
  /// verifiable for the this channel and the given ``public_key`` and ``amount``
  /// values. May be omitted if closing the channel or if the sender of this
  /// transaction is the source address of the channel; required otherwise.
  /// [publicKey] The public key that should be used to verify the attached signature. Must
  /// match the `PublicKey` that was provided when the channel was created.
  /// Required if ``signature`` is provided.
  PaymentChannelClaim({
    required super.account,
    required this.channel,
    super.memos,
    super.flags,
    super.ticketSequance,
    this.balance,
    this.amount,
    this.signature,
    this.publicKey,
    super.signingPubKey,
    super.sequence,
    super.fee,
    super.lastLedgerSequence,
  }) : super(transactionType: XRPLTransactionType.PAYMENT_CHANNEL_CLAIM);
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    addWhenNotNull(json, "channel", channel);
    addWhenNotNull(json, "balance", balance?.toString());
    addWhenNotNull(json, "amount", amount?.toString());
    addWhenNotNull(json, "signature", signature);
    addWhenNotNull(json, "public_key", publicKey);
    return json;
  }

  PaymentChannelClaim.fromJson(Map<String, dynamic> json)
      : amount = parseBigInt(json["amount"]),
        balance = parseBigInt(json["balance"]),
        channel = json["channel"],
        publicKey = json["public_key"],
        signature = json["signature"],
        super.json(json);

  String signForClain() {
    Uint8List prefix = hexToBytes("434C4D00");
    final channelx = Hash256.fromValue(channel);
    final amountx = UInt64.fromValue(amount!.toInt());
    return bytesToHex(
        Uint8List.fromList([...prefix, ...channelx.buffer, ...amountx.buffer]));
  }
}
