import 'package:blockchain_utils/utils/binary/utils.dart';
import 'package:test/test.dart';
import 'package:xrpl_dart/src/utility/fulfillment/pre_image/pre_image_sha256.dart';

import 'test_vector.dart';

void main() {
  test('fullfillment', () {
    for (final i in vecotr) {
      final secretBytes = BytesUtils.fromHexString(i['preimage']!);
      final preImagae = FulfillmentPreimageSha256.generate(secretBytes);
      expect(preImagae.fulfillment, i['fulfillment']);
      expect(preImagae.condition, i['condition']);
    }
  });
}
