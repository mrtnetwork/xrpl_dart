import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import '../core/methods_impl.dart';

/// The channel_verify method checks the validity of a
/// signature that can be used to redeem a specific amount of
/// XRP from a payment channel.
class XRPRequestChannelVerify
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestChannelVerify(
      {required this.channelId,
      required this.amount,
      required this.publicKey,
      required this.signature});
  @override
  String get method => XRPRequestMethod.channelVerify;

  final String channelId;
  final String amount;
  final String publicKey;
  final String signature;

  @override
  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'amount': amount,
      'signature': signature,
      'public_key': publicKey
    };
  }
}
