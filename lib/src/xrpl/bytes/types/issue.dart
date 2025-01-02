part of 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';

class Issue extends SerializedType {
  Issue(super.buffer);

  @override
  factory Issue.fromValue(Map value) {
    if (value.containsKey('Issuer') || value.containsKey('issuer')) {
      final currencyBytes =
          Currency.fromValue(value['Currency'] ?? value['currency']).toBytes();

      final issuerBytes =
          AccountID.fromValue(value['Issuer'] ?? value['issuer']).toBytes();
      return Issue(List<int>.from([...currencyBytes, ...issuerBytes]));
    }
    final currencyBytes =
        Currency.fromValue(value['Currency'] ?? value['currency']).toBytes();
    return Issue(currencyBytes);
  }

  factory Issue.fromParser(BinaryParser parser, [int? lengthHint]) {
    final currency = Currency.fromParser(parser, null);
    if (currency.toJson() == _CurrencyUtils.xrpIsoName) {
      return Issue(currency.toBytes());
    }
    final issuer = parser.read(20);
    return Issue(List<int>.from([...currency.toBytes(), ...issuer]));
  }

  @override
  Map<String, dynamic> toJson() {
    final parser = BinaryParser(_buffer);
    final currencyOrXRP = Currency.fromParser(parser, null).toJson();
    if (currencyOrXRP == _CurrencyUtils.xrpIsoName) {
      return {'currency': currencyOrXRP};
    }

    final issuer = AccountID.fromParser(parser, null).toJson();
    return {'currency': currencyOrXRP, 'issuer': issuer};
  }
}
