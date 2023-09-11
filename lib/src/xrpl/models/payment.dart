import 'package:xrp_dart/src/xrpl/models/currencies/currencies.dart';
import 'package:xrp_dart/src/xrpl/models/path.dart';
import 'package:xrp_dart/src/xrpl/models/transaction_types.dart';
import 'package:xrp_dart/src/xrpl/utilities.dart';

import 'transaction.dart';

/// Represents a Payment [https://xrpl.org/payment.html](https://xrpl.org/payment.html) transaction, which
/// sends value from one account to another. (Depending on the path taken, this
/// can involve additional exchanges of value, which occur atomically.) This
/// transaction type can be used for several `types of payments
/// [http://xrpl.local/payment.html#types-of-payments](http://xrpl.local/payment.html#types-of-payments).
/// Payments are also the only way to `create accounts
/// [http://xrpl.local/payment.html#creating-accounts](http://xrpl.local/payment.html#creating-accounts).
class Payment extends XRPTransaction {
  final CurrencyAmount amount;
  final String destination;
  final int? destinationTag;
  final String? invoiceId;
  final List<List<PathStep>>? paths;
  final String? sendMax;
  final String? deliverMin;

  /// [amount] The amount of currency to deliver. If the Partial Payment flag is set,
  /// deliver *up to* this amount instead
  /// [destination] The address of the account receiving the payment
  /// [invoiceId] Arbitrary 256-bit hash representing a specific reason or identifier for this Check.
  /// [paths] Array of payment paths to be used (for a cross-currency payment).
  /// Must be omitted for XRP-to-XRP transactions.
  /// [sendMax] Maximum amount of source currency this transaction is allowed to cost
  /// [deliverMin] Minimum amount of destination currency this transaction should deliver
  Payment({
    required this.amount,
    required this.destination,
    required super.account,
    super.multiSigSigners,
    super.accountTxId,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.flags,
    super.memos,
    super.networkId,
    super.signers,
    super.signingPubKey,
    super.sourceTag,
    super.ticketSequance,
    super.txnSignature,
    this.destinationTag,
    this.invoiceId,
    this.paths,
    this.sendMax,
    this.deliverMin,
  }) : super(transactionType: XRPLTransactionType.PAYMENT);

  Payment.fromJson(Map<String, dynamic> json)
      : amount = CurrencyAmount.fromJson(json["amount"]),
        destination = json["destination"],
        paths = (json["paths"] as List?)
            ?.map((e) => (e as List).map((e) => PathStep.fromJson(e)).toList())
            .toList(),
        invoiceId = json["invoice_id"],
        sendMax = json["send_max"],
        deliverMin = json["deliver_min"],
        destinationTag = json["destination_tag"],
        super.json(json);

  @override
  Map<String, dynamic> toJson() {
    final existsPaths =
        paths?.map((e) => e.map((e) => e.toJson()).toList()).toList();
    final expand = existsPaths?.expand((element) => element).toList();
    final Map<String, dynamic> json = super.toJson();
    addWhenNotNull(json, "amount", amount.toJson());
    addWhenNotNull(json, "destination", destination);
    addWhenNotNull(json, "destination_tag", destinationTag);
    addWhenNotNull(
        json, "paths", (expand?.isEmpty ?? true) ? null : existsPaths);
    addWhenNotNull(json, "invoice_id", invoiceId);
    addWhenNotNull(json, "send_max", sendMax);
    addWhenNotNull(json, "deliver_min", deliverMin);
    return json;
  }
}
