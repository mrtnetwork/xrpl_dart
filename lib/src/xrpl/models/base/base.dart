abstract class FlagsInterface {
  abstract final int id;
}

abstract class XRPLBase {
  /// Converts the object to a JSON representation.
  Map<String, dynamic> toJson();
  String? get validate => null;

  /// Adds a key-value pair to a JSON map if the value is not null.
  /// If the value is null, no key-value pair is added.
  static void addWhenNotNull(
      Map<String, dynamic> json, String key, dynamic value) {
    if (value == null) return;
    json[key] = value;
  }
}
