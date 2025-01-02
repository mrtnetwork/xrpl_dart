import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';
import 'package:xrpl_dart/src/xrpl/models/currencies/currencies.dart';
import '../core/methods_impl.dart';

class PathFindSubcommand {
  /// Represents a PathFindSubcommand for creating a path.
  static const PathFindSubcommand create = PathFindSubcommand._('create');

  /// Represents a PathFindSubcommand for closing a path.
  static const PathFindSubcommand close = PathFindSubcommand._('close');

  /// Represents a PathFindSubcommand for checking the status of a path.
  static const PathFindSubcommand status = PathFindSubcommand._('status');

  /// The string value associated with each PathFindSubcommand.
  final String value;

  /// Private constructor to initialize the string value for each PathFindSubcommand.
  const PathFindSubcommand._(this.value);
}

/// WebSocket API only! The path_find method searches for a
/// path along which a transaction can possibly be made, and
/// periodically sends updates when the path changes over time.
/// For a simpler version that is supported by JSON-XRPRequest, see the
/// ripple_path_find method. For payments occurring strictly in XRP,
/// it is not necessary to find a path, because XRP can be sent
/// directly to any account.
/// Although the rippled server tries to find the cheapest path or combination
/// of paths for making a payment, it is not guaranteed that the paths returned
/// by this method are, in fact, the best paths. Due to server load,
/// pathfinding may not find the best results. Additionally, you should be
/// careful with the pathfinding results from untrusted servers. A server
/// could be modified to return less-than-optimal paths to earn money for its
/// operators. If you do not have your own server that you can trust with
/// pathfinding, you should compare the results of pathfinding from multiple
/// servers run by different parties, to minimize the risk of a single server
/// returning poor results. (Note: A server returning less-than-optimal
/// results is not necessarily proof of malicious behavior; it could also be
/// a symptom of heavy server load.)
class XRPRequestPathFind
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestPathFind(
      {required this.subcommand,
      required this.sourceAccount,
      required this.destinationAccount,
      required this.destinationAmount,
      this.sendMax,
      this.paths});
  @override
  String get method => XRPRequestMethod.pathFind;
  final PathFindSubcommand subcommand;
  final String sourceAccount;
  final String destinationAccount;
  final CurrencyAmount destinationAmount;
  final CurrencyAmount? sendMax;
  final List<List<PathStep>>? paths;

  @override
  Map<String, dynamic> toJson() {
    return {
      'subcommand': subcommand.value,
      'source_account': sourceAccount,
      'destination_account': destinationAccount,
      'destination_amount': destinationAmount.toJson(),
      'send_max': sendMax?.toJson(),
      'paths': paths?.map((e) => e.map((e) => e.toJson()).toList()).toList()
    };
  }
}
