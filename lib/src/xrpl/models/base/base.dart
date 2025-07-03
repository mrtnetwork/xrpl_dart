import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';
import 'package:xrpl_dart/src/xrpl/exception/exceptions.dart';

import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'package:xrpl_dart/src/crypto/crypto.dart';
import 'package:xrpl_dart/src/xrpl/utils/utils.dart';

abstract class FlagsInterface {
  abstract final int id;
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
  final List<int> flags;

  /// [memos] Additional arbitrary information attached to this transaction
  final List<XRPLMemo> memos;
  final String? delegate;

  /// [transactionType] (Auto-fillable) The amount of XRP to destroy as a cost to send this
  /// transaction. See Transaction Cost
  /// [for details](https://xrpl.org/transaction-cost.html).

  XRPLTransactionType get transactionType;

  /// [ticketSequance] The sequence number of the ticket to use in place of a Sequence number.

  final int? ticketSequance;
  final int? sourceTag;
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

  int? get networkId;
  int? get lastLedgerSequence;
  BigInt? get fee;
  int? get sequence;
  XRPLSignature? get signer;
  List<XRPLSigners> get multisigSigners;

  Map<String, dynamic> toXrpl() {
    final isValid = validate;
    if (isValid != null) {
      throw XRPLTransactionException(isValid);
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

  factory BaseTransaction.fromBlob(String hexBlob) {
    List<int> toBytes = BytesUtils.fromHexString(hexBlob);
    final prefix = toBytes.sublist(0, 4);
    if (BytesUtils.bytesEqual(
            prefix, TransactionUtils.transactionMultisigPrefix) ||
        BytesUtils.bytesEqual(
            prefix, TransactionUtils.transactionSignaturePrefix)) {
      toBytes = toBytes.sublist(4);
      if (BytesUtils.bytesEqual(
          prefix, TransactionUtils.transactionMultisigPrefix)) {
        toBytes = toBytes.sublist(0, toBytes.length - Hash160.lengthBytes);
      }
    }
    final data = STObject(toBytes);

    final toJson = data.toJson();

    final formatJson = TransactionUtils.formattedDict(toJson);
    return BaseTransaction.fromJson(formatJson);
  }
  factory BaseTransaction.fromXrpl(Map<String, dynamic> json) {
    final formatJson = TransactionUtils.formattedDict(json);
    return BaseTransaction.fromJson(formatJson);
  }
  bool get isMultisig => multisigSigners.isNotEmpty;
  String toBlob({bool forSigning = true}) {
    if (forSigning) {
      if (isMultisig) {
        throw const XRPLTransactionException(
            'use toMultisigBlob for multisign transaction.');
      }
      if (ticketSequance != null && sequence != 0) {
        throw const XRPLTransactionException(
            'Set the sequence to 0 when using the ticketSequence');
      }
      if (fee == null) {
        throw const XRPLTransactionException('invalid transaction fee');
      }
    }
    final result = STObject.fromValue(toXrpl(), forSigning).toBytes();
    if (forSigning) {
      return BytesUtils.toHexString(
          [...TransactionUtils.transactionSignaturePrefix, ...result],
          lowerCase: false);
    }
    return BytesUtils.toHexString(result, lowerCase: false);
  }

  String getHash() {
    if (!(signer?.isReady ?? false) &&
        (multisigSigners.isEmpty ||
            multisigSigners.any((element) => !element.isReady))) {
      throw const XRPLTransactionException(
          'Cannot get the hash from an unsigned Transaction.');
    }
    final encodeStr =
        '${TransactionUtils.transactionHashPrefix}${toBlob(forSigning: false)}';
    final toDigest = BytesUtils.toHexString(
            QuickCrypto.sha512Hash(BytesUtils.fromHexString(encodeStr)),
            lowerCase: false)
        .substring(0, TransactionUtils.hashStringLength);
    return toDigest;
  }
}
