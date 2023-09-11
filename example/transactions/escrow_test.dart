// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:xrp_dart/src/crypto/keypair/xrpl_private_key.dart';
import 'package:xrp_dart/src/formating/bytes_num_formating.dart';
import 'package:xrp_dart/src/xrpl/helper.dart';
import 'package:xrp_dart/src/xrpl/models/escrow_create/escrow_cancel.dart';
import 'package:xrp_dart/src/xrpl/models/escrow_create/escrow_create.dart';
import 'package:xrp_dart/src/xrpl/models/escrow_create/escrow_finish.dart';
import 'package:xrp_dart/src/xrpl/models/memo.dart';

import 'block_hole_account_test.dart';

void escrowTest() async {
  // fulfillment: "A02280206130EB2312A938A5EC695EBFF9DC538561EC7362F9EA7A26D981DA0E0D38C857"
  // condition: "A0258020E488CD4C1AC9A7673CA2D2712B47049B87C308181BF3B89D6FBB74FC36836BB5810120"

  final hotWallet =
      XRPPrivateKey.fromEntropy("78707270555d4651a9092fbffb791f3d");
  final coldWallet =
      XRPPrivateKey.fromEntropy("da804b5221eae9c404dfe748bf2ccfba");
  await escrowCreate(hotWallet, coldWallet.getPublic().toAddress().address);
  await finisScrow(coldWallet, hotWallet.getPublic().toAddress().address);
  await cancelScrow(hotWallet);
}

Future<void> escrowCreate(XRPPrivateKey owner, String destination) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();

  String memoData = bytesToHex(utf8.encode("https://github.com/MohsenHaydari"));
  String memoType = bytesToHex(utf8.encode("Text"));
  String mempFormat = bytesToHex(utf8.encode("text/plain"));
  final DateTime finishAfterOneHours =
      DateTime.now().add(const Duration(hours: 1));
  final DateTime cancelAfterOnDay = DateTime.now().add(const Duration(days: 1));
  print("cancel after: $cancelAfterOnDay");
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  print("owner public: $ownerPublic");
  final escrowCreate = EscrowCreate(
    account: ownerAddress,
    destination: destination,
    cancelAfterTime: cancelAfterOnDay,
    finishAfterTime: finishAfterOneHours,
    amount: BigInt.from(25000000),
    condition:
        "A0258020E488CD4C1AC9A7673CA2D2712B47049B87C308181BF3B89D6FBB74FC36836BB5810120",
    signingPubKey: ownerPublic,
    memos: [memo],
  );
  print("autfil trnsction");
  await autoFill(rpc, escrowCreate);
  final blob = escrowCreate.toBlob();
  print("sign transction");
  final sig = owner.sign(blob);
  print("Set transaction signature");
  escrowCreate.setSignature(sig);
  final trhash = escrowCreate.getHash();
  print("transaction hash: $trhash");
  final trBlob = escrowCreate.toBlob(forSigning: false);

  print("regenarate transaction blob with exists signatures");
  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> finisScrow(XRPPrivateKey owner, String escrowOwnerAddress) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();

  String memoData = bytesToHex(utf8.encode("https://github.com/MohsenHaydari"));
  String memoType = bytesToHex(utf8.encode("Text"));
  String mempFormat = bytesToHex(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);

  /// if condition is set in escrow create fulfillment and condition required for withdraw
  /// and transaction fee is higher than normal
  final escrowFinish = EscrowFinish(
    offerSequence: 41057029, // sequance of create escrow transaction
    account: ownerAddress,
    condition:
        "A0258020E488CD4C1AC9A7673CA2D2712B47049B87C308181BF3B89D6FBB74FC36836BB5810120",
    fulfillment:
        "A02280206130EB2312A938A5EC695EBFF9DC538561EC7362F9EA7A26D981DA0E0D38C857",
    signingPubKey: ownerPublic,
    owner: escrowOwnerAddress,
    memos: [memo],
  );
  await autoFill(rpc, escrowFinish);

  /// show fee of transaction
  print("fee with fulfillment ${escrowFinish.fee}");

  final blob = escrowFinish.toBlob();
  print("sign transction");
  final sig = owner.sign(blob);
  print("Set transaction signature");
  escrowFinish.setSignature(sig);
  final trhash = escrowFinish.getHash();
  print("transaction hash: $trhash");
  final trBlob = escrowFinish.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");
  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> cancelScrow(XRPPrivateKey owner) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();

  String memoData = bytesToHex(utf8.encode("https://github.com/MohsenHaydari"));
  String memoType = bytesToHex(utf8.encode("Text"));
  String mempFormat = bytesToHex(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  print("owner public: $ownerPublic");
  final escrowCanncel = EscrowCancel(
    owner: ownerAddress,
    offerSequence: 41057027, // sequance of create escrow transaction
    account: ownerAddress,
    signingPubKey: ownerPublic,
    memos: [memo],
  );
  print("autfil trnsction");
  await autoFill(rpc, escrowCanncel);

  final blob = escrowCanncel.toBlob();
  print("sign transction");
  final sig = owner.sign(blob);
  print("Set transaction signature");
  escrowCanncel.setSignature(sig);
  final trhash = escrowCanncel.getHash();
  print("transaction hash: $trhash");

  print("regenarate transaction blob with exists signatures");
  final trBlob = escrowCanncel.toBlob(forSigning: false);

  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}
