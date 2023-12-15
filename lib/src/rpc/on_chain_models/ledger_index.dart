class XRPLLedgerIndex {
  const XRPLLedgerIndex.index(this._index) : _hash = null;
  const XRPLLedgerIndex.hash(this._hash) : _index = null;
  final String? _hash;
  final String? _index;
  static const XRPLLedgerIndex validated = XRPLLedgerIndex.index("validated");
  static const XRPLLedgerIndex closed = XRPLLedgerIndex.index("closed");
  static const XRPLLedgerIndex current = XRPLLedgerIndex.index("current");

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> toJson = {};
    if (_hash != null) {
      toJson["ledger_hash"] = _hash;
    } else {
      toJson["ledger_index"] = _index;
    }
    return toJson;
  }
}
