import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:xrpl_dart/src/xrpl/address/xrpl.dart';
import 'package:xrpl_dart/src/xrpl/bytes/binery_serializer/binary_parser.dart';
import 'package:xrpl_dart/src/xrpl/bytes/serializer.dart';
import 'package:xrpl_dart/src/xrpl/exception/exceptions.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'package:xrpl_dart/src/crypto/crypto.dart';

class _TransactionUtils {
  static const String _transactionHashPrefix = '54584E00';
  static const List<int> _transactionSignaturePrefix = [0x53, 0x54, 0x58, 0x00];
  static const List<int> _transactionMultisigPrefix = [0x53, 0x4D, 0x54, 0x00];
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
    'amm': 'AMM',
    'id': 'ID',
    'did': 'DID',
    'lp': 'LP',
    'nftoken': 'NFToken',
    'unl': 'UNL',
    'uri': 'URI',
    'xchain': 'XChain',
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
        for (final entry in value.entries)
          _keyToJson(entry.key): _valueToJson(entry.value),
      };
    } else if (value is List) {
      return [for (final item in value) _valueToJson(item)];
    } else {
      return value;
    }
  }

  static Map<String, dynamic> _formattedDict(Map<String, dynamic> value) {
    final Map<String, dynamic> result = {};

    value.forEach((k, v) {
      final String formattedKey = _keyToJson(k);
      final dynamic formattedValue = _valueToJson(v);
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
  final String account;

  BigInt? get fee => _fee;
  BigInt? _fee;

  /// [sequence] The sequence number of the transaction. Must match the
  /// sending account's next unused sequence number
  int? get sequence => _sequence;
  int? _sequence;

  /// [accountTxId] A hash value identifying a previous transaction from the same sender
  final String? accountTxId;

  /// [flags]
  final int flags;
  int? _lastLedgerSequence;

  /// [lastLedgerSequence] The highest ledger index this transaction can appear in
  int? get lastLedgerSequence => _lastLedgerSequence;

  /// [memos] Additional arbitrary information attached to this transaction
  final List<XRPLMemo> memos;

  /// [multisigSigners] Signing data authorizing a multi-signed transaction. Added during multi-signing
  List<XRPLSigners> _multisigSigners;
  List<XRPLSigners> get multisigSigners => _multisigSigners;
  bool get isMultisig => multisigSigners.isNotEmpty;

  /// [signer] Signing data authorizing a signle-signed transaction.
  XRPLSignature? get signer => _signer;
  XRPLSignature? _signer;

  final int? sourceTag;

  /// [ticketSequance] The sequence number of the ticket to use in place of a Sequence number.
  final int? ticketSequance;

  int? _networkId;

  /// [networkId] The network id of the transaction.
  int? get networkId => _networkId;

  /// [transactionType] (Auto-fillable) The amount of XRP to destroy as a cost to send this
  /// transaction. See Transaction Cost
  /// [for details](https://xrpl.org/transaction-cost.html).
  final XRPLTransactionType transactionType;

  XRPTransaction(
      {required this.account,
      BigInt? fee,
      int? sequence,
      this.accountTxId,
      int? flags,
      int? lastLedgerSequence,
      List<XRPLMemo>? memos = const [],
      List<XRPLSigners>? multisigSigners,
      XRPLSignature? signer,
      this.sourceTag,
      this.ticketSequance,
      int? networkId,
      required this.transactionType})
      : flags = flags ?? 0,
        _multisigSigners =
            List<XRPLSigners>.unmodifiable(multisigSigners ?? []),
        _signer = signer,
        _fee = fee,
        _sequence = sequence,
        _lastLedgerSequence = lastLedgerSequence,
        _networkId = networkId,
        memos = List<XRPLMemo>.unmodifiable(memos ?? <XRPLMemo>[]) {
    if (_multisigSigners.isNotEmpty && _signer != null) {
      throw const XRPLTransactionException(
          'Utilize multisigSigners for multisig transactions, or signer for single-signature transactions.');
    }
  }
  XRPTransaction copyWith({
    String? account,
    BigInt? fee,
    int? sequence,
    String? accountTxId,
    int? flags,
    int? lastLedgerSequence,
    List<XRPLMemo>? memos,
    List<XRPLSigners>? multisigSigners,
    XRPLSignature? signer,
    int? sourceTag,
    int? ticketSequance,
    int? networkId,
    XRPLTransactionType? transactionType,
  }) {
    return XRPTransaction(
      account: account ?? this.account,
      fee: fee ?? this.fee,
      sequence: sequence ?? this.sequence,
      accountTxId: accountTxId ?? this.accountTxId,
      flags: flags ?? this.flags,
      lastLedgerSequence: lastLedgerSequence ?? this.lastLedgerSequence,
      memos: memos ?? this.memos,
      multisigSigners: multisigSigners ?? this.multisigSigners,
      signer: signer ?? this.signer,
      sourceTag: sourceTag ?? this.sourceTag,
      ticketSequance: ticketSequance ?? this.ticketSequance,
      networkId: networkId ?? this.networkId,
      transactionType: transactionType ?? this.transactionType,
    );
  }

  void setNetworkId(int? network) {
    _networkId = network;
  }

  void setSequence(int? newSequance) {
    _sequence = newSequance;
  }

  void setLastLedgerSequence(int? newSequance) {
    _lastLedgerSequence = newSequance;
  }

  void setFee(BigInt? newFee) {
    _fee = newFee;
  }

  void setSignature(XRPLSignature? signature) {
    if (isMultisig) {
      throw const XRPLTransactionException(
          'use setMultiSigSignature method for multi-signature transactions');
    }
    _signer = signature;
  }

  void setMultiSigSignature(List<XRPLSigners> sigs) {
    if (_signer != null) {
      throw const XRPLTransactionException(
          'Please avoid setting setMultiSigSignature for non-multi-sig transactions');
    }
    _multisigSigners = List<XRPLSigners>.unmodifiable(sigs
      ..sort((a, b) {
        final addressA = XRPAddress(a.account).toBytes();
        final addressB = XRPAddress(b.account).toBytes();
        return BytesUtils.compareBytes(addressA, addressB);
      }));
  }

  XRPTransaction.json(Map<String, dynamic> json)
      : account = json['account'],
        flags = json['flags'],
        _lastLedgerSequence = json['last_ledger_sequence'],
        _sequence = json['sequence'],
        _signer = XRPLSignature.fromJson(json),
        _fee = BigintUtils.tryParse(json['fee']),
        transactionType =
            XRPLTransactionType.fromValue(json['transaction_type']),
        _networkId = json['network_id'],
        ticketSequance = json['ticket_sequence'],
        sourceTag = json['source_tag'],
        accountTxId = json['account_txn_id'],
        memos = List<XRPLMemo>.unmodifiable((json['memos'] as List?)
                ?.map((e) => XRPLMemo.fromJson(e))
                .toList() ??
            <XRPLMemo>[]),
        _multisigSigners = List<XRPLSigners>.unmodifiable(
            (json['signers'] as List?)
                    ?.map((e) => XRPLSigners.fromJson(e))
                    .toList() ??
                []);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'account': account,
      'flags': flags,
      'signing_pub_key': signer?.signingPubKey ?? '',
      'last_ledger_sequence': lastLedgerSequence,
      'sequence': sequence,
      'txn_signature': signer?.signature,
      'fee': fee?.toString(),
      'transaction_type': transactionType.value,
      'network_id': networkId,
      'ticket_sequence': ticketSequance,
      'source_tag': sourceTag,
      'account_txn_id': accountTxId,
      'signers': null,
      'memos': (memos.isEmpty) ? null : memos.map((e) => e.toJson()).toList()
    };
    if (_multisigSigners.isNotEmpty) {
      final allReady = multisigSigners.every((element) => element.isReady);
      if (allReady) {
        json['signers'] = _multisigSigners.map((e) => e.toJson()).toList();
      }
    }

    return json;
  }

  Map<String, dynamic> toXrpl() {
    final isValid = validate;
    if (isValid != null) {
      throw XRPLTransactionException(isValid);
    }
    final toJs = toJson()..removeWhere((key, value) => value == null);
    return _TransactionUtils._transactionJsonToBinaryCodecForm(toJs);
  }

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
          [..._TransactionUtils._transactionSignaturePrefix, ...result],
          lowerCase: false);
    }
    return BytesUtils.toHexString(result, lowerCase: false);
  }

  String toMultisigBlob(String address) {
    final result = STObject.fromValue(toXrpl(), true).toBytes();
    final addr = XRPAddress(address, allowXAddress: true);
    return BytesUtils.toHexString([
      ..._TransactionUtils._transactionMultisigPrefix,
      ...result,
      ...addr.toBytes()
    ], lowerCase: false);
  }

  String getHash() {
    if (!(signer?.isReady ?? false) &&
        (_multisigSigners.isEmpty ||
            _multisigSigners.any((element) => !element.isReady))) {
      throw const XRPLTransactionException(
          'Cannot get the hash from an unsigned Transaction.');
    }
    final encodeStr =
        '${_TransactionUtils._transactionHashPrefix}${toBlob(forSigning: false)}';
    final toDigest = BytesUtils.toHexString(
            QuickCrypto.sha512Hash(BytesUtils.fromHexString(encodeStr)),
            lowerCase: false)
        .substring(0, _TransactionUtils.hashStringLength);
    return toDigest;
  }

  bool isSigned() {
    if (_multisigSigners.isNotEmpty) {
      for (final signer in _multisigSigners) {
        if (!signer.isReady) {
          return false;
        }
      }
      return true;
    }

    return signer?.isReady ?? false;
  }

  factory XRPTransaction.fromBlob(String hexBlob) {
    List<int> toBytes = BytesUtils.fromHexString(hexBlob);
    final prefix = toBytes.sublist(0, 4);
    if (BytesUtils.bytesEqual(
            prefix, _TransactionUtils._transactionMultisigPrefix) ||
        BytesUtils.bytesEqual(
            prefix, _TransactionUtils._transactionSignaturePrefix)) {
      toBytes = toBytes.sublist(4);
      if (BytesUtils.bytesEqual(
          prefix, _TransactionUtils._transactionMultisigPrefix)) {
        toBytes = toBytes.sublist(0, toBytes.length - Hash160.lengthBytes);
      }
    }
    final parser = BinaryParser(toBytes);
    final data = STObject.fromParser(parser);
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
      XRPLTransactionType.fromValue(json['transaction_type']);
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
      throw XRPLTransactionException(
          "Invalid Transaction ${json["transaction_type"]}");
  }
}
