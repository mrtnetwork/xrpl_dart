import 'package:xrp_dart/src/rpc/xrpl_rpc.dart';
import 'package:xrp_dart/src/xrpl/address_utilities.dart';
import 'package:xrp_dart/src/xrpl/on_chain_models/fee.dart';
import 'package:xrp_dart/src/xrpl/on_chain_models/ledger.dart';
import 'package:xrp_dart/src/xrpl/models/transaction.dart';
import 'package:xrp_dart/src/xrpl/on_chain_models/ledger_index.dart';
import 'package:xrp_dart/src/xrpl/models/transaction_types.dart';

import 'models/escrow_create/escrow_finish.dart';

Future<int> fetchReserveFee(XRPLRpc client) async {
  final response = await client.serverState();
  return response.state.validatedLedger.reserveInc;
}

Future<void> calculateFees(XRPLRpc client, XRPTransaction transaction) async {
  final int netFee = (await client.getFee()).getFeeType(type: XrplFeeType.open);
  int baseFee = netFee;
  if (transaction.transactionType == XRPLTransactionType.ESCROW_FINISH) {
    transaction as EscrowFinish;
    if (transaction.fulfillment != null) {
      int fulfillmentBytesLength = transaction.fulfillment!.codeUnits.length;
      baseFee = (netFee * (33 + (fulfillmentBytesLength / 16)).ceil()).ceil();
    }
  }
  if (transaction.transactionType == XRPLTransactionType.AMM_CREATE ||
      transaction.transactionType == XRPLTransactionType.ACCOUNT_DELETE) {
    baseFee = await fetchReserveFee(client);
  }
  if (transaction.multiSigSigners.isNotEmpty) {
    baseFee += netFee * (1 + transaction.multiSigSigners.length);
  }
  transaction.setFee(baseFee.toString());
}

Future<int> getLedgerIndex(XRPLRpc client,
    {int defaultLedgerOffset = 20}) async {
  final LedgerData ledgerData = await client.getLedger();
  final int ledgerIndex = ledgerData.ledgerIndex + defaultLedgerOffset;
  return ledgerIndex;
}

Future<int> getAccountSequance(XRPLRpc client, String address) async {
  final accountInfo = await client.getAccountInfo(
      XRPAddressUtilities.toCalssicAddress(address),
      ledgerIndex: XRPLLedgerIndex.current);
  final int sequance = accountInfo.accountData.sequence;
  return sequance;
}

Future<void> autoFill(
  XRPLRpc client,
  XRPTransaction transaction, {
  bool calculateFee = true,
  bool setupNetworkId = true,
  bool setupAccountSequance = true,
  bool setupLedgerSequance = true,
  int defaultLedgerOffset = 20,
}) async {
  if (setupNetworkId) {
    transaction.setNetworkId(await client.getTransactionNetworkId());
  }
  if (calculateFee) {
    await calculateFees(client, transaction);
  }

  if (setupAccountSequance) {
    final int sequance = await getAccountSequance(client, transaction.account);
    transaction.setSequance(sequance);
  }
  if (setupLedgerSequance) {
    final int ledgerIndex =
        await getLedgerIndex(client, defaultLedgerOffset: defaultLedgerOffset);
    transaction.setLastLedgerSequance(ledgerIndex);
  }
}
