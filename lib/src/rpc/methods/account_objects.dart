import 'package:xrpl_dart/src/rpc/methods/methods.dart';
import 'package:xrpl_dart/src/rpc/on_chain_models/on_chain_models.dart';
import '../core/methods_impl.dart';

class AccountObjectType {
  /// Represents a check object.
  static const AccountObjectType check = AccountObjectType._('check');

  /// Represents a deposit_preauth object.
  static const AccountObjectType depositPreauth =
      AccountObjectType._('deposit_preauth');

  /// Represents an escrow object.
  static const AccountObjectType escrow = AccountObjectType._('escrow');

  /// Represents an offer object.
  static const AccountObjectType offer = AccountObjectType._('offer');

  /// Represents a payment_channel object.
  static const AccountObjectType paymentChannel =
      AccountObjectType._('payment_channel');

  /// Represents a signer_list object.
  static const AccountObjectType signerList =
      AccountObjectType._('signer_list');

  /// Represents a state object.
  static const AccountObjectType state = AccountObjectType._('state');

  /// Represents a ticket object.
  static const AccountObjectType ticket = AccountObjectType._('ticket');

  /// Represents an AMM (Automated Market Maker) object.
  static const AccountObjectType aMM = AccountObjectType._('amm');

  /// Represents a bridge object.
  static const AccountObjectType bridge = AccountObjectType._('bridge');

  /// Represents a DID (Decentralized Identifier) object.
  static const AccountObjectType did = AccountObjectType._('did');

  /// Represents an xChain owned create account claim ID object.
  static const AccountObjectType xChainOwnedCreateAccountClaimId =
      AccountObjectType._('xchain_owned_create_account_claim_id');

  /// Represents an xChain owned claim ID object.
  static const AccountObjectType xChainOwnerClaimId =
      AccountObjectType._('xchain_owned_claim_id');

  /// Represents an NFT (Non-Fungible Token) offer object.
  static const AccountObjectType nftOffer = AccountObjectType._('nft_offer');

  /// The string value associated with each object type.
  final String value;

  /// Private constructor to initialize the string value for each object type.
  const AccountObjectType._(this.value);
}

/// This request returns the raw ledger format for all objects owned by an account.
/// For a higher-level view of an account's trust lines and balances, see
/// AccountLinesRequest instead.
// See [account_objects](https://xrpl.org/account_objects.html)
class XRPRequestAccountObjectType
    extends XRPLedgerRequest<Map<String, dynamic>, Map<String, dynamic>> {
  XRPRequestAccountObjectType({
    required this.account,
    this.type,
    this.deleteBlockersOnly = false,
    this.limit,
    this.marker,
    super.ledgerIndex = XRPLLedgerIndex.validated,
  });
  @override
  String get method => XRPRequestMethod.accountObjects;

  final String account;
  final AccountObjectType? type;
  final int? limit;
  final bool deleteBlockersOnly;
  final dynamic marker;

  @override
  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'type': type?.value,
      'deletion_blockers_only': deleteBlockersOnly,
      'limit': limit,
      'marker': marker
    };
  }
}
