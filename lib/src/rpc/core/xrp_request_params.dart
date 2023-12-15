/// An abstract class defining the common structure for XRP (XRP Ledger) request parameters.
abstract class XRPRequestParams {
  /// The RPC method associated with the request.
  ///
  /// Subclasses must implement this property to specify the RPC method for the request.
  abstract final String method;

  /// Converts the request parameters to a JSON representation.
  ///
  /// Subclasses must implement this method to define how the request parameters are serialized to JSON.
  Map<String, dynamic> toJson();
}
