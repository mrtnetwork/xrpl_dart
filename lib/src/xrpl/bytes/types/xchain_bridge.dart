part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class _XChainBridgeConst {
  static const List<String> keys = [
    'LockingChainDoor',
    'LockingChainIssue',
    'IssuingChainDoor',
    'IssuingChainIssue'
  ];

  static List<int> toBytesFromType(String key, dynamic value) {
    switch (key) {
      case 'LockingChainIssue':
      case 'IssuingChainIssue':
        return Issue.fromValue(value)._buffer;
      default:
        return [0x14, ...AccountID.fromValue(value)._buffer];
    }
  }

  static Tuple<int?, SerializedType> fromParser(String key, BinaryParser parser,
      [int? lengthHint]) {
    switch (key) {
      case 'LockingChainIssue':
      case 'IssuingChainIssue':
        return Tuple(null, Issue.fromParser(parser, lengthHint));
      default:
        parser.skip(1);
        return Tuple(0x14, AccountID.fromParser(parser, lengthHint));
    }
  }
}

class XChainBridge extends SerializedType {
  XChainBridge(super.buffer);
  @override
  factory XChainBridge.fromValue(Map value) {
    if (CompareUtils.iterableIsEqual(value.keys, _XChainBridgeConst.keys)) {
      final bytes = DynamicByteTracker();
      for (final i in _XChainBridgeConst.keys) {
        final buffer = _XChainBridgeConst.toBytesFromType(i, value[i]);
        bytes.add(buffer);
      }
      return XChainBridge(bytes.toBytes());
    }
    throw const XRPLBinaryCodecException('Invalid XChainBridge argruments');
  }

  @override
  factory XChainBridge.fromParser(BinaryParser parser, [int? lengthHint]) {
    final bytes = DynamicByteTracker();
    for (final i in _XChainBridgeConst.keys) {
      final buffer = _XChainBridgeConst.fromParser(i, parser, lengthHint);
      if (buffer.item1 != null) {
        bytes.add([buffer.item1!]);
      }
      bytes.add(buffer.item2.toBytes());
    }
    return XChainBridge(bytes.toBytes());
  }

  @override
  dynamic toJson() {
    final parser = BinaryParser(toBytes());
    final Map<String, String> toJson = {};
    for (final i in _XChainBridgeConst.keys) {
      final buffer = _XChainBridgeConst.fromParser(i, parser);
      toJson[i] = buffer.item2.toJson();
    }
    return toJson;
  }
}
