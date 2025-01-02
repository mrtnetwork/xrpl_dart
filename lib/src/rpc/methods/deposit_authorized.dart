import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/on_chain_models/on_chain_models.dart';
import '../core/methods_impl.dart';

/// The deposit_authorized command indicates whether one account
/// is authorized to send payments directly to another. See
/// Deposit Authorization for information on how to require
/// authorization to deliver money to your account.
class XRPRequestDepositAuthorized
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestDepositAuthorized({
    required this.sourceAccount,
    required this.destinationAccount,
    super.ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.depositAuthorized;

  final String sourceAccount;
  final String destinationAccount;

  @override
  Map<String, dynamic> toJson() {
    return {
      'source_account': sourceAccount,
      'destination_account': destinationAccount,
    };
  }
}
