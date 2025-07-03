import 'package:blockchain_utils/utils/string/string.dart';
import 'package:xrpl_dart/src/xrpl/models/base/submittable_transaction.dart';
import 'package:xrpl_dart/src/xrpl/models/base/transaction_types.dart';

import 'set.dart';

/// This transaction deletes a PermissionedDomain object.
class PermissionedDomainDelete extends SubmittableTransaction {
  /// The domain to delete.
  final String domainId;

  PermissionedDomainDelete({
    required this.domainId,
    required super.account,
  }) : super(
            transactionType:
                SubmittableTransactionType.permissionedDomainDelete);

  PermissionedDomainDelete.fromJson(super.json)
      : domainId = json["domain_id"],
        super.json();

  @override
  Map<String, dynamic> toJson() {
    return {"domain_id": domainId, ...super.toJson()}
      ..removeWhere((_, v) => v == null);
  }

  @override
  String? get validate {
    if (!StringUtils.isHexBytes(domainId) ||
        StringUtils.strip0x(domainId.toLowerCase()).length !=
            PermissionedDomainSetConst.domainIdLength) {
      return "domainId must be a valid ${PermissionedDomainSetConst.domainIdLength ~/ 2} bytes hexadecimal string.";
    }
    return super.validate;
  }
}
