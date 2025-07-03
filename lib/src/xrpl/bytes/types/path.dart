part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class _PathUtils {
  static const int _typeAccount = 0x01;
  static const int _typeCurrency = 0x10;
  static const int _typeIssuer = 0x20;

  static const int _pathSetEndByte = 0x00;
  static const int _pathSeperatorByte = 0xFF;

  static Map _toLowerKeys(Map map) {
    return {
      for (final i in map.entries) i.key.toString().toLowerCase(): i.value
    };
  }

  static bool _isPathStep(Map value) {
    final lowerKeysMap = _toLowerKeys(value);

    return lowerKeysMap.containsKey('issuer') ||
        lowerKeysMap.containsKey('account') ||
        lowerKeysMap.containsKey('currency');
  }

  static bool _isPathSet(List<dynamic> value) {
    return value.isEmpty ||
        value.first.isEmpty ||
        _isPathStep(value.first.first);
  }
}

class PathStepCodec extends SerializedType {
  PathStepCodec(super.buffer);

  @override
  factory PathStepCodec.fromValue(Map value) {
    int dataType = 0x00;
    final dynamicBytes = DynamicByteTracker();
    final lowerKeysMap = _PathUtils._toLowerKeys(value);
    if (lowerKeysMap.containsKey('account')) {
      final accountId = AccountID.fromValue(lowerKeysMap['account']);
      dynamicBytes.add(accountId._buffer);
      dataType |= _PathUtils._typeAccount;
    }
    if (lowerKeysMap.containsKey('currency')) {
      final currency = Currency.fromValue(lowerKeysMap['currency']);
      dynamicBytes.add(currency._buffer);
      dataType |= _PathUtils._typeCurrency;
    }
    if (lowerKeysMap.containsKey('issuer')) {
      final issuer = AccountID.fromValue(lowerKeysMap['issuer']);
      dynamicBytes.add(issuer._buffer);
      dataType |= _PathUtils._typeIssuer;
    }

    return PathStepCodec(List<int>.from([dataType, ...dynamicBytes.toBytes()]));
  }

  @override
  factory PathStepCodec.fromParser(BinaryParser parser, [int? lengthHint]) {
    final dataType = parser.readUint8();
    final dynamicBytes = DynamicByteTracker();

    if ((dataType & _PathUtils._typeAccount) != 0) {
      final accountId = parser.read(Hash160.lengthBytes);
      dynamicBytes.add(accountId);
    }
    if ((dataType & _PathUtils._typeCurrency) != 0) {
      final currency = parser.read(Hash160.lengthBytes);
      dynamicBytes.add(currency);
    }
    if ((dataType & _PathUtils._typeIssuer) != 0) {
      final issuer = parser.read(Hash160.lengthBytes);
      dynamicBytes.add(issuer);
    }

    return PathStepCodec(List<int>.from([dataType, ...dynamicBytes.toBytes()]));
  }

  @override
  Map<String, String> toJson() {
    final parser = BinaryParser(_buffer);
    final dataType = parser.readUint8();
    final json = <String, String>{};

    if ((dataType & _PathUtils._typeAccount) != 0) {
      final accountId = AccountID.fromParser(parser).toJson();
      json['account'] = accountId;
    }
    if ((dataType & _PathUtils._typeCurrency) != 0) {
      final currency = Currency.fromParser(parser).toJson();
      json['currency'] = currency;
    }
    if ((dataType & _PathUtils._typeIssuer) != 0) {
      final issuer = AccountID.fromParser(parser).toJson();
      json['issuer'] = issuer;
    }

    return json;
  }

  int get type => _buffer[0];
}

class PathCodec extends SerializedType {
  PathCodec(super.buffer);

  @override
  factory PathCodec.fromValue(List value) {
    final dynamicBytes = DynamicByteTracker();
    for (final pathStepDict in value) {
      final pathStep = PathStepCodec.fromValue(pathStepDict);
      dynamicBytes.add(pathStep._buffer);
    }

    return PathCodec(dynamicBytes.toBytes());
  }

  @override
  factory PathCodec.fromParser(BinaryParser parser, [int? lengthHint]) {
    final dynamicBytes = DynamicByteTracker();
    while (!parser.isEnd()) {
      final pathStep = PathStepCodec.fromParser(parser);
      dynamicBytes.add(pathStep._buffer);

      final peek = parser.peek();
      if (peek == _PathUtils._pathSetEndByte ||
          peek == _PathUtils._pathSeperatorByte) {
        break;
      }
    }

    return PathCodec(dynamicBytes.toBytes());
  }

  @override
  List<Map<String, dynamic>> toJson() {
    final json = <Map<String, dynamic>>[];
    final pathParser = BinaryParser(_buffer);

    while (!pathParser.isEnd()) {
      final pathStep = PathStepCodec.fromParser(pathParser);
      json.add(pathStep.toJson());
    }

    return json;
  }
}

class PathSetCodec extends SerializedType {
  PathSetCodec(super.buffer);

  @override
  factory PathSetCodec.fromValue(List value) {
    if (_PathUtils._isPathSet(value)) {
      final dynamicBytes = DynamicByteTracker();
      for (final pathDict in value) {
        final path = PathCodec.fromValue(pathDict);
        dynamicBytes.add(path._buffer);
        dynamicBytes.add([_PathUtils._pathSeperatorByte]);
      }
      final List<int> buff = dynamicBytes.toBytes();
      buff[buff.length - 1] = _PathUtils._pathSetEndByte;
      return PathSetCodec(buff);
    }

    throw const XRPLBinaryCodecException(
        'Cannot construct PathSet from given value');
  }

  @override
  factory PathSetCodec.fromParser(BinaryParser parser, [int? lengthHint]) {
    final dynamicBytes = DynamicByteTracker();
    while (!parser.isEnd()) {
      final path = PathCodec.fromParser(parser);
      dynamicBytes.add(path._buffer);
      dynamicBytes.add(parser.read(1));

      if (dynamicBytes.last == _PathUtils._pathSetEndByte) {
        break;
      }
    }
    return PathSetCodec(dynamicBytes.toBytes());
  }

  @override
  List<List<Map<String, dynamic>>> toJson() {
    final json = <List<Map<String, dynamic>>>[];
    final pathSetParser = BinaryParser(_buffer);

    while (!pathSetParser.isEnd()) {
      final path = PathCodec.fromParser(pathSetParser);
      json.add(path.toJson());
      pathSetParser.skip(1);
    }

    return json;
  }
}
