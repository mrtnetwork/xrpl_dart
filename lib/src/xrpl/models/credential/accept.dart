import 'package:xrpl_dart/src/xrpl/models/base/submittable_transaction.dart';
import 'package:xrpl_dart/src/xrpl/models/base/transaction_types.dart';

import 'create.dart';

class CredentialAccept extends SubmittableTransaction {
  /// The issuer of the credential.
  final String issuer;

  /// A hex-encoded value to identify the type of credential from the issuer.
  final String credentialType;

  CredentialAccept({
    required this.issuer,
    required this.credentialType,
    required super.account,
  }) : super(transactionType: SubmittableTransactionType.credentialAccept);

  CredentialAccept.fromJson(super.json)
      : issuer = json['issuer'],
        credentialType = json['credential_type'],
        super.json();

  @override
  Map<String, dynamic> toJson() {
    return {
      "credential_type": credentialType,
      "issuer": issuer,
      ...super.toJson(),
    }..removeWhere((_, v) => v == null);
  }

  @override
  String? get validate {
    final typeError = CredentialUtils.validateCredentialType(credentialType);
    return typeError ?? super.validate;
  }
}
