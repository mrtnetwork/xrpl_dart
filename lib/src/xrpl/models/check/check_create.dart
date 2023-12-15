import 'package:xrp_dart/src/utility/helper.dart';
import 'package:xrp_dart/src/xrpl/models/xrp_transactions.dart';

/// Represents a CheckCreate [https://xrpl.org/checkcreate.html](https://xrpl.org/checkcreate.html) transaction,
/// which creates a Check object. A Check object is a deferred payment
/// that can be cashed by its intended destination. The sender of this
/// transaction is the sender of the Check.
class CheckCreate extends XRPTransaction {
  /// [destination] The address of the account that can cash the Check
  final String destination;

  /// [sendMax] Maximum amount of source token the Check is allowed to debit the
  /// sender, including transfer fees on non-XRP tokens. The Check can only
  /// credit the destination with the same token (from the same issuer, for
  /// non-XRP tokens).
  final CurrencyAmount sendMax;

  /// An arbitrary [destination tag](https://xrpl.org/source-and-destination-tags.html)that
  /// identifies the reason for the Check, or a hosted recipient to pay.
  final String? destinationTag;

  /// [expiration] Time after which the Check is no longer valid
  late final int? expiration;

  /// [invoiceId] Arbitrary 256-bit hash representing a specific reason or identifier for
  /// this Check.
  final String? invoiceId;

  CheckCreate(
      {required String account,
      required this.destination,
      required this.sendMax,
      this.destinationTag,
      DateTime? expirationTime,
      this.invoiceId,
      List<XRPLMemo>? memos = const [],
      String signingPubKey = "",
      int? ticketSequance,
      BigInt? fee,
      int? lastLedgerSequence,
      int? sequence,
      List<XRPLSigners>? signers,
      dynamic flags,
      int? sourceTag,
      List<String> multiSigSigners = const []})
      : super(
            account: account,
            fee: fee,
            lastLedgerSequence: lastLedgerSequence,
            memos: memos,
            sequence: sequence,
            signers: signers,
            sourceTag: sourceTag,
            flags: flags,
            ticketSequance: ticketSequance,
            signingPubKey: signingPubKey,
            multiSigSigners: multiSigSigners,
            transactionType: XRPLTransactionType.checkCreate) {
    if (expirationTime != null) {
      expiration = XRPHelper.datetimeToRippleTime(expirationTime);
    } else {
      expiration = null;
    }
  }

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      "destination": destination,
      "send_max": sendMax.toJson(),
      "destination_tag": destinationTag,
      "expiration": expiration,
      "invoice_id": invoiceId,
      ...super.toJson()
    };
  }

  CheckCreate.fromJson(Map<String, dynamic> json)
      : destination = json["destination"],
        destinationTag = json["destination_tag"],
        sendMax = CurrencyAmount.fromJson(json["send_max"]),
        expiration = json["expiration"],
        invoiceId = json["invoice_id"],
        super.json(json);
}
