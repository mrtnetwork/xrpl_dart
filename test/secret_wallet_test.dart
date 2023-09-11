import 'package:flutter_test/flutter_test.dart';
import 'package:xrp_dart/src/crypto/crypto.dart';
import 'package:xrp_dart/src/crypto/keypair/xrpl_private_key.dart';
import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/secret_wallet/secret_wallet_defination.dart';

void main() {
  test("TEST", () {
    for (int i = 0; i < 5; i++) {
      final private = XRPPrivateKey.random();
      final password = bytesToHex(generateRandom(16));

      /// using a separate thread for encode or decode secret wallet.
      /// {"crypto":{"cipher":"aes-128-ctr","cipherparams":{"iv":"a77889a21b7be5952756f1eed2f0a5b6"},"ciphertext":"310b7ab293508a865b210296a93e2e971f3f8cc703133325dff9e08cd346240ba9","kdf":"scrypt","kdfparams":{"dklen":32,"n":8192,"r":8,"p":1,"salt":"394cae501642f41e6a118f753250c5f4fb09d31f6241c9c2a5cd1083a5cc76e8"},"mac":"fad191fc2e90925a4cea62bd7015793caf160f97ce2c590b67ae12996c640e2c"},"id":"4ee34d91-3259-4c54-0ada-adf2578e7b5d","version":3}
      final createSecret = SecretWallet.encode(private.toHex(), password);
      final decodeSecret = SecretWallet.decode(createSecret.toJson(), password);
      final decodePrivateKey = XRPPrivateKey.fromHex(decodeSecret.credentials);
      expect(private.toHex(), decodePrivateKey.toHex());
    }
  });
}
