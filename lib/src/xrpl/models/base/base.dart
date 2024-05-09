abstract class FlagsInterface {
  abstract final int id;
}

abstract class XRPLBase {
  /// Converts the object to a JSON representation.
  Map<String, dynamic> toJson();
  String? get validate => null;
}
