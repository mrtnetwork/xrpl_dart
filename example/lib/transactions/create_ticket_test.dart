// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';

import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrp_dart/xrp_dart.dart';
import '../main.dart';

void createTicketTest() async {
  final reqularWallet =
      XRPPrivateKey.fromEntropy("35039337a49e2ee0ee507544e62a0bb2");
  final masterWallet =
      XRPPrivateKey.fromEntropy("f7f9ff93d716eaced222a3c52a3b2a36");
  print(
      "reqular wallet address: ${reqularWallet.getPublic().toAddress().address} ");
  print("master wallet: ${masterWallet.getPublic().toAddress().address} ");

  /// create ticket
  await createTicket(masterWallet);

  /// find your account ticketSequance
  final ticket = await rpc.getAccountObjects(
      masterWallet.getPublic().toAddress().address,
      type: AccountObjectType.ticket);

  /// use one of them to send transaction with ticket seqance
  await accountSetUsingTicket(masterWallet);
}

Future<void> createTicket(XRPPrivateKey owner) async {
  final String ownerAddress = owner.getPublic().toAddress().address;
  final String ownerPublic = owner.getPublic().toHex();

  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);
  print("owner public: $ownerPublic");
  final ticket = TicketCreate(
      ticketCount: 2,
      account: ownerAddress,
      signingPubKey: ownerPublic,
      memos: [memo]);
  print("autfill trnsction");
  await XRPHelper.autoFill(rpc, ticket);
  final blob = ticket.toBlob();
  print("sign transction");
  final sig = owner.sign(blob);
  print("Set transaction signature");
  ticket.setSignature(sig);
  final trhash = ticket.getHash();
  print("transaction hash: $trhash");

  final trBlob = ticket.toBlob(forSigning: false);

  print("regenarate transaction blob");
  print("broadcasting signed transaction blob");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}

Future<void> accountSetUsingTicket(XRPPrivateKey owner) async {
  final String signerPublic = owner.getPublic().toHex();
  final String ownerAddress = owner.getPublic().toAddress().address;
  String memoData = BytesUtils.toHexString(
      utf8.encode("https://github.com/mrtnetwork/xrp_dart"));
  String memoType = BytesUtils.toHexString(utf8.encode("Text"));
  String mempFormat = BytesUtils.toHexString(utf8.encode("text/plain"));
  final memo =
      XRPLMemo(memoData: memoData, memoFormat: mempFormat, memoType: memoType);

  /// create transaction using ticketSequance
  final accountSet = AccountSet(
      account: ownerAddress,
      memos: [memo],
      signingPubKey: signerPublic,

      /// set sequance to ZERO
      sequence: 0,

      /// set ticket sequance
      ticketSequance: 40947158);
  print("autfil trnsction");

  /// in autoFill set `setupAccountSequance` to false
  await XRPHelper.autoFill(rpc, accountSet, setupAccountSequence: false);
  final blob = accountSet.toBlob();
  print("sign transction ");
  final sig = owner.sign(blob);
  print("Set transaction signature");
  accountSet.setSignature(sig);
  final trhash = accountSet.getHash();
  print("transaction hash: $trhash");

  print("regenarate transaction blob");
  final trBlob = accountSet.toBlob(forSigning: false);

  print("broadcasting transaction");
  final result = await rpc.submit(trBlob);
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");
}
