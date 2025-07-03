import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/models/models/response.dart';
import '../core/methods_impl.dart';

class XRPRequestTx extends XRPLedgerRequest<TxResult, Map<String, dynamic>> {
  XRPRequestTx(
      {this.transaction,
      this.ctid,
      this.maxLedger,
      this.minLedger,
      this.binary = false});
  @override
  String get method => XRPRequestMethod.tx;

  final String? transaction;
  final String? ctid;
  final bool binary;
  final int? minLedger;
  final int? maxLedger;

  @override
  Map<String, dynamic> toJson() {
    return {
      'transaction': transaction,
      'max_ledger': maxLedger,
      'min_ledger': minLedger,
      'binary': binary,
    };
  }

  @override
  TxResult onResonse(Map<String, dynamic> result) {
    return TxResult.fromJson(result);
  }
}
