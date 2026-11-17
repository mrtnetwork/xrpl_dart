import 'package:xrpl_dart/src/rpc/methods/rpc_request_methods.dart';
import 'package:xrpl_dart/src/rpc/models/models.dart';

/// The vault_info method retrieves information about a single asset vault,
/// its owner, available assets, and details on issued shares.
class XRPRequestVaultInfo
    extends XRPLedgerRequest<VaultInfoResult, Map<String, dynamic>> {
  /// Provide either the [vaultId], or both [owner] and [seq].
  XRPRequestVaultInfo({
    this.vaultId,
    this.owner,
    this.seq,
    super.ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.vaultInfo;

  /// The ledger entry ID of the Vault to be returned.
  final String? vaultId;

  /// The account address of the Vault owner.
  final String? owner;

  /// The transaction sequence number that created the vault.
  final int? seq;

  @override
  Map<String, dynamic> toJson() {
    return {'vault_id': vaultId, 'owner': owner, 'seq': seq};
  }

  @override
  VaultInfoResult onResponse(Map<String, dynamic> result) {
    return VaultInfoResult.fromJson(result);
  }
}
