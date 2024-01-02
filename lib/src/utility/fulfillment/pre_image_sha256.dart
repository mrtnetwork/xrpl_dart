import 'package:blockchain_utils/blockchain_utils.dart';

import 'ans1_raw_encoder.dart';

/// Represents a fulfillment with SHA-256 preimage in Dart.
/// [Crypto-Conditions Fulfillment](https://github.com/rfcs/crypto-conditions/blob/master/src/asn1/CryptoConditions.asn)
///
///
/// This class encapsulates the data related to a fulfillment with a SHA-256 preimage,
/// including the fulfillment byte array and the corresponding condition byte array.
///
/// It provides a factory method, [generate], to create an instance of [FulfillmentPreimageSha256]
/// based on a given preimage. The generation process involves creating ASN.1-encoded options
/// for fingerprint, constant, and condition, which are then used to construct the encoded
/// fulfillment and condition byte arrays.
/// Usage example:
/// ```dart
/// // Creating a FulfillmentPreimageSha256 instance with a preimage
/// List<int> preImage = [...];
/// FulfillmentPreimageSha256 fulfillment = FulfillmentPreimageSha256.generate(preImage);
///
/// // Accessing the hexadecimal string representations of fulfillment and condition
/// print(fulfillment.fulfillment);
/// print(fulfillment.condition);
/// ```
class FulfillmentPreimageSha256 {
  /// The byte array representing the fulfillment.
  final List<int> _fulfillment;

  /// The byte array representing the condition.
  final List<int> _condition;

  /// Private constructor to create an instance of [FulfillmentPreimageSha256].
  FulfillmentPreimageSha256._(this._fulfillment, this._condition);

  /// Gets the hexadecimal string representation of the fulfillment byte array.
  String get fulfillment =>
      BytesUtils.toHexString(_fulfillment, lowerCase: false);

  /// Gets the hexadecimal string representation of the condition byte array.
  String get condition => BytesUtils.toHexString(_condition, lowerCase: false);

  /// Factory method to generate a FulfillmentPreimageSha256 instance based on a preimage.
  factory FulfillmentPreimageSha256.generate(List<int> preImage) {
    final preImageHash = QuickCrypto.sha256Hash(preImage);
    final finterprintOpts = ANS1RawOptions(
        classValue: 2,
        tag: 0,
        constructed: false,
        indefinite: false,
        content: preImageHash);

    final constOpts = ANS1RawOptions(
        classValue: 2,
        tag: 1,
        constructed: false,
        indefinite: false,
        content: ASN1RawEncoder.encodeIntegerValue(preImage.length));
    final conditionOPts = ANS1RawOptions(
        classValue: 2,
        tag: 0,
        constructed: true,
        indefinite: false,
        content: [
          ...ASN1RawEncoder.encode(finterprintOpts),
          ...ASN1RawEncoder.encode(constOpts)
        ]);
    final List<int> encodedCondition =
        List<int>.unmodifiable(ASN1RawEncoder.encode(conditionOPts));
    final preImageOpts = ANS1RawOptions(
        classValue: 2,
        tag: 0,
        constructed: false,
        indefinite: false,
        content: preImage);
    final fulfillmentOpts = ANS1RawOptions(
        classValue: 2,
        tag: 0,
        constructed: true,
        indefinite: false,
        content: ASN1RawEncoder.encode(preImageOpts));
    final encodedFulfillment =
        List<int>.unmodifiable(ASN1RawEncoder.encode(fulfillmentOpts));
    return FulfillmentPreimageSha256._(encodedFulfillment, encodedCondition);
  }
}
