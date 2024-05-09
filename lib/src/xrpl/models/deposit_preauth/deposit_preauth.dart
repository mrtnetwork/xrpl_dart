import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';
import 'package:xrpl_dart/src/crypto/crypto.dart';

/// Represents a [DepositPreauth](https://xrpl.org/depositpreauth.html)
/// transaction, which gives another account pre-approval to deliver payments to
/// the sender of this transaction, if this account is using
/// [Deposit Authorization](https://xrpl.org/depositauth.html).
class DepositPreauth extends XRPTransaction {
  /// [authorize] Grant preauthorization to this address. You must provide this OR
  /// unauthorize but not both.
  final String? authorize;

  /// [unauthorize] Revoke preauthorization from this address. You must provide this OR
  /// authorize but not both.
  final String? unauthorize;

  DepositPreauth({
    required String account,
    this.authorize,
    this.unauthorize,
    List<XRPLMemo>? memos = const [],
    XRPLSignature? signer,
    int? ticketSequance,
    BigInt? fee,
    int? lastLedgerSequence,
    int? sequence,
    List<XRPLSigners>? multisigSigners,
    int? flags,
    int? sourceTag,
  }) : super(
            account: account,
            fee: fee,
            lastLedgerSequence: lastLedgerSequence,
            memos: memos,
            sequence: sequence,
            multisigSigners: multisigSigners,
            sourceTag: sourceTag,
            flags: flags,
            ticketSequance: ticketSequance,
            signer: signer,
            transactionType: XRPLTransactionType.depositPreauth);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      "authorize": authorize,
      "unauthorize": unauthorize,
      ...super.toJson()
    };
  }

  DepositPreauth.fromJson(Map<String, dynamic> json)
      : authorize = json["authorize"],
        unauthorize = json["unauthorize"],
        super.json(json);
  @override
  String? get validate {
    if (authorize != null && unauthorize != null) {
      return "One of authorize and unauthorize must be set, not both.";
    }
    if (authorize == null && unauthorize == null) {
      return "One of authorize and unauthorize must be set.";
    }
    return super.validate;
  }
}
