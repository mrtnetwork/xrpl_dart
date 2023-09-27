// ignore_for_file: constant_identifier_names
/// There are three different modes, or sub-commands, of the path_find
/// command. Specify which one you want with the subcommand parameter:

/// create - Start sending pathfinding information
/// close - Stop sending pathfinding information
/// status - Get the information of the currently-open pathfinding request
enum PathFindSubcommand {
  /// create - Start sending pathfinding information
  CREATE("create"),

  /// Stop sending pathfinding information
  CLOSE("close"),

  /// Get the information of the currently-open pathfinding request
  STATUS("status");

  final String value;
  const PathFindSubcommand(this.value);
}
