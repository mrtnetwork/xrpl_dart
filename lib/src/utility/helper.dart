import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/exception/exception.dart';
import 'package:xrpl_dart/src/rpc/rpc.dart';
import 'package:xrpl_dart/src/xrpl/address/xrpl.dart';
import 'package:xrpl_dart/src/xrpl/exception/exceptions.dart';
import 'package:xrpl_dart/src/xrpl/models/base/submittable_transaction.dart';
import 'package:xrpl_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrpl_dart/src/xrpl/bytes/serializer.dart' as binary;
import 'package:xrpl_dart/src/xrpl/models/batch/batch.dart';
import 'package:xrpl_dart/src/xrpl/models/escrow_create/escrow_finish.dart';

class XRPHelper {
  static final BigRational _xrpDecimal = BigRational(BigInt.from(10).pow(6));
  static const int maxTxFee = 20000000;

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
      throw XRPLPluginException(
          'Datetime $dateTime is before the Ripple Epoch');
    }

    /// Check if the calculated time is later than the maximum XRPL time.
    if (rippleTime >= maxXRPLTime) {
      throw XRPLPluginException(
          '$dateTime is later than any time that can be expressed on the XRP Ledger.');
    }

    /// Return the calculated Ripple time.
    return rippleTime;
  }

  /// Method to convert XRP decimal to drop
  static BigInt xrpToDrop(String decimal) {
    final parse = BigRational.parseDecimal(decimal);
    return (parse * _xrpDecimal).toBigInt();
  }

  /// This asynchronous function fetches the reserve fee from an XRPL server.
  static Future<BigInt> fetchReserveFee(XRPProvider client) async {
    // /// Fetch the server state from the XRPL server.
    final response = await client.request(XRPRequestServerState());
    final fee = response.state.validatedLedger?.reserveInc;
    if (fee == null) {
      throw XRPLPluginException("Could not fetch owner reserve fee.");
    }

    /// Extract the reserve increment value from the server state and return it.
    return BigInt.from(fee);
  }

  static Future<void> checkAccountDelete(
      {required String account, required XRPProvider client}) async {
    final response = await client.request(XRPRequestAccountObjectType(
        account: account, deleteBlockersOnly: true));
    if (response.accountObjects.isNotEmpty) {
      throw XRPLPluginException(
          "Account cannot be deleted because it still has objects that block deletion.");
    }
  }

  /// This asynchronous function calculates transaction fees for an XRPL transaction.
  static Future<BigInt> calcuateTransactionFee(
      XRPProvider client, SubmittableTransaction transaction,
      {BigInt? netFee,
      BigInt? reserveFee,
      XrplFeeType feeType = XrplFeeType.open,
      int maxTxFee = maxTxFee}) async {
    final bool isSpecialTx = transaction.transactionType ==
            SubmittableTransactionType.ammCreate ||
        transaction.transactionType == SubmittableTransactionType.accountDelete;

    /// Fetch the net fee from the XRPL server.
    netFee ??=
        (await client.request(XRPRequestFee())).getFeeType(type: feeType);

    /// Initialize the base fee with the net fee.
    BigInt baseFee = netFee;

    /// Check if the transaction type is ESCROW_FINISH.
    if (transaction.transactionType ==
        SubmittableTransactionType.escrowFinish) {
      /// Cast the transaction as an EscrowFinish to access specific properties.
      transaction as EscrowFinish;
      if (transaction.fulfillment != null) {
        /// Calculate the length of the fulfillment in bytes.
        final int fulfillmentBytesLength =
            transaction.fulfillment!.codeUnits.length;

        /// Adjust the base fee based on the fulfillment length.
        baseFee =
            (netFee * BigInt.from((33 + (fulfillmentBytesLength / 16)).ceil()));
      }

      /// Check if the transaction type is AMM_CREATE or ACCOUNT_DELETE.
    } else if (isSpecialTx) {
      reserveFee ??= await fetchReserveFee(client);

      /// Fetch the reserve fee and set it as the base fee.
      baseFee = reserveFee;
    } else if (transaction.transactionType ==
        SubmittableTransactionType.batch) {
      final batchTx = transaction as Batch;
      BigInt batchFee = BigInt.zero;
      // final batchFee = batchTx.rawTransactions.fold(BigInt.zero, combine);
      for (final i in batchTx.rawTransactions) {
        batchFee += await calcuateTransactionFee(client, i,
            netFee: netFee, reserveFee: reserveFee, feeType: feeType);
      }
      baseFee = (baseFee * BigInt.two) + batchFee;
    }

    /// Adjust the base fee if the transaction involves multi-signers.
    if (transaction.isMultisig) {
      baseFee += netFee * BigInt.from((1 + transaction.multisigSigners.length));
    }
    if (isSpecialTx) return baseFee;
    final maxFee = BigInt.from(maxTxFee);
    if (baseFee > maxFee) {
      return maxFee;
    }
    return baseFee;
  }

  /// This asynchronous function retrieves the ledger index from an XRPL server.
  /// It provides an optional defaultLedgerOffset to adjust the index.
  static Future<int> getLedgerIndex(XRPProvider client,
      {int defaultLedgerOffset = 20}) async {
    /// Fetch ledger data from the XRPL server.
    final index = await client.request(XRPRequestLedgerCurrent());

    /// Calculate the ledger index by adding the default offset.
    final int ledgerIndex = index + defaultLedgerOffset;

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
    SubmittableTransaction transaction, {
    bool calculateFee = true,
    bool setupNetworkId = true,
    bool setupAccountSequence = true,
    bool setupLedgerSequence = true,
    int defaultLedgerOffset = 20,
    XrplFeeType feeType = XrplFeeType.minimum,
    int maxTxFee = maxTxFee,
  }) async {
    if (transaction.transactionType ==
        SubmittableTransactionType.accountDelete) {
      await checkAccountDelete(client: client, account: transaction.account);
    }

    /// Set the network ID if requested.
    if (setupNetworkId) {
      transaction.setNetworkId(await client.getTransactionNetworkId());
    }

    /// Calculate transaction fees if requested.
    if (calculateFee) {
      final fee = await calcuateTransactionFee(client, transaction,
          feeType: feeType, maxTxFee: maxTxFee);
      transaction.setFee(fee);
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
    if (transaction.transactionType == SubmittableTransactionType.batch) {
      await autoFillBatchTx(client, transaction.cast());
    }
  }

  /// Converts a Map to a hexadecimal blob for XRP transactions.
  static List<int> xrplToBlobBytes(Map<String, dynamic> value) {
    return binary.STObject.fromValue(value, false).toBytes();
  }

  /// This asynchronous function automates various aspects of preparing an XRPL transaction.
  /// It can calculate fees, set the network ID, account sequence, and last ledger sequence.
  static Future<void> autoFillBatchTx(
      XRPProvider client, Batch transaction) async {
    final owner = XRPAddress(transaction.account);
    Map<String, int> sequences = {};
    for (final i in transaction.rawTransactions) {
      if (i.sequence == null && i.ticketSequance == null) {
        final account = XRPAddress(i.account);
        final seq = sequences[account.address];
        if (seq != null) {
          i.setSequence(seq);
          sequences[account.address] = seq + 1;
        } else {
          int accountSequence =
              await getAccountSequence(client, account.address);
          if (account.address == owner.address) {
            accountSequence += 1;
          }
          sequences[account.address] = accountSequence + 1;
          i.setSequence(accountSequence);
        }
      }
      if (i.fee == null) {
        i.setFee(BigInt.zero);
      } else if (i.fee != BigInt.zero) {
        throw XRPLTransactionException(
            "Inner transactions must have a fee of 0.");
      }
      final signer = i.signer;
      if (signer != null &&
          (signer.signingPubKey.isNotEmpty || signer.signature != null)) {
        throw XRPLTransactionException(
            "Inner transactions must not include a signer.");
      }
      if (i.multisigSigners.isNotEmpty) {
        throw XRPLTransactionException(
            "Inner transactions must not include multisig signers.");
      }
      if (i.lastLedgerSequence != null) {
        throw XRPLTransactionException(
            "Inner transactions must not include last ledger sequence.");
      }
      if (i.networkId == null) {
        i.setNetworkId(await client.getTransactionNetworkId());
      }
    }
  }
}
