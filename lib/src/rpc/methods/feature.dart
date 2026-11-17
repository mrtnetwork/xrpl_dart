import 'package:xrpl_dart/src/rpc/rpc.dart';

/// The feature command returns information about amendments this server
/// knows about, including whether they are enabled.
class XRPRequestFeature
    extends XRPLedgerRequest<FeatureResult, Map<String, dynamic>> {
  /// If provided, limits the response to one amendment, identified either by
  /// its unique amendment ID (hexadecimal) or its short name.
  XRPRequestFeature({this.feature});
  @override
  String get method => XRPRequestMethod.feature;

  final String? feature;

  @override
  Map<String, dynamic> toJson() {
    return {'feature': feature};
  }

  @override
  FeatureResult onResponse(Map<String, dynamic> result) {
    return FeatureResult.fromJson(result);
  }
}
