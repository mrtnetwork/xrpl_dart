part of 'package:xrp_dart/src/xrpl/bytes/types/xrpl_types.dart';

class Issue extends SerializedType {
  Issue([Uint8List? buffer]) : super(buffer);

  @override
  factory Issue.fromValue(dynamic value) {
    if (value is! Map) {
      throw XRPLBinaryCodecException(
          'Invalid type to construct an Issue: expected Map<String, String> or dict, received ${value.runtimeType}.');
    }
    if (value.containsKey("Issuer") || value.containsKey("ossuer")) {
      final currencyBytes =
          Currency.fromValue(value['Currency'] ?? value['currency']).toBytes();

      final issuerBytes =
          AccountID.fromValue(value['Issuer'] ?? value['issuer']).toBytes();
      return Issue(Uint8List.fromList([...currencyBytes, ...issuerBytes]));
    }
    final currencyBytes =
        Currency.fromValue(value['Currency'] ?? value['currency']).toBytes();
    return Issue(currencyBytes);
  }

  factory Issue.fromParser(BinaryParser parser, [int? lengthHint]) {
    final currency = Currency.fromParser(parser, null);
    if (currency.toJson() == 'XRP') {
      return Issue(currency.toBytes());
    }
    final issuer = parser.read(20);
    return Issue(Uint8List.fromList([...currency.toBytes(), ...issuer]));
  }

  @override
  Map<String, dynamic> toJson() {
    final parser = BinaryParser(toString());
    final currencyOrXRP = Currency.fromParser(parser, null).toJson();
    if (currencyOrXRP == 'XRP') {
      return {'currency': currencyOrXRP};
    }

    final issuer = AccountID.fromParser(parser, null).toJson();
    return {'currency': currencyOrXRP, 'issuer': issuer};
  }
}
