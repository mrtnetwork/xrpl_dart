import 'package:blockchain_utils/helper/extensions/extensions.dart';
import 'package:xrpl_dart/src/xrpl/models/base/submittable_transaction.dart';
import 'package:xrpl_dart/src/xrpl/models/base/transaction_types.dart';
import 'package:xrpl_dart/src/xrpl/models/deposit_preauth/deposit_preauth.dart';

class PermissionedDomainSetConst {
  static const int domainIdLength = 64;
  static const int credentialsLength = 10;
}

/// This transaction creates or modifies a PermissionedDomain object.
class PermissionedDomainSet extends SubmittableTransaction {
  /// The domain to modify. Must be included if modifying an existing domain.
  final String? domainId;

  /// The credentials that are accepted by the domain. Ownership of one of these
  /// credentials automatically makes you a member of the domain. An empty array means
  /// deleting the field.
  final List<Credential> acceptedCredentials;
  PermissionedDomainSet({
    this.domainId,
    required List<Credential> acceptedCredentials,
    required super.account,
    super.lastLedgerSequence,
    super.flags,
    super.fee,
    super.accountTxId,
    super.delegate,
    super.memos,
    super.multisigSigners,
    super.networkId,
    super.sequence,
    super.signer,
    super.sourceTag,
    super.ticketSequance,
  })  : acceptedCredentials = acceptedCredentials.immutable,
        super(
            transactionType: SubmittableTransactionType.permissionedDomainSet);

  PermissionedDomainSet.fromJson(super.json)
      : domainId = json["domain_id"],
        acceptedCredentials = (json["accepted_credentials"] as List)
            .map((e) => Credential.fromJson(e))
            .toList(),
        super.json();

  @override
  Map<String, dynamic> toJson() {
    return {
      "accepted_credentials":
          acceptedCredentials.map((e) => e.toJson()).toList(),
      "domain_id": domainId,
      ...super.toJson(),
    }..removeWhere((_, v) => v == null);
  }

  @override
  String? get validate {
    if (acceptedCredentials.isEmpty) {
      return "At least one accepted credential is required.";
    }
    if (acceptedCredentials.length >
        PermissionedDomainSetConst.credentialsLength) {
      return "The number of accepted credentials cannot exceed ${PermissionedDomainSetConst.credentialsLength}.";
    }
    return super.validate;
  }
}
