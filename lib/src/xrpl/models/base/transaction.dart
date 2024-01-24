import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/number/number_parser.dart';
import 'package:xrpl_dart/src/xrpl/address/xrpl.dart';
import 'package:xrpl_dart/src/xrpl/bytes/binery_serializer/binary_parser.dart';
import 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

class _TransactionUtils {
  static const String _transactionHashPrefix = "54584E00";
  static const String _transactionSignaturePrefix = "53545800";
  static const String _transactionMultisigPrefix = "534D5400";
  static const int hashStringLength = 64;
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
    "did": "DID",
    "lp": "LP",
    "nftoken": "NFToken",
    "unl": "UNL",
    "uri": "URI",
    "xchain": "XChain",
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

/// The base class for all transaction types
/// [https://xrpl.org/transaction-types.html](https://xrpl.org/transaction-types.html). Represents fields common to all
/// transaction types [https://xrpl.org/transaction-common-fields.html](https://xrpl.org/transaction-common-fields.html).
class XRPTransaction extends XRPLBase {
  /// [account] The address of the sender of the transaction.
  /// [transactionType] (Auto-fillable) The amount of XRP to destroy as a cost to send this
  /// transaction. See Transaction Cost
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
      required this.transactionType});
  @override
  String? get validate {
    if (flags == null) return super.validate;
    if (flags is! int &&
        flags is! FlagsInterface &&
        flags is! List<int> &&
        flags is! List<FlagsInterface>) {
      return "flags must be int, List<int>, FlagsInterface or List<FlagsInterface>";
    }
    return super.validate;
  }

  final String account;
  BigInt? fee;
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
  List<String> multiSigSigners;
  void setNetworkId(int? network) {
    networkId = network;
  }

  void setSequence(int? newSequance) {
    sequence = newSequance;
  }

  void setLastLedgerSequence(int? newSequance) {
    lastLedgerSequence = newSequance;
  }

  void setFee(BigInt? newFee) {
    fee = newFee;
  }

  void setSignature(String? sig) {
    txnSignature = sig;
  }

  void setMultiSigSignature(List<XRPLSigners> sigs) {
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
        fee = parseBigInt(json["fee"]),
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
  int _getFlags() {
    if (flags == null) return 0;
    if (flags is int) return flags;
    if (flags is FlagsInterface) return (flags as FlagsInterface).id;
    return _getFlagFromList(flags);
  }

  int _getFlagFromList(List<dynamic> f) {
    final f = (flags as List).map<int>((e) {
      if (e is int) return e;
      if (e is FlagsInterface) return e.id;
      throw ArgumentError(
          "flags must be int, List<int>, FlagsInterface or List<FlagsInterface>");
    });
    if (f.isEmpty) return 0;
    int accumulator = 0;
    for (int i in f) {
      accumulator |= i;
    }
    return accumulator;
  }

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      "account": account,
      "flags": _getFlags(),
      "signing_pub_key": signingPubKey,
      "last_ledger_sequence": lastLedgerSequence,
      "sequence": sequence,
      "txn_signature": txnSignature,
      "fee": fee?.toString(),
      "transaction_type": transactionType.value,
      "network_id": networkId,
      "ticket_sequence": ticketSequance,
      "source_tag": sourceTag,
      "account_txn_id": accountTxId,
      "signers": (signers?.isEmpty ?? true)
          ? null
          : signers!.map((e) => e.toJson()).toList(),
      "memos": (memos?.isEmpty ?? true)
          ? null
          : memos!.map((e) => e.toJson()).toList()
    };

    return json;
  }

  Map<String, dynamic> toXrpl() {
    final isValid = validate;
    if (isValid != null) {
      throw ArgumentError(isValid);
    }
    final toJs = toJson();
    toJs.removeWhere((key, value) => value == null);
    return _TransactionUtils._transactionJsonToBinaryCodecForm(toJs);
  }

  String toBlob({bool forSigning = true}) {
    if (forSigning) {
      if (signingPubKey.isEmpty && multiSigSigners.isEmpty) {
        throw ArgumentError(
            "Invalid public key. Set the signing public key (signingPubKey) or provide multi-signature signers (multiSigSigners) for multi-signature transactions.");
      }
      if (ticketSequance != null && sequence != 0) {
        throw ArgumentError(
            "Set the sequence to 0 when using the ticketSequence");
      }
      if (fee == null) {
        throw ArgumentError("invalid transaction fee");
      }
    }
    final result = STObject.fromValue(toXrpl(), forSigning).toBytes();
    if (forSigning) {
      return BytesUtils.toHexString([
        ...BytesUtils.fromHexString(
            _TransactionUtils._transactionSignaturePrefix),
        ...result
      ], lowerCase: false);
    }
    return BytesUtils.toHexString(result, lowerCase: false);
  }

  String toMultisigBlob(String address) {
    final result = STObject.fromValue(toXrpl(), true).toBytes();
    final accountIdBytes = AccountID.fromValue(address).toBytes();
    return BytesUtils.toHexString([
      ...BytesUtils.fromHexString(_TransactionUtils._transactionMultisigPrefix),
      ...result,
      ...accountIdBytes
    ], lowerCase: false);
  }

  String getHash() {
    if (txnSignature == null && (signers?.isEmpty ?? true)) {
      throw ArgumentError("Cannot get the hash from an unsigned Transaction.");
    }
    final encodeStr =
        "${_TransactionUtils._transactionHashPrefix}${toBlob(forSigning: false)}";
    final toDigest = BytesUtils.toHexString(
            QuickCrypto.sha512Hash(BytesUtils.fromHexString(encodeStr)),
            lowerCase: false)
        .substring(0, _TransactionUtils.hashStringLength);
    return toDigest;
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
    case XRPLTransactionType.xChainClaim:
      return XChainClaim.fromJson(json);
    case XRPLTransactionType.xChainAccountCreateCommit:
      return XChainAccountCreateCommit.fromJson(json);
    case XRPLTransactionType.xChainAddAccountCreateAttestation:
      return XChainAddAccountCreateAttestation.fromJson(json);
    case XRPLTransactionType.xChainCreateClaimId:
      return XChainCreateClaimId.fromJson(json);
    case XRPLTransactionType.xChainModifyBridge:
      return XChainModifyBridge.fromJson(json);
    case XRPLTransactionType.xChainCreateBridge:
      return XChainCreateBridge.fromJson(json);
    case XRPLTransactionType.xChainCommit:
      return XChainCommit.fromJson(json);
    case XRPLTransactionType.xChainAddClaimAttestation:
      return XChainAddClaimAttestation.fromJson(json);
    default:
      throw ArgumentError("Invalid Transaction ${json["transaction_type"]}");
  }
}
