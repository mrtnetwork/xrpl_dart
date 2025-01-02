import 'package:test/test.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void main() async {
  test('fromEntropy SECP256K1', () {
    const String privateHex =
        '00E290DA3DA124B4BF9B68EB023CB57D313F016D36EF395ED03791521B83C66BE6';
    const String publicKeyHex =
        '027190BF2204E1F99A9346C0717508788A73A8A3B7E5A925C349969ED1BA7FF2A0';
    const String classicAddress = 'rs3xN42EFLE23gUDG2Rw4rwxhR9MnjwZKQ';
    const String xAddress = 'X72W51px1i7iPTf4EwKFY2Nygdh5tGGNkvBFfbiuXKPxEPY';
    const String xTestNetAddress =
        'T7Ws3yBAjFp1Fx1yWyhbSZztwhbXPqvG5a9GRHaSf1fZnqk';
    final private = XRPPrivateKey.fromEntropy(
        'f7f9ff93d716eaced222a3c52a3b2a36',
        algorithm: XRPKeyAlgorithm.secp256k1);
    expect(private.toHex(), privateHex);
    expect(private.getPublic().toHex(), publicKeyHex);
    expect(private.getPublic().toAddress().address, classicAddress);
    expect(private.getPublic().toAddress().toXAddress(), xAddress);
    expect(private.getPublic().toAddress().toXAddress(isTestnet: true),
        xTestNetAddress);
  });
  test('fromEntropy ED25519', () {
    const String privateHex =
        'EDA53A87FB516F4F7409105E5A43A4B07EF43E42CBF7CB72B3D8020DC12F27CE14';
    const String publicKeyHex =
        'EDFB7C70E528FE161ADDFDA8CB224BC19B9E6455916970F7992A356C3E77AC7EF8';
    const String classicAddress = 'rELnd6Ae5ZYDhHkaqjSVg2vgtBnzjeDshm';
    const String xAddress = 'XVGNvtm1P2N6A6oyQ3TWFsjyXS124KjGTNeki4i9E5DGVp1';
    const String xTestNetAddress =
        'TVBmLzviEX8jPD22CAUH5sV1ztQ41uPJQQcDwhnCiMVzSCn';
    final private = XRPPrivateKey.fromEntropy(
        'f7f9ff93d716eaced222a3c52a3b2a36',
        algorithm: XRPKeyAlgorithm.ed25519);
    expect(private.toHex(), privateHex);
    expect(private.getPublic().toHex(), publicKeyHex);
    expect(private.getPublic().toAddress().address, classicAddress);
    expect(private.getPublic().toAddress().toXAddress(), xAddress);
    expect(private.getPublic().toAddress().toXAddress(isTestnet: true),
        xTestNetAddress);
  });

  test('fromSeed SECP256K1', () {
    const String privateHex =
        '00E290DA3DA124B4BF9B68EB023CB57D313F016D36EF395ED03791521B83C66BE6';
    const String publicKeyHex =
        '027190BF2204E1F99A9346C0717508788A73A8A3B7E5A925C349969ED1BA7FF2A0';
    const String classicAddress = 'rs3xN42EFLE23gUDG2Rw4rwxhR9MnjwZKQ';
    const String xAddress = 'X72W51px1i7iPTf4EwKFY2Nygdh5tGGNkvBFfbiuXKPxEPY';
    const String xTestNetAddress =
        'T7Ws3yBAjFp1Fx1yWyhbSZztwhbXPqvG5a9GRHaSf1fZnqk';
    final private = XRPPrivateKey.fromSeed('sa9g98F1dxRtLbprVeAP5MonKgqPS');
    expect(private.toHex(), privateHex);
    expect(private.getPublic().toHex(), publicKeyHex);
    expect(private.getPublic().toAddress().address, classicAddress);
    expect(private.getPublic().toAddress().toXAddress(), xAddress);
    expect(private.getPublic().toAddress().toXAddress(isTestnet: true),
        xTestNetAddress);
  });

  test('fromSeed ED25519', () {
    const String privateHex =
        'EDA53A87FB516F4F7409105E5A43A4B07EF43E42CBF7CB72B3D8020DC12F27CE14';
    const String publicKeyHex =
        'EDFB7C70E528FE161ADDFDA8CB224BC19B9E6455916970F7992A356C3E77AC7EF8';
    const String classicAddress = 'rELnd6Ae5ZYDhHkaqjSVg2vgtBnzjeDshm';
    const String xAddress = 'XVGNvtm1P2N6A6oyQ3TWFsjyXS124KjGTNeki4i9E5DGVp1';
    const String xTestNetAddress =
        'TVBmLzviEX8jPD22CAUH5sV1ztQ41uPJQQcDwhnCiMVzSCn';
    final private = XRPPrivateKey.fromSeed('sEdVkC96W1DQXBgcmNQFDcetKQqBvXw');
    expect(private.toHex(), privateHex);
    expect(private.getPublic().toHex(), publicKeyHex);
    expect(private.getPublic().toAddress().address, classicAddress);
    expect(private.getPublic().toAddress().toXAddress(), xAddress);
    expect(private.getPublic().toAddress().toXAddress(isTestnet: true),
        xTestNetAddress);
  });
  test('fromHex ED25519', () {
    const String privateHex =
        'EDA53A87FB516F4F7409105E5A43A4B07EF43E42CBF7CB72B3D8020DC12F27CE14';
    const String publicKeyHex =
        'EDFB7C70E528FE161ADDFDA8CB224BC19B9E6455916970F7992A356C3E77AC7EF8';
    const String classicAddress = 'rELnd6Ae5ZYDhHkaqjSVg2vgtBnzjeDshm';
    const String xAddress = 'XVGNvtm1P2N6A6oyQ3TWFsjyXS124KjGTNeki4i9E5DGVp1';
    const String xTestNetAddress =
        'TVBmLzviEX8jPD22CAUH5sV1ztQ41uPJQQcDwhnCiMVzSCn';
    final private = XRPPrivateKey.fromHex(
        'EDA53A87FB516F4F7409105E5A43A4B07EF43E42CBF7CB72B3D8020DC12F27CE14'); // CryptoAlgorithm.ED25519

    expect(private.toHex(), privateHex);
    expect(private.getPublic().toHex(), publicKeyHex);
    expect(private.getPublic().toAddress().address, classicAddress);
    expect(private.getPublic().toAddress().toXAddress(), xAddress);
    expect(private.getPublic().toAddress().toXAddress(isTestnet: true),
        xTestNetAddress);
  });

  test('fromHex SECP256K1', () {
    const String privateHex =
        '00E290DA3DA124B4BF9B68EB023CB57D313F016D36EF395ED03791521B83C66BE6';
    const String publicKeyHex =
        '027190BF2204E1F99A9346C0717508788A73A8A3B7E5A925C349969ED1BA7FF2A0';
    const String classicAddress = 'rs3xN42EFLE23gUDG2Rw4rwxhR9MnjwZKQ';
    const String xAddress = 'X72W51px1i7iPTf4EwKFY2Nygdh5tGGNkvBFfbiuXKPxEPY';
    const String xTestNetAddress =
        'T7Ws3yBAjFp1Fx1yWyhbSZztwhbXPqvG5a9GRHaSf1fZnqk';
    final private = XRPPrivateKey.fromHex(
        '00E290DA3DA124B4BF9B68EB023CB57D313F016D36EF395ED03791521B83C66BE6');
    expect(private.toHex(), privateHex);
    expect(private.getPublic().toHex(), publicKeyHex);
    expect(private.getPublic().toAddress().address, classicAddress);
    expect(private.getPublic().toAddress().toXAddress(), xAddress);
    expect(private.getPublic().toAddress().toXAddress(isTestnet: true),
        xTestNetAddress);
  });
}
