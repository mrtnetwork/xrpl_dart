import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/xrpl/address/xrpl.dart';
import 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';
import 'package:xrpl_dart/src/xrpl/exception/exceptions.dart';

import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'package:xrpl_dart/src/crypto/crypto.dart';
import 'package:xrpl_dart/src/xrpl/utils/utils.dart';

abstract class FlagsInterface {
  abstract final int id;
}

class TransactionFlag implements FlagsInterface {
  @override
  final int id;
  const TransactionFlag._(this.id);
  static const TransactionFlag innerBatchTxn = TransactionFlag._(0x40000000);
}

abstract class XRPLBase {
  const XRPLBase();

  /// Converts the object to a JSON representation.
  Map<String, dynamic> toJson();
  String? get validate => null;
}

abstract class BaseTransaction extends XRPLBase {
  /// [account] The address of the sender of the transaction.
  final String account;

  /// [accountTxId] A hash value identifying a previous transaction from the same sender
  final String? accountTxId;

  /// Set of bit-flags for this transaction.
  final List<int> flags;

  /// [memos] Additional arbitrary information attached to this transaction
  final List<XRPLMemo> memos;

  /// The delegate account that is sending the transaction.
  final String? delegate;

  /// [transactionType] (Auto-fillable) The amount of XRP to destroy as a cost to send this
  /// transaction. See Transaction Cost
  /// [for details](https://xrpl.org/transaction-cost.html).
  XRPLTransactionType get transactionType;

  /// [ticketSequance] The sequence number of the ticket to use in place of a Sequence number.
  final int? ticketSequance;

  /// Arbitrary integer used to identify the reason for this payment, or a sender
  /// on whose behalf this transaction is made. Conventionally, a refund should
  /// specify the initial payment's SourceTag as the refund payment's
  /// DestinationTag.
  final int? sourceTag;

  /// The network id of the transaction.
  int? get networkId;

  /// Highest ledger index this transaction can appear in. Specifying this field
  /// places a strict upper limit on how long the transaction can wait to be
  /// validated or rejected.
  int? get lastLedgerSequence;

  /// Integer amount of XRP, in drops, to be destroyed as a cost for
  /// distributing this transaction to the network. Some transaction types have
  /// different minimum requirements.
  BigInt? get fee;

  /// The sequence number of the account sending the transaction. A transaction
  /// is only valid if the Sequence number is exactly 1 greater than the previous
  /// transaction from the same account. The special case 0 means the transaction
  /// is using a Ticket instead.
  int? get sequence;

  /// used to sign this transaction. If is null, indicates a
  /// multi-signature is present in the Signers field instead.
  XRPLSignature? get signer;

  /// Array of objects that represent a multi-signature which authorizes this
  /// transaction.
  List<XRPLSigners> get multisigSigners;

  BaseTransaction(
      {required this.account,
      required this.accountTxId,
      required this.flags,
      List<XRPLMemo> memos = const [],
      required this.delegate,
      required this.ticketSequance,
      required this.sourceTag})
      : memos = memos.immutable;
  BaseTransaction.json(Map<String, dynamic> json)
      : account = json['account'],
        flags = json['flags'] == null
            ? []
            : (json['flags'] is List)
                ? List<int>.from(json["flags"])
                : [IntUtils.parse(json["flags"])],
        ticketSequance = json['ticket_sequence'],
        sourceTag = json['source_tag'],
        accountTxId = json['account_txn_id'],
        delegate = json["delegate"],
        memos =
            ((json['memos'] as List?)?.map((e) => XRPLMemo.fromJson(e)) ?? [])
                .toImutableList;

  Map<String, dynamic> toXrpl() {
    final error = validate;
    if (error != null) {
      throw XRPLTransactionException(error);
    }
    final toJs = toJson()..removeWhere((key, value) => value == null);
    return TransactionUtils.transactionJsonToBinaryCodecForm(toJs);
  }

  factory BaseTransaction.fromJson(Map<String, dynamic> json) {
    final transactionType =
        XRPLTransactionType.fromValue(json['transaction_type']);
    switch (transactionType) {
      case SubmittableTransactionType.permissionedDomainSet:
        return PermissionedDomainSet.fromJson(json);
      case SubmittableTransactionType.batch:
        return Batch.fromJson(json);
      case SubmittableTransactionType.permissionedDomainDelete:
        return PermissionedDomainDelete.fromJson(json);
      case SubmittableTransactionType.mpTokenAuthorize:
        return MPTokenAuthorize.fromJson(json);
      case SubmittableTransactionType.mpTokenIssuanceCreate:
        return MPTokenIssuanceCreate.fromJson(json);
      case SubmittableTransactionType.mpTokenIssuanceDestroy:
        return MPTokenIssuanceDestroy.fromJson(json);
      case SubmittableTransactionType.mpTokenIssuanceSet:
        return MPTokenIssuanceSet.fromJson(json);
      case SubmittableTransactionType.oracleSet:
        return OracleSet.fromJson(json);
      case SubmittableTransactionType.didDelete:
        return DIDDelete.fromJson(json);
      case SubmittableTransactionType.didSet:
        return DIDSet.fromJson(json);
      case SubmittableTransactionType.oracleDelete:
        return OracleDelete.fromJson(json);
      case SubmittableTransactionType.credentialCreate:
        return CredentialCreate.fromJson(json);
      case SubmittableTransactionType.credentialAccept:
        return CredentialAccept.fromJson(json);
      case SubmittableTransactionType.delegateSet:
        return DelegateSet.fromJson(json);
      case SubmittableTransactionType.credentialDelete:
        return CredentialDelete.fromJson(json);
      case SubmittableTransactionType.accountDelete:
        return AccountDelete.fromJson(json);
      case SubmittableTransactionType.accountSet:
        return AccountSet.fromJson(json);
      case SubmittableTransactionType.ammBid:
        return AMMBid.fromJson(json);
      case SubmittableTransactionType.ammCreate:
        return AMMCreate.fromJson(json);
      case SubmittableTransactionType.ammDelete:
        return AMMDelete.fromJson(json);
      case SubmittableTransactionType.ammDeposit:
        return AMMDeposit.fromJson(json);
      case SubmittableTransactionType.ammVote:
        return AMMVote.fromJson(json);
      case SubmittableTransactionType.ammWithdraw:
        return AMMWithdraw.fromJson(json);
      case SubmittableTransactionType.checkCancel:
        return CheckCancel.fromJson(json);
      case SubmittableTransactionType.checkCash:
        return CheckCash.fromJson(json);
      case SubmittableTransactionType.checkCreate:
        return CheckCreate.fromJson(json);
      case SubmittableTransactionType.clawback:
        return Clawback.fromJson(json);
      case SubmittableTransactionType.ammClawback:
        return AMMClawback.fromJson(json);
      case SubmittableTransactionType.depositPreauth:
        return DepositPreauth.fromJson(json);
      case SubmittableTransactionType.escrowCancel:
        return EscrowCancel.fromJson(json);
      case SubmittableTransactionType.escrowCreate:
        return EscrowCreate.fromJson(json);
      case SubmittableTransactionType.escrowFinish:
        return EscrowFinish.fromJson(json);
      case SubmittableTransactionType.nftokenAcceptOffer:
        return NFTokenAcceptOffer.fromJson(json);
      case SubmittableTransactionType.nftokenBurn:
        return NFTokenBurn.fromJson(json);
      case SubmittableTransactionType.nftokenCancelOffer:
        return NFTokenCancelOffer.fromJson(json);
      case SubmittableTransactionType.nftokenCreateOffer:
        return NFTokenCreateOffer.fromJson(json);
      case SubmittableTransactionType.nftokenMint:
        return NFTokenMint.fromJson(json);
      case SubmittableTransactionType.offerCancel:
        return OfferCancel.fromJson(json);
      case SubmittableTransactionType.offerCreate:
        return OfferCreate.fromJson(json);
      case SubmittableTransactionType.payment:
        return Payment.fromJson(json);
      case SubmittableTransactionType.paymentChannelClaim:
        return PaymentChannelClaim.fromJson(json);
      case SubmittableTransactionType.paymentChannelCreate:
        return PaymentChannelCreate.fromJson(json);
      case SubmittableTransactionType.paymentChannelFund:
        return PaymentChannelFund.fromJson(json);
      case SubmittableTransactionType.setRegularKey:
        return SetRegularKey.fromJson(json);
      case SubmittableTransactionType.signerListSet:
        return SignerListSet.fromJson(json);
      case SubmittableTransactionType.ticketCreate:
        return TicketCreate.fromJson(json);
      case SubmittableTransactionType.trustSet:
        return TrustSet.fromJson(json);
      case SubmittableTransactionType.xChainClaim:
        return XChainClaim.fromJson(json);
      case SubmittableTransactionType.xChainAccountCreateCommit:
        return XChainAccountCreateCommit.fromJson(json);
      case SubmittableTransactionType.xChainAddAccountCreateAttestation:
        return XChainAddAccountCreateAttestation.fromJson(json);
      case SubmittableTransactionType.xChainCreateClaimId:
        return XChainCreateClaimId.fromJson(json);
      case SubmittableTransactionType.xChainModifyBridge:
        return XChainModifyBridge.fromJson(json);
      case SubmittableTransactionType.xChainCreateBridge:
        return XChainCreateBridge.fromJson(json);
      case SubmittableTransactionType.xChainCommit:
        return XChainCommit.fromJson(json);
      case SubmittableTransactionType.xChainAddClaimAttestation:
        return XChainAddClaimAttestation.fromJson(json);

      //
      case PseudoTransactionType.unlModify:
        return UNLModify.fromJson(json);
      case PseudoTransactionType.setFee:
        return SetFee.fromJson(json);
      case PseudoTransactionType.enableAmendment:
        return EnableAmendment.fromJson(json);
      default:
        throw XRPLTransactionException("Invalid transaction type.");
    }
  }

  factory BaseTransaction.fromBlobBytes(List<int> bytes) {
    final data = STObject(bytes);
    final toJson = data.toJson();
    final formatJson = TransactionUtils.formattedDict(toJson);
    return BaseTransaction.fromJson(formatJson);
  }

  factory BaseTransaction.fromBlob(String hexBlob) {
    List<int> toBytes = BytesUtils.fromHexString(hexBlob);
    return BaseTransaction.fromBlobBytes(toBytes);
  }
  factory BaseTransaction.fromXrpl(Map<String, dynamic> json) {
    final formatJson = TransactionUtils.formattedDict(json);
    return BaseTransaction.fromJson(formatJson);
  }
  bool get isMultisig => multisigSigners.isNotEmpty;

  List<int> _toMultisigBlobBytes(String address) {
    final result = STObject.fromValue(toXrpl(), true).toBytes();
    final addr = XRPAddress(address, allowXAddress: true);
    return [
      ...TransactionUtils.transactionMultisigPrefix,
      ...result,
      ...addr.toBytes()
    ];
  }

  // List<int> _toBatchSignBlobBytes() {

  // }

  List<int> _toSigningBlob() {
    final result = STObject.fromValue(toXrpl(), true).toBytes();
    return [...TransactionUtils.transactionSignaturePrefix, ...result];
  }

  List<int> toTransactionBlobBytes() {
    final result = STObject.fromValue(toXrpl(), false).toBytes();
    return result;
  }

  String toTransactionBlob() {
    return BytesUtils.toHexString(toTransactionBlobBytes(), lowerCase: false);
  }

  List<int> toSigningBlobBytes(XRPAddress signer) {
    final error = validate;
    if (error != null) {
      throw XRPLTransactionException(error);
    }
    final fee = this.fee;
    if (fee == null) {
      throw XRPLTransactionException(
          "'fee' must be set and greater than zero.");
    }
    if (sequence == null && ticketSequance == null) {
      throw XRPLTransactionException(
          "Either 'sequence' or 'ticketSequence' must be provided in the transaction.");
    }
    if (lastLedgerSequence == null) {
      throw XRPLTransactionException(
          "'lastLedgerSequence' is required in the transaction.");
    }

    if (isMultisig) {
      return _toMultisigBlobBytes(signer.address);
    }
    return _toSigningBlob();
  }

  String toSigningBlob(XRPAddress signer) {
    return BytesUtils.toHexString(toSigningBlobBytes(signer), lowerCase: false);
  }

  String getHash({bool forBatchTx = false}) {
    if (!forBatchTx) {
      if (!(signer?.isReady ?? false) &&
          (multisigSigners.isEmpty ||
              multisigSigners.any((element) => !element.isReady))) {
        throw const XRPLTransactionException(
            'Cannot get the hash from an unsigned Transaction.');
      }
    }
    final hash = QuickCrypto.sha512HashHalves([
      ...TransactionUtils.transactionHashPrefix,
      ...toTransactionBlobBytes()
    ]);

    final toDigest = BytesUtils.toHexString(hash.item1, lowerCase: false);
    return toDigest;
  }

  T cast<T extends BaseTransaction>() {
    if (this is! T) {
      throw XRPLTransactionException(
        "Invalid transaction type: expected $T, but got $runtimeType.",
      );
    }
    return this as T;
  }
}
