class XRPLLedgerIndex {
  const XRPLLedgerIndex(this.value);
  final dynamic value;
  static const XRPLLedgerIndex validated = XRPLLedgerIndex("validated");
  static const XRPLLedgerIndex closed = XRPLLedgerIndex("closed");
  static const XRPLLedgerIndex current = XRPLLedgerIndex("current");
}
