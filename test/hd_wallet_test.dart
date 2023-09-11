// ignore_for_file: unused_local_variable

import 'package:flutter_test/flutter_test.dart';
import 'package:xrp_dart/src/bip39/bip39_base.dart';
import 'package:xrp_dart/src/crypto/keypair/xrpl_private_key.dart';
import 'package:xrp_dart/src/hd_wallet/hd_wallet.dart';
import 'package:xrp_dart/src/xrpl/address_utilities.dart';

void main() {
  test("DERIVE HDWALLET SECP256K1", () {
    final generate = BIP39.generateMnemonic(strength: 256);
    const String mnemonic =
        "quantum brand farm taxi camera lesson bread few hub drum proud suit spy kid offer eight leg bind improve strike myself undo dumb sun";
    const String defaultXRPSecp256k1Path = "m/44'/144'/0'/0/0";
    final masterWallet = HdWallet.fromMnemonic(mnemonic, passphrase: '');
    final deriveWallet =
        HdWallet.drivePath(masterWallet, defaultXRPSecp256k1Path);
    final private = XRPPrivateKey.fromBytes(
        deriveWallet.private, CryptoAlgorithm.SECP256K1);
    final private2 =
        XRPPrivateKey.fromBytes(deriveWallet.private, CryptoAlgorithm.ED25519);
    const String publicKey =
        "028BCD7BA96DBAB663C4DCAE8E75521C73C7F957AA48C0DB7954D14074218F6D04";
    const String privateKey =
        "00B4F67D2D0EF918B2604F5311A045DDA79B38D73EFA750697A29A76C57BCEF194";
    const String classicAddress = "rDfeDMRymuRQPzYyYPcmEecEejXHKGo6Be";
    const String xAddressMain =
        "XV9pQcy1tXGXrebG3KBTXK2RiZkrMTF5X8712ELpwRS39yJ";
    const String xAddressTestNet =
        "TVhYFj3ik7FYTwM1QfvNRKLLLrGo1s7k7xSK1vZYmrBQ6A1";
    final public = private.getPublic();
    expect(publicKey, public.toHex());
    expect(privateKey, private.toHex());
    expect(classicAddress, public.toAddress().address);
    expect(xAddressMain, public.toAddress().toXAddress(isTestNetwork: false));
    expect(xAddressTestNet, public.toAddress().toXAddress(isTestNetwork: true));
  });

  /// I couldn't find any documentation on how to derive the key from the ED25519 for XRP.
  /// Instead, I used the standard ED25519 HD Derivation path method for this
  /// do not use in production
  test("DERIVE HDWALLET ED25519", () {
    const String mnemonic =
        "quantum brand farm taxi camera lesson bread few hub drum proud suit spy kid offer eight leg bind improve strike myself undo dumb sun";
    const String defaultXRPED25519Path = "m/44'/144'/0'";
    final masterWallet = HdWallet.fromMnemonic(mnemonic, passphrase: '');
    final deriveWallet =
        HdWallet.driveEdPath(masterWallet, defaultXRPED25519Path);
    final private =
        XRPPrivateKey.fromBytes(deriveWallet.private, CryptoAlgorithm.ED25519);
    const String publicKey =
        "ED0F0A4DA7FD0566245ADE665270948198353960447587E4B6D75F692A989A43E6";
    const String privateKey =
        "EDE42A0276B344D7C506045F657424E24AE68348D8002BB43972674E97A0C4FEC9";
    const String classicAddress = "rstXyh4yVFnFY2arSDkuYssboFXBN77Lef";
    const String xAddressMain =
        "X7cxjcnkYckS3B8fudcE5yXYkxxHN8swJo7YZLacDgci7gW";
    const String xAddressTestNet =
        "T7YV95NjQ2JTZ6YjBSMpcyHTNQVnkM6UEyRz1rL3F45nMrE";
    final public = private.getPublic();
  });
}
