import 'package:xrp_dart/src/rpc/methods/methods.dart';
import '../core/methods_impl.dart';

class RPCTx extends XRPLedgerRequest<Map<String, dynamic>> {
  RPCTx(
      {required this.transaction,
      this.maxLedger,
      this.minLedger,
      this.binary = false});
  @override
  String get method => XRPRequestMethod.tx;

  final String transaction;
  final bool binary;
  final int? minLedger;
  final int? maxLedger;

  @override
  Map<String, dynamic> toJson() {
    return {
      "transaction": transaction,
      "max_ledger": maxLedger,
      "min_ledger": minLedger,
      "binary": binary,
    };
  }
}
