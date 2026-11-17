/// Unified result types for [XRPQuickClientApi] (wallet/swap parity).
///
/// One unified type per top call so consumers never touch raw request
/// classes for submission/status.
enum XRPQuickTxStatus {
  /// The transaction is validated in a ledger.
  block,

  /// The transaction failed (`tesSUCCESS` not reached / `validated` with a
  /// failure code).
  failed,

  /// The transaction is not validated yet.
  pending,
}
