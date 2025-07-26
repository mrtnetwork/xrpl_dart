import 'package:blockchain_utils/helper/helper.dart';
import 'package:blockchain_utils/utils/equatable/equatable.dart';
import 'package:xrpl_dart/src/xrpl/models/xrp_transactions.dart';

class DepositPreauthConst {
  static const int maxCredentialsLength = 8;
}

/// Represents a [DepositPreauth](https://xrpl.org/depositpreauth.html)
/// transaction, which gives another account pre-approval to deliver payments to
/// the sender of this transaction, if this account is using
/// [Deposit Authorization](https://xrpl.org/depositauth.html).
class DepositPreauth extends SubmittableTransaction {
  /// [authorize] Grant preauthorization to this address. You must provide this OR
  /// unauthorize but not both.
  final String? authorize;

  /// [unauthorize] Revoke preauthorization from this address. You must provide this OR
  /// authorize but not both.
  final String? unauthorize;

  /// The credential(s) that received the preauthorization. (Any account with these
  /// credentials can send preauthorized payments).
  final List<Credential>? authorizeCredentials;

  /// The credential(s) whose preauthorization should be revoked.
  final List<Credential>? unauthorizeCredentials;

  DepositPreauth({
    required super.account,
    List<Credential>? authorizeCredentials,
    List<Credential>? unauthorizeCredentials,
    this.authorize,
    this.unauthorize,
    super.memos,
    super.signer,
    super.ticketSequance,
    super.fee,
    super.lastLedgerSequence,
    super.sequence,
    super.multisigSigners,
    super.flags,
    super.sourceTag,
    super.accountTxId,
    super.delegate,
    super.networkId,
  })  : authorizeCredentials = authorizeCredentials?.immutable,
        unauthorizeCredentials = unauthorizeCredentials?.immutable,
        super(transactionType: SubmittableTransactionType.depositPreauth);

  /// Converts the object to a JSON representation.
  @override
  Map<String, dynamic> toJson() {
    return {
      'authorize': authorize,
      'unauthorize': unauthorize,
      "authorize_credentials":
          authorizeCredentials?.map((e) => e.toJson()).toList(),
      "unauthorize_credentials":
          unauthorizeCredentials?.map((e) => e.toJson()).toList(),
      ...super.toJson()
    }..removeWhere((_, v) => v == null);
  }

  DepositPreauth.fromJson(super.json)
      : authorize = json['authorize'],
        unauthorize = json['unauthorize'],
        authorizeCredentials = (json["authorize_credentials"] as List?)
            ?.map((e) => Credential.fromJson(e))
            .toImutableList
            .emptyAsNull,
        unauthorizeCredentials = (json["unauthorize_credentials"] as List?)
            ?.map((e) => Credential.fromJson(e))
            .toImutableList
            .emptyAsNull,
        super.json();
  @override
  String? get validate {
    if (authorize != null && unauthorize != null) {
      return 'One of authorize and unauthorize must be set, not both.';
    }
    final fields = [
      authorize,
      unauthorize,
      authorizeCredentials,
      unauthorizeCredentials
    ].where((e) => e != null);
    if (fields.length != 1) {
      return "DepositPreauth transaction requires exactly one of the following inputs: 'authorize', 'unauthorize', 'authorizeCredentials', or 'unauthorizeCredentials'.";
    }
    final creds = [authorizeCredentials, unauthorizeCredentials];
    for (final i in creds) {
      if (i == null) continue;
      if (i.length > DepositPreauthConst.maxCredentialsLength) {
        return "Each credential list cannot exceed ${DepositPreauthConst.maxCredentialsLength} entries.";
      }
      if (i.toSet().length != i.length) {
        return "Duplicate credentials are not allowed within the same list.";
      }
    }

    return super.validate;
  }
}

/// An inner object representing individual element inside AuthorizeCredentials and
/// UnauthorizeCredentials array.
class Credential extends XRPLBase with Equality {
  /// The issuer of the credential.
  final String issuer;

  /// A hex-encoded value to identify the type of credential from the issuer.
  final String credentialType;

  const Credential({required this.issuer, required this.credentialType});
  Credential.fromJson(Map<String, dynamic> json)
      : issuer = json["credential"]["issuer"],
        credentialType = json["credential"]["credential_type"];

  @override
  Map<String, dynamic> toJson() {
    return {
      "credential": {"issuer": issuer, "credential_type": credentialType}
    };
  }

  @override
  List get variabels => [issuer, credentialType];
}
