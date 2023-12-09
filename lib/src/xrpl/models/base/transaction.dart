import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrp_dart/src/xrpl/address/xrpl.dart';
import 'package:xrp_dart/src/xrpl/bytes/binery_serializer/binary_parser.dart';
import 'package:xrp_dart/src/xrpl/bytes/serializer.dart';
import 'package:xrp_dart/src/xrpl/models/account/account_delete.dart';
import 'package:xrp_dart/src/xrpl/models/account/accountset.dart';
import 'package:xrp_dart/src/xrpl/models/account/set_reqular_key.dart';
import 'package:xrp_dart/src/xrpl/models/amm/amm_bid.dart';
import 'package:xrp_dart/src/xrpl/models/amm/amm_create.dart';
import 'package:xrp_dart/src/xrpl/models/amm/amm_delete.dart';
import 'package:xrp_dart/src/xrpl/models/amm/amm_deposit.dart';
import 'package:xrp_dart/src/xrpl/models/amm/amm_vote.dart';
import 'package:xrp_dart/src/xrpl/models/amm/amm_withdraw.dart';
import 'package:xrp_dart/src/xrpl/models/check/check_cancel.dart';
import 'package:xrp_dart/src/xrpl/models/check/check_cash.dart';
import 'package:xrp_dart/src/xrpl/models/check/check_create.dart';
import 'package:xrp_dart/src/xrpl/models/clawback/clawback.dart';
import 'package:xrp_dart/src/xrpl/models/deposit_preauth/deposit_preauth.dart';
import 'package:xrp_dart/src/xrpl/models/escrow_create/escrow_cancel.dart';
import 'package:xrp_dart/src/xrpl/models/escrow_create/escrow_create.dart';
import 'package:xrp_dart/src/xrpl/models/escrow_create/escrow_finish.dart';
import 'package:xrp_dart/src/xrpl/models/memo/memo.dart';
import 'package:xrp_dart/src/xrpl/models/account/signers.dart';
import 'package:xrp_dart/src/xrpl/models/nft/nft_accept_offer.dart';
import 'package:xrp_dart/src/xrpl/models/nft/nft_token_burn.dart';
import 'package:xrp_dart/src/xrpl/models/nft/nft_token_cancel_offer.dart';
import 'package:xrp_dart/src/xrpl/models/nft/nft_token_mint.dart';
import 'package:xrp_dart/src/xrpl/models/nft/ntf_token_offer.dart';
import 'package:xrp_dart/src/xrpl/models/offer/offer_cancel.dart';
import 'package:xrp_dart/src/xrpl/models/offer/offer_create.dart';
import 'package:xrp_dart/src/xrpl/models/payment/payment.dart';
import 'package:xrp_dart/src/xrpl/models/payment_channel/payment_channel_claim.dart';
import 'package:xrp_dart/src/xrpl/models/payment_channel/payment_channel_create.dart';
import 'package:xrp_dart/src/xrpl/models/payment_channel/payment_channel_fund.dart';
import 'package:xrp_dart/src/xrpl/models/signer_list/signer_list.dart';
import 'package:xrp_dart/src/xrpl/models/ticket/ticket_create.dart';
import 'package:xrp_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/models/payment/trust_set.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

import 'base.dart';

class _TransactionUtils {
  static const String _transactionHashPrefix = "54584E00";
  static const String _transactionSignaturePrefix = "53545800";
  static const String _transactionMultisigPrefix = "534D5400";

  static final _camelToSnakeCaseRegex =
      RegExp(r'(?:^[^A-Z]+|[A-Z]+(?![^A-Z])|[A-Z][^A-Z]*)');
  static Map<String, dynamic> _transactionJsonToBinaryCodecForm(
      Map<String, dynamic> dictionary) {
    return {
      for (final entry in dictionary.entries)
        _keyToTxJson(entry.key): _valueToTxJson(entry.value),
    };
  }

  static final _abbreviations = <String, String>{
    "amm": "AMM",
    "id": "ID",
    "lp": "LP",
    "nftoken": "NFToken",
    "unl": "UNL",
    "uri": "URI",
  };
  static String _keyToTxJson(String key) {
    return key
        .split('_')
        .map((word) =>
            _TransactionUtils._abbreviations[word] ?? _capitalize(word))
        .join('');
  }

  static dynamic _valueToTxJson(dynamic value) {
    if (value is Map) {
      return _transactionJsonToBinaryCodecForm(value as Map<String, dynamic>);
    }
    if (value is List) {
      return [for (final subValue in value) _valueToTxJson(subValue)];
    }
    return value;
  }

  static String _capitalize(String word) {
    return word[0].toUpperCase() + word.substring(1);
  }

  static String _keyToJson(String field) {
    for (final specStr in _abbreviations.values) {
      if (field.contains(specStr)) {
        field = field.replaceFirst(specStr, _capitalize(specStr.toLowerCase()));
      }
    }

    final words =
        _TransactionUtils._camelToSnakeCaseRegex.allMatches(field).map((match) {
      return match.group(0)?.toLowerCase() ?? '';
    }).toList();

    return words.join('_');
  }

  static dynamic _valueToJson(dynamic value) {
    if (value is Map<String, dynamic>) {
      return {
        for (var entry in value.entries)
          _keyToJson(entry.key): _valueToJson(entry.value),
      };
    } else if (value is List) {
      return [for (var item in value) _valueToJson(item)];
    } else {
      return value;
    }
  }

  static Map<String, dynamic> _formattedDict(Map<String, dynamic> value) {
    Map<String, dynamic> result = {};

    value.forEach((k, v) {
      String formattedKey = _keyToJson(k);
      dynamic formattedValue = _valueToJson(v);
      result[formattedKey] = formattedValue;
    });

    return result;
  }
}

/// The base class for all `transaction types
/// [https://xrpl.org/transaction-types.html](https://xrpl.org/transaction-types.html). Represents `fields common to all
/// transaction types [https://xrpl.org/transaction-common-fields.html](https://xrpl.org/transaction-common-fields.html).
class XRPTransaction extends XRPLBase {
  /// [account] The address of the sender of the transaction.
  /// [transactionType] (Auto-fillable) The amount of XRP to destroy as a cost to send this
  /// transaction. See `Transaction Cost
  /// [for details](https://xrpl.org/transaction-cost.html).
  /// [sequence] The sequence number of the transaction. Must match the
  /// sending account's next unused sequence number
  /// [accountTxId] A hash value identifying a previous transaction from the same sender
  /// [flags] A List of flags, or a bitwise map of flags, modifying this transaction's behavior
  /// [lastLedgerSequence] The highest ledger index this transaction can appear in
  /// [memos] Additional arbitrary information attached to this transaction
  /// [signers] Signing data authorizing a multi-signed transaction. Added during multi-signing
  /// [sourceTag] The public key authorizing a single-signed transaction. Automatically added during signing
  /// [ticketSequance] The sequence number of the ticket to use in place of a Sequence number.
  ///  If this is provided, sequence must be 0. Cannot be used with account_txn_id.
  /// [txnSignature] The cryptographic signature from the sender that authorizes this transaction
  /// [networkId] The network id of the transaction.
  XRPTransaction(
      {required this.account,
      this.multiSigSigners = const [],
      this.fee,
      this.sequence,
      this.accountTxId,
      this.flags = 0,
      this.lastLedgerSequence,
      this.memos = const [],
      this.signers,
      this.sourceTag,
      this.signingPubKey = "",
      this.ticketSequance,
      this.txnSignature,
      this.networkId,
      required this.transactionType}) {
    assert(
        flags != null && (flags is int || flags is Map || flags is List<int>),
        "flags must be int or Map<String,bool> or list[int]");
  }
  final String account;
  String? fee;
  int? sequence;
  final String? accountTxId;
  final dynamic flags;
  int? lastLedgerSequence;
  List<XRPLMemo>? memos;
  List<XRPLSigners>? signers;
  final int? sourceTag;
  String signingPubKey;
  final int? ticketSequance;
  String? txnSignature;
  int? networkId;
  final XRPLTransactionType transactionType;
  final List<String> multiSigSigners;
  void setNetworkId(int? network) {
    networkId = network;
  }

  void setSequence(int? newSequance) {
    sequence = newSequance;
  }

  void setLastLedgerSequence(int? newSequance) {
    lastLedgerSequence = newSequance;
  }

  void setFee(String? newFee) {
    fee = newFee;
  }

  void setSignature(String? sig) {
    txnSignature = sig;
  }

  void setMultiSigSignatur(List<XRPLSigners> sigs) {
    signers = sigs
      ..sort((a, b) {
        final addressA = XRPAddress(a.account).toBytes();
        final addressB = XRPAddress(b.account).toBytes();
        return BytesUtils.compareBytes(addressA, addressB);
      });
  }

  XRPTransaction.json(Map<String, dynamic> json)
      : account = json["account"],
        multiSigSigners = const [],
        flags = json["flags"],
        signingPubKey = json["signing_pub_key"],
        lastLedgerSequence = json["last_ledger_sequence"],
        sequence = json["sequence"],
        txnSignature = json["txn_signature"],
        fee = json["fee"],
        transactionType =
            XRPLTransactionType.fromValue(json["transaction_type"]),
        networkId = json["network_id"],
        ticketSequance = json["ticket_sequence"],
        sourceTag = json["source_tag"],
        accountTxId = json["account_txn_id"],
        memos =
            (json["memos"] as List?)?.map((e) => XRPLMemo.fromJson(e)).toList(),
        signers = (json["signers"] as List?)
            ?.map((e) => XRPLSigners.fromJson(e))
            .toList();

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "account": account,
      "flags": flags,
      "signing_pub_key": signingPubKey,
    };
    addWhenNotNull(json, "last_ledger_sequence", lastLedgerSequence);
    addWhenNotNull(json, "sequence", sequence);
    addWhenNotNull(json, "txn_signature", txnSignature);
    addWhenNotNull(json, "fee", fee);
    addWhenNotNull(json, "transaction_type", transactionType.value);
    addWhenNotNull(json, "network_id", networkId);
    addWhenNotNull(json, "ticket_sequence", ticketSequance);
    addWhenNotNull(json, "source_tag", sourceTag);
    addWhenNotNull(json, "account_txn_id", accountTxId);
    addWhenNotNull(
        json,
        "signers",
        (signers?.isEmpty ?? true)
            ? null
            : signers!.map((e) => e.toJson()).toList());
    addWhenNotNull(
        json,
        "memos",
        (memos?.isEmpty ?? true)
            ? null
            : memos!.map((e) => e.toJson()).toList());
    return json;
  }

  Map<String, dynamic> toXrpl() {
    return _TransactionUtils._transactionJsonToBinaryCodecForm(toJson());
  }

  String toBlob({bool forSigning = true}) {
    final result = STObject.fromValue(toXrpl(), forSigning).toBytes();
    if (forSigning) {
      return BytesUtils.toHexString([
        ...BytesUtils.fromHexString(
            _TransactionUtils._transactionSignaturePrefix),
        ...result
      ]);
    }
    return BytesUtils.toHexString(result);
  }

  String toMultisigBlob(String address) {
    final result = STObject.fromValue(toXrpl(), true).toBytes();
    final accountIdBytes = AccountID.fromValue(address).toBytes();
    return BytesUtils.toHexString([
      ...BytesUtils.fromHexString(_TransactionUtils._transactionMultisigPrefix),
      ...result,
      ...accountIdBytes
    ]);
  }

  String getHash() {
    if (txnSignature == null && (signers?.isEmpty ?? true)) {
      throw ArgumentError("Cannot get the hash from an unsigned Transaction.");
    }
    final encodeStr =
        "${_TransactionUtils._transactionHashPrefix}${toBlob(forSigning: false)}"
            .toUpperCase();
    final toDigest = BytesUtils.toHexString(
            QuickCrypto.sha512Hash(BytesUtils.fromHexString(encodeStr)))
        .substring(0, 64);
    return toDigest.toUpperCase();
  }

  bool isSigned() {
    if (signers != null) {
      for (final signer in signers!) {
        if ((signer.signingPubKey.isEmpty) || (signer.txnSignature.isEmpty)) {
          return false;
        }
      }
      return true;
    }

    return (signingPubKey.isNotEmpty) && (txnSignature?.isNotEmpty ?? false);
  }

  factory XRPTransaction.fromBlob(String hexBlob) {
    final p = BinaryParser(BytesUtils.fromHexString(hexBlob));
    final data = STObject.fromParser(p);
    final toJson = data.toJson();
    final formatJson = _TransactionUtils._formattedDict(toJson);
    return _findTransactionObject(formatJson);
  }
  factory XRPTransaction.fromXrpl(Map<String, dynamic> json) {
    final formatJson = _TransactionUtils._formattedDict(json);
    return _findTransactionObject(formatJson);
  }
  factory XRPTransaction.fromJson(Map<String, dynamic> json) {
    return _findTransactionObject(json);
  }
}

XRPTransaction _findTransactionObject(Map<String, dynamic> json) {
  final transactionType =
      XRPLTransactionType.fromValue(json["transaction_type"]);
  switch (transactionType) {
    case XRPLTransactionType.accountDelete:
      return AccountDelete.fromJson(json);
    case XRPLTransactionType.accountSet:
      return AccountSet.fromJson(json);
    case XRPLTransactionType.ammBid:
      return AMMBid.fromJson(json);
    case XRPLTransactionType.ammCreate:
      return AMMCreate.fromJson(json);
    case XRPLTransactionType.ammDelete:
      return AMMDelete.fromJson(json);
    case XRPLTransactionType.ammDeposit:
      return AMMDeposit.fromJson(json);
    case XRPLTransactionType.ammVote:
      return AMMVote.fromJson(json);
    case XRPLTransactionType.ammWithdraw:
      return AMMWithdraw.fromJson(json);
    case XRPLTransactionType.checkCancel:
      return CheckCancel.fromJosn(json);
    case XRPLTransactionType.checkCash:
      return CheckCash.fromJson(json);
    case XRPLTransactionType.checkCreate:
      return CheckCreate.fromJson(json);
    case XRPLTransactionType.clawback:
      return Clawback.fromJson(json);
    case XRPLTransactionType.depositPreauth:
      return DepositPreauth.fromJson(json);
    case XRPLTransactionType.escrowCancel:
      return EscrowCancel.fromJson(json);
    case XRPLTransactionType.escrowCreate:
      return EscrowCreate.fromJson(json);
    case XRPLTransactionType.escrowFinish:
      return EscrowFinish.fromJson(json);
    case XRPLTransactionType.nftokenAcceptOffer:
      return NFTokenAcceptOffer.fromJson(json);
    case XRPLTransactionType.nftokenBurn:
      return NFTokenBurn.fromJson(json);
    case XRPLTransactionType.nftokenCancelOffer:
      return NFTokenCancelOffer.fromJson(json);
    case XRPLTransactionType.nftokenCreateOffer:
      return NFTokenCreateOffer.fromJson(json);
    case XRPLTransactionType.nftokenMint:
      return NFTokenMint.fromJson(json);
    case XRPLTransactionType.offerCancel:
      return OfferCancel.fromJson(json);
    case XRPLTransactionType.offerCreate:
      return OfferCreate.fromJson(json);
    case XRPLTransactionType.payment:
      return Payment.fromJson(json);
    case XRPLTransactionType.paymentChannelClaim:
      return PaymentChannelClaim.fromJson(json);
    case XRPLTransactionType.paymentChannelCreate:
      return PaymentChannelCreate.fromJson(json);
    case XRPLTransactionType.paymentChannelFund:
      return PaymentChannelFund.fromJson(json);
    case XRPLTransactionType.setRegularKey:
      return SetRegularKey.fromJson(json);
    case XRPLTransactionType.signerListSet:
      return SignerListSet.fromJson(json);
    case XRPLTransactionType.ticketCreate:
      return TicketCreate.fromJson(json);
    case XRPLTransactionType.trustSet:
      return TrustSet.fromJson(json);
    default:
      throw ArgumentError("Invalid Transaction ${json["transaction_type"]}");
  }
}
