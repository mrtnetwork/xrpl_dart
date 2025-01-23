import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/rpc/rpc.dart';
import 'package:xrpl_dart/src/xrpl/models/base/transaction.dart';
import 'package:xrpl_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrpl_dart/src/xrpl/bytes/serializer.dart' as binary;

import '../xrpl/models/escrow_create/escrow_finish.dart';

class XRPHelper {
  static final BigRational _xrpDecimal = BigRational(BigInt.from(10).pow(6));

  /// This function converts a DateTime object to Ripple time format.
  static int datetimeToRippleTime(DateTime dateTime) {
    /// Constants for the Ripple Epoch and maximum XRPL time.
    const int rippleEpoch = 946684800;
    const int maxXRPLTime = 4294967296;

    /// Calculate the Ripple time.
    final int rippleTime =
        dateTime.toUtc().millisecondsSinceEpoch ~/ 1000 - rippleEpoch;

    /// Check if the calculated time is before the Ripple Epoch.
    if (rippleTime < 0) {
      throw ArgumentError('Datetime $dateTime is before the Ripple Epoch');
    }

    /// Check if the calculated time is later than the maximum XRPL time.
    if (rippleTime >= maxXRPLTime) {
      throw ArgumentError(
          '$dateTime is later than any time that can be expressed on the XRP Ledger.');
    }

    /// Return the calculated Ripple time.
    return rippleTime;
  }

  /// Method to convert XRP decimal to drop
  static BigInt xrpDecimalToDrop(String decimal) {
    final parse = BigRational.parseDecimal(decimal);
    return (parse * _xrpDecimal).toBigInt();
  }

  /// This asynchronous function fetches the reserve fee from an XRPL server.
  static Future<int> fetchReserveFee(XRPProvider client) async {
    /// Fetch the server state from the XRPL server.
    final response = await client.request(XRPRequestServerState());

    /// Extract the reserve increment value from the server state and return it.
    return response.state.validatedLedger.reserveInc;
  }

  /// This asynchronous function calculates transaction fees for an XRPL transaction.
  static Future<void> calculateFees(
      XRPProvider client, XRPTransaction transaction,
      {XrplFeeType feeType = XrplFeeType.open}) async {
    /// Fetch the net fee from the XRPL server.
    final int netFee =
        (await client.request(XRPRequestFee())).getFeeType(type: feeType);

    /// Initialize the base fee with the net fee.
    int baseFee = netFee;

    /// Check if the transaction type is ESCROW_FINISH.
    if (transaction.transactionType == XRPLTransactionType.escrowFinish) {
      /// Cast the transaction as an EscrowFinish to access specific properties.
      transaction as EscrowFinish;
      if (transaction.fulfillment != null) {
        /// Calculate the length of the fulfillment in bytes.
        final int fulfillmentBytesLength =
            transaction.fulfillment!.codeUnits.length;

        /// Adjust the base fee based on the fulfillment length.
        baseFee = (netFee * (33 + (fulfillmentBytesLength / 16)).ceil()).ceil();
      }

      /// Check if the transaction type is AMM_CREATE or ACCOUNT_DELETE.
    } else if (transaction.transactionType == XRPLTransactionType.ammCreate ||
        transaction.transactionType == XRPLTransactionType.accountDelete) {
      /// Fetch the reserve fee and set it as the base fee.
      baseFee = await fetchReserveFee(client);
    }

    /// Adjust the base fee if the transaction involves multi-signers.
    if (transaction.isMultisig) {
      baseFee += netFee * (1 + transaction.multisigSigners.length);
    }

    /// Set the calculated base fee in the transaction.
    transaction.setFee(BigInt.from(baseFee));
  }

  /// This asynchronous function retrieves the ledger index from an XRPL server.
  /// It provides an optional defaultLedgerOffset to adjust the index.
  static Future<int> getLedgerIndex(XRPProvider client,
      {int defaultLedgerOffset = 20}) async {
    /// Fetch ledger data from the XRPL server.
    final LedgerData ledgerData = await client.request(XRPRequestLedger());

    /// Calculate the ledger index by adding the default offset.
    final int ledgerIndex = ledgerData.ledgerIndex + defaultLedgerOffset;

    /// Return the calculated ledger index.
    return ledgerIndex;
  }

  /// This asynchronous function retrieves the account sequence number for a given address
  /// from an XRPL server.
  static Future<int> getAccountSequence(
      XRPProvider client, String address) async {
    /// Fetch account information for the specified address.
    final accountInfo = await client.request(XRPRequestAccountInfo(
        account: address, ledgerIndex: XRPLLedgerIndex.current));

    /// Extract the account sequence number from the account information.
    final int sequence = accountInfo.accountData.sequence;

    /// Return the retrieved account sequence number.
    return sequence;
  }

  /// This asynchronous function automates various aspects of preparing an XRPL transaction.
  /// It can calculate fees, set the network ID, account sequence, and last ledger sequence.
  static Future<void> autoFill(
    XRPProvider client,
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

  /// Retrieves the XChainClaimID from the metadata of an XChainCreateClaimID transaction.
  ///
  /// This function expects the metadata from an XChainCreateClaimID transaction and
  /// searches for the newly created XChainOwnedClaimID. If found, it extracts and returns
  /// the associated XChainClaimID.
  ///
  /// Parameters:
  ///   - meta: The metadata from an XChainCreateClaimID transaction.
  ///
  /// Returns:
  ///   The XChainClaimID from the newly created XChainOwnedClaimID entry.
  ///
  /// Throws:
  ///   - StateError: If the provided metadata is null or lacks the necessary information.
  ///   - StateError: If no XChainOwnedClaimID is found in the affected nodes.
  ///   - StateError: If multiple XChainOwnedClaimIDs are somehow created.
  static String getXChainClaimId(Map<String, dynamic>? meta) {
    if (meta == null || meta['AffectedNodes'] == null) {
      throw StateError(
          "Unable to parse the parameter given to get_xchain_claim_id. 'meta' must be the metadata from an XChainCreateClaimID transaction. Received $meta instead.");
    }

    final List affectedNodes = meta['AffectedNodes'];
    final List createdNodes = affectedNodes.where((node) {
      return isCreatedNode(node) &&
          node['CreatedNode']?['LedgerEntryType'] == 'XChainOwnedClaimID';
    }).toList();

    if (createdNodes.isEmpty) {
      throw StateError('No XChainOwnedClaimID created.');
    }

    if (createdNodes.length > 1) {
      throw StateError(
          'Multiple XChainOwnedClaimIDs were somehow created. Please report this error.');
    }

    return createdNodes[0]['CreatedNode']['NewFields']['XChainClaimID'];
  }

  /// Checks if the provided node is a 'CreatedNode'.
  ///
  /// Parameters:
  ///   - node: The node to be checked.
  ///
  /// Returns:
  ///   A boolean indicating whether the node is a 'CreatedNode'.
  static bool isCreatedNode(Map<String, dynamic> node) {
    return node.containsKey('CreatedNode');
  }

  /// Converts a Map to a hexadecimal blob for XRP transactions.
  static String toBlob(Map<String, dynamic> value) {
    final result = binary.STObject.fromValue(value, false).toBytes();
    return BytesUtils.toHexString(result, lowerCase: false);
  }

  int createFlag(List<int> flags) {
    if (flags.isEmpty) return 0;
    int accumulator = 0;
    for (final int i in flags) {
      accumulator |= i;
    }
    return accumulator;
  }
}
