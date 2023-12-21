import 'package:xrp_dart/src/xrpl/models/xrp_transactions.dart';

/// Transactions of the TrustSet type support additional values in the Flags field.
/// This enum represents those options.
class TrustSetFlag implements FlagsInterface {
  // Authorize the other party to hold
  // currency issued by this [account](https://xrpl.org/tokens.html).
  // (No effect unless using the [asfRequireAuth AccountSet flag](https://xrpl.org/accountset.html#accountset-flags)
  // Cannot be unset.
  static const TrustSetFlag tfSetAuth = TrustSetFlag("SetAuth", 0x00010000);

  // Enable the No Ripple flag, which blocks
  // [rippling](https://xrpl.org/rippling.htm) between two trust
  // lines of the same currency if this flag is enabled on both.
  static const TrustSetFlag tfSetNoRipple =
      TrustSetFlag("SetNoRipple", 0x00020000);

  // Disable the No Ripple flag, allowing rippling on this trust line.
  static const TrustSetFlag tfClearNoRipple =
      TrustSetFlag("ClearNoRipple", 0x00040000);

  // Freeze the trust line.
  static const TrustSetFlag tfSetFreez = TrustSetFlag("SetFreez", 0x00100000);

  // Unfreeze the trust line.
  static const TrustSetFlag tfClearFreez =
      TrustSetFlag("ClearFreez", 0x00200000);

  // The integer value associated with each flag.
  final int value;

  /// human-readable name
  final String name;

  static const List<TrustSetFlag> values = [
    tfSetAuth,
    tfSetNoRipple,
    tfClearNoRipple,
    tfSetFreez,
    tfClearFreez
  ];

  // Constructor for TrustSetFlag.
  const TrustSetFlag(this.name, this.value);
  @override
  int get id => value;
}

/// Represents a TrustSet transaction on the XRP Ledger.
/// Creates or modifies a trust line linking two accounts.
/// See [TrustSet](https://xrpl.org/trustset.html)
class TrustSet extends XRPTransaction {
  TrustSet(
      {required String account,
      required this.limitAmount,
      this.qualityIn,
      this.qualityOut,
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
            transactionType: XRPLTransactionType.trustSet);
  final IssuedCurrencyAmount limitAmount;
  final int? qualityIn;
  final int? qualityOut;

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      "limit_amount": limitAmount.toJson(),
      "quality_in": qualityIn,
      "quality_out": qualityOut,
      ...super.toJson()
    };
  }

  TrustSet.fromJson(Map<String, dynamic> json)
      : limitAmount = IssuedCurrencyAmount.fromJson(json["limit_amount"]),
        qualityIn = json["quality_in"],
        qualityOut = json["quality_out"],
        super.json(json);
}
