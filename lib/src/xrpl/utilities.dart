void addWhenNotNull(Map<String, dynamic> json, String key, dynamic value) {
  if (value == null) return;
  json[key] = value;
}

int datetimeToRippleTime(DateTime dt) {
  const int rippleEpoch = 946684800;
  const int maxXRPLTime = 4294967296;

  int rippleTime = dt.toUtc().millisecondsSinceEpoch ~/ 1000 - rippleEpoch;

  if (rippleTime < 0) {
    throw ArgumentError('Datetime $dt is before the Ripple Epoch');
  }

  if (rippleTime >= maxXRPLTime) {
    throw ArgumentError(
        '$dt is later than any time that can be expressed on the XRP Ledger.');
  }

  return rippleTime;
}
