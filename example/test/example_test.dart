import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void main() {
  final transaction = XRPTransaction.fromBlob(
      "535458001200002200000000614000000000000001684000000000000064730081144D0DDA1745CA5808DEE487F76FBDCA4774E787A98314BA1BB9D463E856067630A7CAD7AC46ECD21F8DDCF9EAE1F1");
  final account = QuickWallet.create(300, algorithm: XRPKeyAlgorithm.ed25519);
  final blob = transaction.toBlob();
  final sig = account.privateKey.sign(blob);
  transaction.setSignature(sig);
}
