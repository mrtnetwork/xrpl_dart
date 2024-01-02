import 'package:xrp_dart/src/rpc/rpc.dart';

/// This request returns information about an account's Payment Channels. This includes
/// only channels where the specified account is the channel's source, not the
/// destination. (A channel's "source" and "owner" are the same.)
/// All information retrieved is relative to a particular version of the ledger.
/// See [account_channels](https://xrpl.org/account_channels.html)
class RPCAccountChannel extends XRPLedgerRequest<Map<String, dynamic>> {
  RPCAccountChannel(
      {required this.account,
      required this.destinationAccount,
      XRPLLedgerIndex? ledgerIndex = XRPLLedgerIndex.validated,
      this.limit = 200})
      : super(ledgerIndex: ledgerIndex);
  @override
  String get method => XRPRequestMethod.accountChannels;

  final String account;
  final String? destinationAccount;
  final int limit;

  @override
  Map<String, dynamic> toJson() {
    return {
      "account": account,
      "destination_account": destinationAccount,
      "limit": limit
    };
  }
}
