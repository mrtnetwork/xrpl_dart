import 'package:blockchain_utils/binary/binary.dart';
import 'package:xrp_dart/xrp_dart.dart';

import 'test_vector.dart';

void main() {
  for (final i in vecotr) {
    final secretBytes = BytesUtils.fromHexString(i["preimage"]!);
    final preImagae = FulfillmentPreimageSha256.generate(secretBytes);
    assert(preImagae.fulfillment == i["fulfillment"]);
    assert(preImagae.condition == i["condition"]);
  }
}
