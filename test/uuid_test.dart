import 'package:flutter_test/flutter_test.dart';
import 'package:xrp_dart/src/crypto/uuid.dart';

void main() {
  test("TEST UUID", () {
    for (int i = 0; i < 1000; i++) {
      final uuid = UUID.generateUUIDv4();
      final toBuffer = UUID.toBuffer(uuid);
      final fromBuffer = UUID.fromBuffer(toBuffer);
      expect(uuid, fromBuffer);
    }
  });
}
