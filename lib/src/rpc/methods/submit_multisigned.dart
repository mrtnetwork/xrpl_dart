import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/xrpl/models/base/transaction.dart';
import '../core/methods_impl.dart';

/// The submit_multisigned command applies a multi-signed transaction and sends it to
/// the network to be included in future ledgers. (You can also submit multi-signed
/// transactions in binary form using the submit command in submit-only mode.)
/// This command requires the MultiSign amendment to be enabled.
/// See [submit_multisigned](https://xrpl.org/submit_multisigned.html)
class XRPRequestSubmitMultisigned
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestSubmitMultisigned({
    required this.tx,
    this.failHard = false,
  });
  @override
  String get method => XRPRequestMethod.submitMultisigned;

  final XRPTransaction tx;
  final bool failHard;

  @override
  Map<String, dynamic> toJson() {
    return {'tx_json': tx.toXrpl(), 'fail_hard': failHard};
  }
}
