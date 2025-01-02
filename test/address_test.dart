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
        XRPAddress.fromXAddress(xAddress, isTestnet: true).toString(), address);
    expect(XRPAddress(address).toXAddress(isTestnet: true), xAddress);
    expect(XRPAddress.fromXAddress(xAddress2, isTestnet: true).toString(),
        address2);
    expect(XRPAddress(address2).toXAddress(isTestnet: true), xAddress2);
    expect(XRPAddress.fromXAddress(xAddress3, isTestnet: true).toString(),
        address3);
    expect(XRPAddress(address3).toXAddress(isTestnet: true), xAddress3);
    expect(XRPAddress.fromXAddress(xAddress4, isTestnet: true).toString(),
        address4);
    expect(XRPAddress(address4).toXAddress(isTestnet: true), xAddress4);
    expect(XRPAddress.fromXAddress(xAddress5, isTestnet: true).toString(),
        address5);
    expect(XRPAddress.fromXAddress(xAddress5, isTestnet: true).tag, tagAddr5);
    expect(XRPAddress(address5).toXAddress(isTestnet: true, tag: tagAddr5),
        xAddress5);

    expect(XRPAddress.fromXAddress(xAddress6, isTestnet: true).toString(),
        address6);
    expect(XRPAddress.fromXAddress(xAddress6, isTestnet: true).tag, tagAddr6);
    expect(XRPAddress(address6).toXAddress(isTestnet: true, tag: tagAddr6),
        xAddress6);
  });
}
