import 'package:blockchain_utils/bip/bip.dart';
import 'package:test/test.dart';
import 'package:xrpl_dart/src/xrpl/address/xrpl.dart';

void main() {
  test('address', () {
    const String address = 'rnmzEq61Xn2o1x1zZkddmG1AAzGzuXWx4w';
    const String xAddress = 'T7edouw8KeqibQjfGsUorWLk8EN8SDVVNQZWGBKKoSoJtks';
    const String xAddress2 = 'T755E9b4EpTcAhLgqeWdmUopY116rF6PhF8XzRAestDhbPV';
    const String address2 = 'rfpYeoTh4NmyJFmGZwrizeAgsUCwRNARGd';
    const String xAddress3 = 'T7uGj5c5nLJSFxZKnFAomPHanva4hzLeLQ9LgALD7VoqGL1';
    const String address3 = 'rwGWdwoyyqbuEn3EHtFdHQkMcYLRrkRhw2';
    const String xAddress4 = 'T7RZ1PLFczhsKSfdiFh5TjLTyVd2yfJyoLE3iY1uWnL5ckv';
    const String address4 = 'rmPRfwhcePGCAB253iSDvRzBac5MTkwZ7';
    const String xAddress5 = 'T7o1vHn6i7nH4gqcCZkeTvsTWEUJ7i3QLRpJP8a5MSwKEcY';
    const String address5 = 'r3cWCCQAwvEprFdYvkrX13ztdaRgrVm46U';
    const int tagAddr5 = 5;

    const String xAddress6 = 'TVht5UgcC79KPuSF921FRNYi7XtpD8KYZRrNUw753QSe7oS';
    const String address6 = 'rDDkUTjnJ1ra8NWv5q4tBYFFPrUGFZG8AM';
    const int tagAddr6 = 1024;
    expect(
      XRPXAddress(xAddress, chainType: ChainType.testnet).classicAddress,
      address,
    );

    expect(
      XRPBaseAddress(address).toXAddress(chainType: ChainType.testnet).address,
      xAddress,
    );
    expect(
      XRPXAddress(xAddress2, chainType: ChainType.testnet).classicAddress,
      address2,
    );
    {
      final addr = XRPBaseAddress(address);
      expect(
        XRPBaseAddress.deserializeIAddress(bytes: addr.encodeAsIAddress()),
        addr,
      );
    }
    expect(
      XRPBaseAddress(address2).toXAddress(chainType: ChainType.testnet).address,
      xAddress2,
    );
    expect(
      XRPXAddress(xAddress3, chainType: ChainType.testnet).classicAddress,
      address3,
    );
    {
      final addr = XRPBaseAddress(address2);
      expect(
        XRPBaseAddress.deserializeIAddress(bytes: addr.encodeAsIAddress()),
        addr,
      );
    }
    {
      final addr = XRPBaseAddress(xAddress6);
      expect(
        XRPBaseAddress.deserializeIAddress(bytes: addr.encodeAsIAddress()),
        addr,
      );
    }
    expect(
      XRPBaseAddress(address3).toXAddress(chainType: ChainType.testnet).address,
      xAddress3,
    );
    expect(
      XRPXAddress(xAddress4, chainType: ChainType.testnet).classicAddress,
      address4,
    );
    expect(
      XRPBaseAddress(address4).toXAddress(chainType: ChainType.testnet).address,
      xAddress4,
    );
    expect(
      XRPXAddress(xAddress5, chainType: ChainType.testnet).classicAddress,
      address5,
    );

    expect(XRPXAddress(xAddress5, chainType: ChainType.testnet).tag, tagAddr5);
    expect(
      XRPBaseAddress(
        address5,
      ).toXAddress(chainType: ChainType.testnet, tag: tagAddr5).address,
      xAddress5,
    );

    expect(
      XRPXAddress(xAddress6, chainType: ChainType.testnet).classicAddress,
      address6,
    );
    expect(XRPXAddress(xAddress6, chainType: ChainType.testnet).tag, tagAddr6);
    expect(
      XRPBaseAddress(
        address6,
      ).toXAddress(chainType: ChainType.testnet, tag: tagAddr6).address,
      xAddress6,
    );
  });
}
