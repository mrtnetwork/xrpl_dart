// ignore_for_file: constant_identifier_names

enum PathFindSubcommand {
  CREATE("create"),
  CLOSE("close"),
  STATUS("status");

  final String value;
  const PathFindSubcommand(this.value);
}
