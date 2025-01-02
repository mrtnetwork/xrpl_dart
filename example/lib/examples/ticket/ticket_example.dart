// ignore_for_file: avoid_print

import 'package:example/examples/quick_wallet/quick_wallet.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

void ticketExamples() async {
  final account =
      QuickWallet.create(3, algorithm: XRPKeyAlgorithm.secp256k1, account: 20);

  final destination =
      QuickWallet.create(4, algorithm: XRPKeyAlgorithm.secp256k1, account: 20);
  await createTicket(account);
  await sendXRPUsingTicket(account, destination.address);
}

Future<void> createTicket(QuickWallet account) async {
  final ticket = TicketCreate(
      ticketCount: 2,
      account: account.address,
      signer: XRPLSignature.signer(account.pubHex),
      memos: [exampleMemo]);
  print("autfill trnsction");
  await XRPHelper.autoFill(account.rpc, ticket);
  final blob = ticket.toBlob();
  print("sign transction");
  final sig = account.privateKey.sign(blob);
  print("Set transaction signature");
  ticket.setSignature(sig);
  final trhash = ticket.getHash();
  print("transaction hash: $trhash");

  final trBlob = ticket.toBlob(forSigning: false);

  print("regenarate transaction blob");
  print("broadcasting signed transaction blob");
  final result =
      await account.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/1064DBC76893CB081B14CA32D1AF8A00F6CFDC198402F6C2ABBF7951E0009848
}

Future<void> sendXRPUsingTicket(QuickWallet account, String destination) async {
  final ticketSequenceInfo = await account.rpc.request(
      XRPRequestAccountObjectType(
          account: account.address, type: AccountObjectType.ticket));
  final ticketSequence =
      ticketSequenceInfo["account_objects"][0]["TicketSequence"];
  final transaction = Payment(
      amount: CurrencyAmount.xrp(XRPHelper.xrpDecimalToDrop("1")),
      destination: destination,
      account: account.address,
      signer: XRPLSignature.signer(account.pubHex),

      /// set ticket sequence
      ticketSequance: ticketSequence,

      /// set sequence to zero
      sequence: 0,
      memos: [exampleMemo]);

  /// if u using autoFill disable setupAccountSequence
  await XRPHelper.autoFill(account.rpc, transaction,
      setupAccountSequence: false);

  final blob = transaction.toBlob();
  print("sign transction");
  final sig = account.privateKey.sign(blob);
  print("Set transaction signature");
  transaction.setSignature(sig);
  final trhash = transaction.getHash();
  print("transaction hash: $trhash");
  final trBlob = transaction.toBlob(forSigning: false);
  print("regenarate transaction blob with exists signatures");
  print("broadcasting signed transaction blob");
  final result =
      await account.rpc.request(XRPRequestSubmitOnly(txBlob: trBlob));
  print("transaction hash: ${result.txJson.hash}");
  print("engine result: ${result.engineResult}");
  print("engine result message: ${result.engineResultMessage}");
  print("is success: ${result.isSuccess}");

  /// https://devnet.xrpl.org/transactions/7436795E9018D9F02F67EDE8E14FADAA02B1E91D9BB12CB62141EB5B11FFB093/detailed
}
