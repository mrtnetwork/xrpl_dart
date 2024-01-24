import 'package:blockchain_utils/binary/binary.dart';
import 'package:test/test.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

import 'test_vector.dart';

void main() {
  test("fullfillment", () {
    for (final i in vecotr) {
      final secretBytes = BytesUtils.fromHexString(i["preimage"]!);
      final preImagae = FulfillmentPreimageSha256.generate(secretBytes);
      expect(preImagae.fulfillment, i["fulfillment"]);
      expect(preImagae.condition, i["condition"]);
    }
  });
}
