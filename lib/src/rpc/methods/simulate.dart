import 'package:xrpl_dart/src/rpc/core/methods_impl.dart';
import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/models/models/response.dart';

class XRPRequestSimulateTx
    extends XRPLedgerRequest<SimulateResult, Map<String, dynamic>> {
  XRPRequestSimulateTx({
    required this.txBlob,
    this.binary = false,
  });
  @override
  String get method => XRPRequestMethod.simulate;

  final String txBlob;
  final bool binary;

  @override
  Map<String, dynamic> toJson() {
    return {'tx_blob': txBlob, 'binary': binary};
  }

  @override
  SimulateResult onResonse(Map<String, dynamic> result) {
    return SimulateResult.fromJson(result);
  }
}
