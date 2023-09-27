/// Adds a key-value pair to a JSON map if the value is not null.
/// If the value is null, no key-value pair is added.
void addWhenNotNull(Map<String, dynamic> json, String key, dynamic value) {
  if (value == null) return;
  json[key] = value;
}

/// This function converts a DateTime object to Ripple time format.
int datetimeToRippleTime(DateTime dt) {
  /// Constants for the Ripple Epoch and maximum XRPL time.
  const int rippleEpoch = 946684800;
  const int maxXRPLTime = 4294967296;

  /// Calculate the Ripple time.
  int rippleTime = dt.toUtc().millisecondsSinceEpoch ~/ 1000 - rippleEpoch;

  /// Check if the calculated time is before the Ripple Epoch.
  if (rippleTime < 0) {
    throw ArgumentError('Datetime $dt is before the Ripple Epoch');
  }

  /// Check if the calculated time is later than the maximum XRPL time.
  if (rippleTime >= maxXRPLTime) {
    throw ArgumentError(
        '$dt is later than any time that can be expressed on the XRP Ledger.');
  }

  /// Return the calculated Ripple time.
  return rippleTime;
}
