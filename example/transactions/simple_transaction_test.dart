// ignore_for_file: avoid_print

import 'package:xrp_dart/src/crypto/keypair/xrpl_private_key.dart';
import 'package:xrp_dart/src/xrpl/helper.dart';
import 'package:xrp_dart/src/xrpl/models/currencies/currencies.dart';
import 'package:xrp_dart/src/xrpl/models/payment.dart';

import '../main.dart';

void simpleTransactionTest() async {
  final hotWallet = XRPPrivateKey.fromHex(
      "00AB6A185A3981054B50D4F7A5C99439A8570C3B2482BF4F691F43FDB5D96A80C2");
  final hotWallet2 =
      XRPPrivateKey.fromEntropy("396c8a5c6e088518b469822923b17039");
  await sendXRPL(
      hotWallet2.getPublic().toAddress().toXAddress(isTestNetwork: true),
      hotWallet,
      CurrencyAmount.xrp(BigInt.from(1000000)));
}

Future<void> sendXRPL(
    String destination, XRPPrivateKey owner, CurrencyAmount amount) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();
  print("owner public: $ownerPublic");
  final transaction = Payment(
      destination: destination,
      account: ownerAddress,
      amount: amount,
      signingPubKey: ownerPublic);
  print("autofill trnsction");
  await autoFill(rpc, transaction);
  final blob = transaction.toBlob();
  print("sign transction");
  final sig = owner.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);
  final trhash = transaction.getHash();
  print("transaction hash: $trhash");
  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");

  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}
