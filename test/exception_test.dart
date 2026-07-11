import 'package:test/test.dart' show test, expect;
import 'package:xrpl_dart/xrpl_dart.dart';

void main() {
  test('Exception serialization', () {
    {
      final error = XRPLPluginException("error", details: {"length": "32"});
      final decode = BaseXRPLPluginException.deserialize(
        bytes: error.toCbor().encode(),
      );
      expect(decode, error);
    }
    {
      final error = XRPLBinaryCodecException(
        "error",
        details: {"length": "32"},
      );
      final decode = BaseXRPLPluginException.deserialize(
        bytes: error.toCbor().encode(),
      );
      expect(decode, error);
    }
    {
      final error = XRPLAddressCodecException(
        "error",
        details: {"length": "32"},
      );
      final decode = BaseXRPLPluginException.deserialize(
        bytes: error.toCbor().encode(),
      );
      expect(decode, error);
    }
    {
      final error = ASN1CodecException("error", details: {"length": "32"});
      final decode = BaseXRPLPluginException.deserialize(
        bytes: error.toCbor().encode(),
      );
      expect(decode, error);
    }
  });
}
