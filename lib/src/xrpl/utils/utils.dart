// import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

import 'package:xrpl_dart/src/xrpl/models/currencies/currencies.dart';

class TransactionUtils {
  static const List<int> transactionHashPrefix = [84, 88, 78, 0];
  static const List<int> batchPrefix = [66, 67, 72, 0];
  static const List<int> transactionSignaturePrefix = [0x53, 0x54, 0x58, 0x00];
  static const List<int> transactionMultisigPrefix = [0x53, 0x4D, 0x54, 0x00];

  static const int hashStringLength = 64;
  static final _camelToSnakeCaseRegex =
      RegExp(r'(?:^[^A-Z]+|[A-Z]+(?![^A-Z])|[A-Z][^A-Z]*)');
  static Map<String, dynamic> transactionJsonToBinaryCodecForm(
      Map<String, dynamic> dictionary) {
    return {
      for (final entry in dictionary.entries)
        _keyToTxJson(entry.key): _valueToTxJson(entry.value),
    };
  }

  static final _abbreviations = <String, String>{
    "amm": "AMM",
    "did": "DID",
    "id": "ID",
    "lp": "LP",
    "mptoken": "MPToken",
    "nft": "NFT",
    "nftoken": "NFToken",
    "nfts": "NFTs",
    "noripple": "NoRipple",
    "unl": "UNL",
    "uri": "URI",
    "xchain": "XChain",
  };
  static String _keyToTxJson(String key) {
    return key
        .split('_')
        .map((word) => _abbreviations[word] ?? _capitalize(word))
        .join('');
  }

  static dynamic _valueToTxJson(dynamic value) {
    if (value is Map) {
      final val = value as Map<String, dynamic>;
      if (IssuedCurrencyUtils.isIssuedCurrencyAmount(val)) {
        return value;
      } else if (MPTAmountUtils.isMptAmount(val)) {
        return value;
      }
      return transactionJsonToBinaryCodecForm(val);
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

    final words = _camelToSnakeCaseRegex.allMatches(field).map((match) {
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

  static Map<String, dynamic> formattedDict(Map<String, dynamic> value) {
    final Map<String, dynamic> result = {};

    value.forEach((k, v) {
      final String formattedKey = _keyToJson(k);
      final dynamic formattedValue = _valueToJson(v);
      result[formattedKey] = formattedValue;
    });

    return result;
  }
}
