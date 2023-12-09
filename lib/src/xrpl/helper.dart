import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrp_dart/src/rpc/xrpl_rpc.dart';
import 'package:xrp_dart/src/xrpl/on_chain_models/fee.dart';
import 'package:xrp_dart/src/xrpl/on_chain_models/ledger.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrp_dart/src/xrpl/on_chain_models/ledger_index.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';

import 'models/escrow_create/escrow_finish.dart';

class XRPHelper {
  static final BigRational _xrpDecimal = BigRational(BigInt.from(10).pow(6));

  /// Method to convert XRP decimal to drop
  static BigInt xrpDecimalToDrop(String decimal) {
    final parse = BigRational.parseDecimal(decimal);
    return (parse * _xrpDecimal).toBigInt();
  }

  /// This asynchronous function fetches the reserve fee from an XRPL server.
  static Future<int> fetchReserveFee(XRPLRpc client) async {
    /// Fetch the server state from the XRPL server.
    final response = await client.serverState();

    /// Extract the reserve increment value from the server state and return it.
    return response.state.validatedLedger.reserveInc;
  }

  /// This asynchronous function calculates transaction fees for an XRPL transaction.
  static Future<void> calculateFees(
      XRPLRpc client, XRPTransaction transaction) async {
    /// Fetch the net fee from the XRPL server.
    final int netFee =
        (await client.getFee()).getFeeType(type: XrplFeeType.open);

    /// Initialize the base fee with the net fee.
    int baseFee = netFee;

    /// Check if the transaction type is ESCROW_FINISH.
    if (transaction.transactionType == XRPLTransactionType.escrowFinish) {
      /// Cast the transaction as an EscrowFinish to access specific properties.
      transaction as EscrowFinish;
      if (transaction.fulfillment != null) {
        /// Calculate the length of the fulfillment in bytes.
        int fulfillmentBytesLength = transaction.fulfillment!.codeUnits.length;

        /// Adjust the base fee based on the fulfillment length.
        baseFee = (netFee * (33 + (fulfillmentBytesLength / 16)).ceil()).ceil();
      }
    }

    /// Check if the transaction type is AMM_CREATE or ACCOUNT_DELETE.
    if (transaction.transactionType == XRPLTransactionType.ammCreate ||
        transaction.transactionType == XRPLTransactionType.accountDelete) {
      /// Fetch the reserve fee and set it as the base fee.
      baseFee = await fetchReserveFee(client);
    }

    /// Adjust the base fee if the transaction involves multi-signers.
    if (transaction.multiSigSigners.isNotEmpty) {
      baseFee += netFee * (1 + transaction.multiSigSigners.length);
    }

    /// Set the calculated base fee in the transaction.
    transaction.setFee(baseFee.toString());
  }

  /// This asynchronous function retrieves the ledger index from an XRPL server.
  /// It provides an optional defaultLedgerOffset to adjust the index.
  static Future<int> getLedgerIndex(XRPLRpc client,
      {int defaultLedgerOffset = 20}) async {
    /// Fetch ledger data from the XRPL server.
    final LedgerData ledgerData = await client.getLedger();

    /// Calculate the ledger index by adding the default offset.
    final int ledgerIndex = ledgerData.ledgerIndex + defaultLedgerOffset;

    /// Return the calculated ledger index.
    return ledgerIndex;
  }

  /// This asynchronous function retrieves the account sequence number for a given address
  /// from an XRPL server.
  static Future<int> getAccountSequence(XRPLRpc client, String address) async {
    /// Fetch account information for the specified address.
    final accountInfo = await client.getAccountInfo(
        XRPAddressUtils.ensureClassicAddress(address),
        ledgerIndex: XRPLLedgerIndex.current);

    /// Extract the account sequence number from the account information.
    final int sequence = accountInfo.accountData.sequence;

    /// Return the retrieved account sequence number.
    return sequence;
  }

  /// This asynchronous function automates various aspects of preparing an XRPL transaction.
  /// It can calculate fees, set the network ID, account sequence, and last ledger sequence.
  static Future<void> autoFill(
    XRPLRpc client,
    XRPTransaction transaction, {
    bool calculateFee = true,
    bool setupNetworkId = true,
    bool setupAccountSequence = true,
    bool setupLedgerSequence = true,
    int defaultLedgerOffset = 20,
  }) async {
    /// Set the network ID if requested.
    if (setupNetworkId) {
      transaction.setNetworkId(await client.getTransactionNetworkId());
    }

    /// Calculate transaction fees if requested.
    if (calculateFee) {
      await calculateFees(client, transaction);
    }

    /// Set the account sequence if requested.
    if (setupAccountSequence) {
      final int sequence =
          await getAccountSequence(client, transaction.account);
      transaction.setSequence(sequence);
    }

    /// Set the last ledger sequence if requested.
    if (setupLedgerSequence) {
      final int ledgerIndex = await getLedgerIndex(client,
          defaultLedgerOffset: defaultLedgerOffset);
      transaction.setLastLedgerSequence(ledgerIndex);
    }
  }
}
