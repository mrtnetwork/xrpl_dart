import 'package:xrpl_dart/src/xrpl/models/base/submittable_transaction.dart';
import 'package:xrpl_dart/src/xrpl/models/base/transaction_types.dart';

import 'create.dart';

class CredentialDelete extends SubmittableTransaction {
  /// The person that the credential is for. If omitted, Account is assumed to be the subject.
  final String? subject;

  /// A hex-encoded value to identify the type of credential from the issuer.
  final String credentialType;

  /// The issuer of the credential. If omitted, Account is assumed to be the issuer.
  final String? issuer;

  CredentialDelete({
    required this.subject,
    required this.credentialType,
    this.issuer,
    required super.account,
  }) : super(transactionType: SubmittableTransactionType.credentialDelete);

  CredentialDelete.fromJson(super.json)
      : subject = json['subject'],
        credentialType = json['credential_type'],
        issuer = json["issuer"],
        super.json();

  @override
  Map<String, dynamic> toJson() {
    return {
      "credential_type": credentialType,
      "subject": subject,
      "issuer": issuer,
      ...super.toJson(),
    };
  }

  @override
  String? get validate {
    final typeError = CredentialUtils.validateCredentialType(credentialType);
    return typeError ?? super.validate;
  }
}
