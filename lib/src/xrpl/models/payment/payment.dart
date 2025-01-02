import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

/// Transactions of the Payment type support additional values in the Flags field.
/// This enum represents those options.
/// See [Payment Flags](https://xrpl.org/payment.html#payment-flags)
class PaymentFlag implements FlagsInterface {
  // Do not use the default path; only use paths included in the Paths field.
  // This is intended to force the transaction to take arbitrage opportunities.
  // Most clients do not need this.
  static const PaymentFlag tfNoDirectRipple =
      PaymentFlag('NoDirectRipple', 0x00010000);

  // If the specified Amount cannot be sent without spending more than SendMax,
  // reduce the received amount instead of failing outright.
  // See [Partial Payments](https://xrpl.org/partial-payments.html) more details.
  static const PaymentFlag tfPartialPayment =
      PaymentFlag('PartialPaymen', 0x00020000);

  // Only take paths where all the conversions have an input:output ratio
  // that is equal or better than the ratio of Amount:SendMax.
  // See [Limit](https://xrpl.org/payment.html#limit-quality) Quality.
  static const PaymentFlag tfLimitQuality =
      PaymentFlag('LimitQuality', 0x00040000);

  // The integer value associated with each flag.
  final int value;
  final String name;

  // Constructor for PaymentFlag.
  const PaymentFlag(this.name, this.value);

  static const List<PaymentFlag> values = [
    tfNoDirectRipple,
    tfPartialPayment,
    tfLimitQuality
  ];

  @override
  int get id => value;
}

/// Represents a Payment [https://xrpl.org/payment.html](https://xrpl.org/payment.html) transaction, which
/// sends value from one account to another. (Depending on the path taken, this
/// can involve additional exchanges of value, which occur atomically.) This
/// transaction type can be used for several types of payments
/// [http://xrpl.local/payment.html#types-of-payments](http://xrpl.local/payment.html#types-of-payments).
/// Payments are also the only way to create accounts
/// [http://xrpl.local/payment.html#creating-accounts](http://xrpl.local/payment.html#creating-accounts).
class Payment extends XRPTransaction {
  /// [amount] The amount of currency to deliver. If the Partial Payment flag is set,
  /// deliver *up to* this amount instead
  final CurrencyAmount amount;

  /// [destination] The address of the account receiving the payment
  final String destination;
  final int? destinationTag;

  /// [invoiceId] Arbitrary 256-bit hash representing a specific reason or identifier for this Check.
  final String? invoiceId;

  /// [paths] Array of payment paths to be used (for a cross-currency payment).
  /// Must be omitted for XRP-to-XRP transactions.
  final List<List<PathStep>>? paths;

  /// [sendMax] Maximum amount of source currency this transaction is allowed to cost
  final String? sendMax;

  /// [deliverMin] Minimum amount of destination currency this transaction should deliver
  final String? deliverMin;

  Payment({
    required this.amount,
    required this.destination,
    required super.account,
    this.destinationTag,
    this.invoiceId,
    this.paths,
    this.sendMax,
    this.deliverMin,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
  }) : super(transactionType: XRPLTransactionType.payment);

  Payment.fromJson(super.json)
      : amount = CurrencyAmount.fromJson(json['amount']),
        destination = json['destination'],
        paths = (json['paths'] as List?)
            ?.map((e) => (e as List).map((e) => PathStep.fromJson(e)).toList())
            .toList(),
        invoiceId = json['invoice_id'],
        sendMax = json['send_max'],
        deliverMin = json['deliver_min'],
        destinationTag = json['destination_tag'],
        super.json();

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    final existsPaths =
        paths?.map((e) => e.map((e) => e.toJson()).toList()).toList();
    final expand = existsPaths?.expand((element) => element).toList();

    return {
      'amount': amount.toJson(),
      'destination': destination,
      'destination_tag': destinationTag,
      'paths': (expand?.isEmpty ?? true) ? null : existsPaths,
      'invoice_id': invoiceId,
      'send_max': sendMax,
      'deliver_min': deliverMin,
      ...super.toJson()
    };
  }

  @override
  String? get validate {
    if (amount.isXrp && sendMax == null) {
      if (paths != null) {
        return 'paths An XRP-to-XRP payment cannot contain paths.';
      }
      if (account == destination) {
        return 'An XRP payment transaction cannot have the same sender and destination';
      }
    }
    return super.validate;
  }
}
