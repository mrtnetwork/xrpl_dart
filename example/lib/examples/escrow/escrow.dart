// ignore_for_file: avoid_print

import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void escrowExample() async {
  final owner = QuickWallet.create(0, account: 12);
  final destination = QuickWallet.create(1, account: 12);
  final secret = List<int>.filled(32, 0);
  final FulfillmentPreimageSha256 fulfillmentCondition =
      FulfillmentPreimageSha256.generate(secret);
  final String condition = fulfillmentCondition.condition;
  final String fulfillment = fulfillmentCondition.fulfillment;
  // await escrowCreate(owner, destination.address, condition: condition);
  await finisScrow(destination, owner.address,
      condition: condition, fulfillment: fulfillment);
  // await cancelScrow(owner);
}

Future<void> escrowCreate(QuickWallet owner, String destination,
    {String? condition}) async {
  final DateTime finishAfterOneHours =
      DateTime.now().add(const Duration(minutes: 10));
  final DateTime cancelAfterOnDay =
      DateTime.now().add(const Duration(minutes: 15));
  final escrowCreate = EscrowCreate(
    account: owner.address,
    destination: destination,
    cancelAfterTime: cancelAfterOnDay,
    finishAfterTime: finishAfterOneHours,
    amount: XRPHelper.xrpDecimalToDrop("1200"),
    condition: condition,
    signer: XRPLSignature.signer(owner.pubHex),
    memos: [exampleMemo],
  );
  print("autfil trnsction");
  await XRPHelper.autoFill(owner.rpc, escrowCreate);
  final blob = escrowCreate.toBlob();
  print("sign transction");
  final sig = owner.privateKey.sign(blob);
  print("Set transaction signature");
  escrowCreate.setSignature(sig);
  final trhash = escrowCreate.getHash();
  print("transaction hash: $trhash");
  final trBlob = escrowCreate.toBlob(forSigning: false);

  print("regenarate transaction blob with exists signatures");
  print("broadcasting signed transaction blob");
  final result = await owner.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/58AE24B7A59EB9FE66244BB21417FDFBF00C9CE9E63E2327D4BA97797E8EEC75
}

Future<void> finisScrow(QuickWallet destination, String owner,
    {String? condition, String? fulfillment}) async {
  /// if condition is set in escrow create fulfillment and condition required for withdraw
  /// and transaction fee is higher than normal
  final escrowFinish = EscrowFinish(
    offerSequence: 2500931, // sequance of create escrow transaction
    account: destination.address,
    condition: condition,
    fulfillment: fulfillment,
    signer: XRPLSignature.signer(destination.pubHex),
    owner: owner,
    memos: [exampleMemo],
  );
  await XRPHelper.autoFill(destination.rpc, escrowFinish);

  /// show fee of transaction
  print("fee with fulfillment ${escrowFinish.fee}");

  final blob = escrowFinish.toBlob();
  print("sign transction");
  final sig = destination.privateKey.sign(blob);
  print("Set transaction signature");
  escrowFinish.setSignature(sig);
  final trhash = escrowFinish.getHash();
  print("transaction hash: $trhash");
  final trBlob = escrowFinish.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");
  print("broadcasting signed transaction blob");
  final result =
      await destination.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/AFDF302FB3900B974047FADFF993E318181EB8DBA4784201AAB2AA0E5198AC10
}

Future<void> cancelScrow(QuickWallet owner) async {
  final escrowCanncel = EscrowCancel(
    owner: owner.address,
    offerSequence: 2500937, // sequance of create escrow transaction
    account: owner.address,
    signer: XRPLSignature.signer(owner.pubHex),
    memos: [exampleMemo],
  );
  print("autfil trnsction");
  await XRPHelper.autoFill(owner.rpc, escrowCanncel);

  final blob = escrowCanncel.toBlob();
  print("sign transction");
  final sig = owner.privateKey.sign(blob);
  print("Set transaction signature");
  escrowCanncel.setSignature(sig);
  final trhash = escrowCanncel.getHash();
  print("transaction hash: $trhash");

  print("regenarate transaction blob with exists signatures");
  final trBlob = escrowCanncel.toBlob(forSigning: false);

  print("broadcasting signed transaction blob");
  final result = await owner.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/5524E4376A5066A44747E2764CAEC92379B42B213E2CF1D46880EF0B931DCB41
}
