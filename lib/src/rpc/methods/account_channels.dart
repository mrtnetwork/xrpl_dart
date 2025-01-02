import 'package:xrpl_dart/src/rpc/rpc.dart';

/// This request returns information about an account's Payment Channels. This includes
/// only channels where the specified account is the channel's source, not the
/// destination. (A channel's "source" and "owner" are the same.)
/// All information retrieved is relative to a particular version of the ledger.
/// See [account_channels](https://xrpl.org/account_channels.html)
class XRPRequestAccountChannel
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestAccountChannel(
      {required this.account,
      required this.destinationAccount,
      super.ledgerIndex = XRPLLedgerIndex.validated,
      this.limit = 200});
  @override
  String get method => XRPRequestMethod.accountChannels;

  final String account;
  final String? destinationAccount;
  final int limit;

  @override
  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'destination_account': destinationAccount,
      'limit': limit
    };
  }
}
