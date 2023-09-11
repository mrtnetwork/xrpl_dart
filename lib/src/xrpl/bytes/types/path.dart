part of 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';

const int _typeAccount = 0x01;
const int _typeCurrency = 0x10;
const int _typeIssuer = 0x20;

const int _pathSetEndByte = 0x00;
const int _pathSeperatorByte = 0xFF;

Map _toLowerKeys(Map map) {
  return {for (final i in map.entries) i.key.toString().toLowerCase(): i.value};
}

bool _isPathStep(Map value) {
  final lowerKeysMap = _toLowerKeys(value);

  return lowerKeysMap.containsKey("issuer") ||
      lowerKeysMap.containsKey("account") ||
      lowerKeysMap.containsKey("currency");
}

bool _isPathSet(List<dynamic> value) {
  return value.isEmpty || value.first.isEmpty || _isPathStep(value.first.first);
}

class PathStep extends SerializedType {
  PathStep([Uint8List? buffer]) : super(buffer);

  @override
  factory PathStep.fromValue(dynamic value) {
    if (value is! Map) {
      throw XRPLBinaryCodecException(
          'Invalid type to construct a PathStep: expected dict, received ${value.runtimeType}.');
    }
    int dataType = 0x00;
    final dynamicBytes = DynamicByteTracker();
    final lowerKeysMap = _toLowerKeys(value);
    try {
      if (lowerKeysMap.containsKey('account')) {
        final accountId = AccountID.fromValue(lowerKeysMap['account']);
        dynamicBytes.add(accountId.buffer);
        dataType |= _typeAccount;
      }
      if (lowerKeysMap.containsKey('currency')) {
        final currency = Currency.fromValue(lowerKeysMap['currency']);
        dynamicBytes.add(currency.buffer);
        dataType |= _typeCurrency;
      }
      if (lowerKeysMap.containsKey('issuer')) {
        final issuer = AccountID.fromValue(lowerKeysMap['issuer']);
        dynamicBytes.add(issuer.buffer);
        dataType |= _typeIssuer;
      }

      return PathStep(
          Uint8List.fromList([dataType, ...dynamicBytes.toBytes()]));
    } finally {
      dynamicBytes.close();
    }
  }

  @override
  factory PathStep.fromParser(BinaryParser parser, [int? lengthHint]) {
    final dataType = parser.readUint8();
    final dynamicBytes = DynamicByteTracker();

    try {
      if ((dataType & _typeAccount) != 0) {
        final accountId = parser.read(Hash160.lengthBytes);
        dynamicBytes.add(accountId);
      }
      if ((dataType & _typeCurrency) != 0) {
        final currency = parser.read(Hash160.lengthBytes);
        dynamicBytes.add(currency);
      }
      if ((dataType & _typeIssuer) != 0) {
        final issuer = parser.read(Hash160.lengthBytes);
        dynamicBytes.add(issuer);
      }

      return PathStep(
          Uint8List.fromList([dataType, ...dynamicBytes.toBytes()]));
    } finally {
      dynamicBytes.close();
    }
  }

  @override
  Map<String, String> toJson() {
    final parser = BinaryParser(bytesToHex(buffer));
    final dataType = parser.readUint8();
    final json = <String, String>{};

    if ((dataType & _typeAccount) != 0) {
      final accountId = AccountID.fromParser(parser).toJson();
      json['account'] = accountId;
    }
    if ((dataType & _typeCurrency) != 0) {
      final currency = Currency.fromParser(parser).toJson();
      json['currency'] = currency;
    }
    if ((dataType & _typeIssuer) != 0) {
      final issuer = AccountID.fromParser(parser).toJson();
      json['issuer'] = issuer;
    }

    return json;
  }

  int get type => buffer[0];
}

class Path extends SerializedType {
  Path([Uint8List? buffer]) : super(buffer);

  @override
  factory Path.fromValue(dynamic value) {
    if (value is! List) {
      throw XRPLBinaryCodecException(
          'Invalid type to construct a Path: expected list, received ${value.runtimeType}.');
    }

    final dynamicBytes = DynamicByteTracker();
    try {
      for (final pathStepDict in value) {
        final pathStep = PathStep.fromValue(pathStepDict);
        dynamicBytes.add(pathStep.buffer);
      }

      return Path(dynamicBytes.toBytes());
    } finally {
      dynamicBytes.close();
    }
  }

  @override
  factory Path.fromParser(BinaryParser parser, [int? lengthHint]) {
    final dynamicBytes = DynamicByteTracker();
    try {
      while (!parser.isEnd()) {
        final pathStep = PathStep.fromParser(parser);
        dynamicBytes.add(pathStep.buffer);

        final peek = parser.peek();
        if (peek == _pathSetEndByte || peek == _pathSeperatorByte) {
          break;
        }
      }

      return Path(dynamicBytes.toBytes());
    } finally {
      dynamicBytes.close();
    }
  }

  @override
  List<Map<String, dynamic>> toJson() {
    final json = <Map<String, dynamic>>[];
    final pathParser = BinaryParser(bytesToHex(buffer));

    while (!pathParser.isEnd()) {
      final pathStep = PathStep.fromParser(pathParser);
      json.add(pathStep.toJson());
    }

    return json;
  }
}

class PathSet extends SerializedType {
  PathSet([Uint8List? buffer]) : super(buffer);

  @override
  factory PathSet.fromValue(dynamic value) {
    if (value is! List) {
      throw XRPLBinaryCodecException(
          'Invalid type to construct a PathSet: expected list, received ${value.runtimeType}.');
    }

    if (_isPathSet(value)) {
      final dynamicBytes = DynamicByteTracker();
      try {
        for (final pathDict in value) {
          final path = Path.fromValue(pathDict);
          dynamicBytes.add(path.buffer);
          dynamicBytes.add([_pathSeperatorByte]);
        }
        Uint8List buff = dynamicBytes.toBytes();
        buff[buff.length - 1] = _pathSetEndByte;
        return PathSet(buff);
      } finally {
        dynamicBytes.close();
      }
    }

    throw XRPLBinaryCodecException('Cannot construct PathSet from given value');
  }

  @override
  factory PathSet.fromParser(BinaryParser parser, [int? lengthHint]) {
    final dynamicBytes = DynamicByteTracker();
    try {
      while (!parser.isEnd()) {
        final path = Path.fromParser(parser);
        dynamicBytes.add(path.buffer);
        dynamicBytes.add(parser.read(1));

        if (dynamicBytes.last == _pathSetEndByte) {
          break;
        }
      }
      return PathSet(dynamicBytes.toBytes());
    } finally {
      dynamicBytes.close();
    }
  }

  @override
  List<List<Map<String, dynamic>>> toJson() {
    final json = <List<Map<String, dynamic>>>[];
    final pathSetParser = BinaryParser(bytesToHex(buffer));

    while (!pathSetParser.isEnd()) {
      final path = Path.fromParser(pathSetParser);
      json.add(path.toJson());
      pathSetParser.skip(1);
    }

    return json;
  }
}
