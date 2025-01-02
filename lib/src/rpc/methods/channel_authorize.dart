import 'package:xrpl_dart/xrpl_dart.dart';

/// The channel_authorize method creates a signature that can
/// be used to redeem a specific amount of XRP from a payment channel.
/// Warning: Do not send secret keys to untrusted servers or through unsecured network
/// connections. (This includes the secret, seed, seed_hex, or passphrase fields of
/// this request.) You should only use this method on a secure, encrypted network
/// connection to a server you run or fully trust with your funds. Otherwise,
/// eavesdroppers could use your secret key to sign claims and take all the money from
/// this payment channel and anything else using the same key pair. See
/// [Set Up Secure Signing](https://xrpl.org/set-up-secure-signing.html) for
/// instructions.
// See [channel_authorize](https://xrpl.org/channel_authorize.html)
class XRPRequestChannelAuthorize
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestChannelAuthorize({
    required this.channelId,
    required this.amount,
    this.secret,
    this.seed,
    this.seedHex,
    this.passphrase,
    this.keyType,
    super.ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.channelAuthorize;

  final String channelId;
  final String amount;
  final String? secret;
  final String? seed;
  final String? seedHex;
  final String? passphrase;
  final XRPKeyAlgorithm? keyType;

  @override
  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'amount': amount,
      'secret': secret,
      'seed': seed,
      'seed_hex': seedHex,
      'passphrase': passphrase,
      'key_type': keyType?.curveType.name
    };
  }
}
