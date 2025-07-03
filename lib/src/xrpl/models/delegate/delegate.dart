import 'package:blockchain_utils/utils/equatable/equatable.dart';
import 'package:xrpl_dart/xrpl_dart.dart';

/// Represents one entry in a Permissions list used in DelegateSet transaction.
class Permission extends XRPLBase with Equality {
  /// Transaction level or granular permission
  final PermissionKind permissionValue;
  Permission.fromJson(Map<String, dynamic> json)
      : permissionValue =
            PermissionKind.fromValue(json["permission"]["permission_value"]);

  const Permission({required this.permissionValue});

  @override
  Map<String, dynamic> toJson() {
    return {
      "permission": {"permission_value": permissionValue.value}
    };
  }

  @override
  List get variabels => [permissionValue];
}

class DelegateSetConst {
  static const int permissionsMaxLength = 10;
  static const List<SubmittableTransactionType> nonDelegableTransactions = [
    SubmittableTransactionType.accountSet,
    SubmittableTransactionType.setRegularKey,
    SubmittableTransactionType.signerListSet,
    SubmittableTransactionType.delegateSet,
    SubmittableTransactionType.accountDelete,
    SubmittableTransactionType.batch,
  ];
}

/// DelegateSet allows an account to delegate a set of permissions to another account.
class DelegateSet extends SubmittableTransaction {
  /// The authorized account.
  final String authorize;

  /// The transaction permissions that the authorized account has been granted.
  final List<Permission> permissions;
  DelegateSet.fromJson(super.json)
      : authorize = json["authorize"],
        permissions = (json["permissions"] as List)
            .map((e) => Permission.fromJson(e))
            .toList(),
        super.json();

  DelegateSet({
    required super.account,
    required this.authorize,
    required this.permissions,
    super.accountTxId,
    super.fee,
    super.flags,
    super.lastLedgerSequence,
    super.memos,
    super.multisigSigners,
    super.networkId,
    super.sequence,
    super.signer,
    super.sourceTag,
    super.ticketSequance,
  }) : super(transactionType: SubmittableTransactionType.delegateSet);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      "authorize": authorize,
      "permissions": permissions.map((e) => e.toJson()).toList()
    }..removeWhere((_, v) => v == null);
  }

  @override
  String? get validate {
    if (permissions.length > DelegateSetConst.permissionsMaxLength) {
      return 'Length of `permissions` list is greater than ${DelegateSetConst.permissionsMaxLength}.';
    }

    if (permissions.length != permissions.toSet().length) {
      return 'Duplicate permission value in `permissions` list.';
    }

    if (permissions.any((e) => DelegateSetConst.nonDelegableTransactions
        .contains(e.permissionValue))) {
      return 'Non-delegable transactions found in `permissions`.';
    }
    return super.validate;
  }
}
