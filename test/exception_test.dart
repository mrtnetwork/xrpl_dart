import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:test/test.dart' show test, expect, equals;
import 'package:xrpl_dart/xrpl_dart.dart';

import 'utils.dart';

void exceptionTest() {
  test('Exception serialization', () {
    BuErrorCodec.registerTypes(XrplErrorType.values);
    {
      final error = const BuError(
        XrplErrorType.plugin,
        "error",
        details: {"length": "32"},
      );
      final decode = BuErrorCodec.decode(bytes: error.toCborBytes());
      expect(decode.type, XrplErrorType.plugin);
      expect(decode.message, "error");
      expect(decode.details, {"length": "32"});
    }
    {
      final error = const BuError(
        XrplErrorType.binaryCodec,
        "error",
        details: {"length": "32"},
      );
      final decode = BuErrorCodec.decode(bytes: error.toCborBytes());
      expect(decode.type, XrplErrorType.binaryCodec);
      expect(decode.message, "error");
    }
    {
      final error = const BuError(
        XrplErrorType.addressCodec,
        "error",
        details: {"length": "32"},
      );
      final decode = BuErrorCodec.decode(bytes: error.toCborBytes());
      expect(decode.type, XrplErrorType.addressCodec);
      expect(decode.message, "error");
    }
    {
      final error = const BuError(
        XrplErrorType.asn1,
        "error",
        details: {"length": "32"},
      );
      final decode = BuErrorCodec.decode(bytes: error.toCborBytes());
      expect(decode.type, XrplErrorType.asn1);
      expect(decode.message, "error");
    }
    {
      final ids = XrplErrorType.values.map((e) => e.id);
      expect(ids.toSet().length, XrplErrorType.values.length);
      for (final id in ids) {
        expect(id > 258, equals(true));
      }
    }
  });
}

void main() {
  XrplTestApi.runTest(exceptionTest, 'Exception');
}
