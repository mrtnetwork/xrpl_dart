import 'package:xrpl_dart/src/rpc/methods/rpc_request_methods.dart';
import 'package:xrpl_dart/src/rpc/models/models.dart';

/// The deposit_authorized command indicates whether one account
/// is authorized to send payments directly to another. See
/// Deposit Authorization for information on how to require
/// authorization to deliver money to your account.
class XRPRequestDepositAuthorized
    extends XRPLedgerRequest<DepositAuthorizedResult, Map<String, dynamic>> {
  XRPRequestDepositAuthorized({
    required this.sourceAccount,
    required this.destinationAccount,
    this.credentials,
    super.ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.depositAuthorized;

  final String sourceAccount;
  final String destinationAccount;
  final List<String>? credentials;

  @override
  Map<String, dynamic> toJson() {
    return {
      'source_account': sourceAccount,
      'destination_account': destinationAccount,
      "credentials": credentials
    };
  }

  @override
  DepositAuthorizedResult onResonse(Map<String, dynamic> result) {
    return DepositAuthorizedResult.fromJson(result);
  }
}
