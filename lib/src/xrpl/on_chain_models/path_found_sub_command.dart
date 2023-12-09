/// There are three different modes, or sub-commands, of the path_find
/// command. Specify which one you want with the subcommand parameter:
enum PathFindSubcommand {
  /// create - Start sending pathfinding information
  create("create"),

  /// Stop sending pathfinding information
  close("close"),

  /// Get the information of the currently-open pathfinding request
  status("status");

  final String value;
  const PathFindSubcommand(this.value);
}
