// ignore_for_file: avoid_print

import 'package:blockchain_utils/bip/mnemonic/mnemonic.dart';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrp_dart/xrp_dart.dart';
import '../main.dart';

void simpleTransaction() async {
  final entropy = Bip39SeedGenerator(Mnemonic.fromString(
          "spawn have inflict celery market settle expand foil scrub august valid cactus"))
      .generate();
  final bip32 = Bip44.fromSeed(entropy, Bip44Coins.ripple).deriveDefaultPath;
  final bip32Receiver = Bip44.fromSeed(entropy, Bip44Coins.ripple)
      .purpose
      .coin
      .account(0)
      .change(Bip44Changes.chainExt)
      .addressIndex(1);
  print("len ${bip32.privateKey.raw.length}");
  final privateKey = XRPPrivateKey.fromBytes(bip32.privateKey.raw,
      algorithm: XrpKeyAlgorithm.ed25519);

  final publicKey = privateKey.getPublic();
  final address = publicKey.toAddress();
  final reciverPrivateKey = XRPPrivateKey.fromBytes(
      bip32Receiver.privateKey.raw,
      algorithm: XrpKeyAlgorithm.secp256k1);
  print("account ${address.toString()}");
  // return;
  final receiverPublicKey =
      XRPPublicKey.fromBytes(bip32Receiver.publicKey.compressed);
  final receiver = receiverPublicKey.toAddress();
  print("destination ${receiver.toString()}");
  print("destination2 ${reciverPrivateKey.getPublic().toAddress().toString()}");
  final amount = XRPHelper.xrpDecimalToDrop("1");
  print(amount);
  print(publicKey.toHex());
  print(
      "ensure ${XRPAddressUtils.ensureClassicAddress(receiver.toXAddress(forTestnet: true))}");
  final transaction = Payment(
      destination: address.toString(),
      account: receiver.toString(),
      amount: CurrencyAmount.xrp(amount),
      signingPubKey: receiverPublicKey.toHex());
  await XRPHelper.autoFill(rpc, transaction);
  final blob = transaction.toBlob();
  // return;
  print("sign transction");
  final sig = reciverPrivateKey.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);
  final trhash = transaction.getHash();
  print("transaction hash: $trhash");
  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");
  // return;
  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}
