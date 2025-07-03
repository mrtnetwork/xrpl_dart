import 'package:xrpl_dart/src/xrpl/exception/exceptions.dart';

abstract class PermissionKind {
  abstract final String value;

  static PermissionKind fromValue(String input) {
    try {
      return GranularPermission.values.firstWhere((e) => e.value == input);
    } on StateError {
      return SubmittableTransactionType.fromValue(input);
    }
  }
}

enum GranularPermission implements PermissionKind {
  trustlineAuthorize("TrustlineAuthorize"),
  trustlineFreeze("TrustlineFreeze"),
  trustlineUnfreeze("TrustlineUnfreeze"),
  accountDomainSet("AccountDomainSet"),
  accountEmailHashSet("AccountEmailHashSet"),
  accountMessageKeySet("AccountMessageKeySet"),
  accountTransferRateSet("AccountTransferRateSet"),
  accountTickSizeSet("AccountTickSizeSet"),
  paymentMint("PaymentMint"),
  paymentBurn("PaymentBurn"),
  mptokenIssuanceLock("MPTokenIssuanceLock"),
  mptokenIssuanceUnlock("MPTokenIssuanceUnlock");

  @override
  final String value;
  const GranularPermission(this.value);

  static GranularPermission? fromString(String input) {
    return GranularPermission.values
        .firstWhere((e) => e.value.toLowerCase() == input.toLowerCase());
  }
}

abstract class XRPLTransactionType {
  abstract final String value;
  static XRPLTransactionType fromValue(String value) {
    try {
      return SubmittableTransactionType.fromValue(value);
    } on XRPLTransactionException {
      return PseudoTransactionType.fromValue(value);
    }
  }
}

enum SubmittableTransactionType implements PermissionKind, XRPLTransactionType {
  accountDelete('AccountDelete'),
  accountSet('AccountSet'),
  ammBid('AMMBid'),
  ammCreate('AMMCreate'),
  ammDelete('AMMDelete'),
  ammClawback('AMMClawback'),
  ammDeposit('AMMDeposit'),
  ammVote('AMMVote'),
  ammWithdraw('AMMWithdraw'),
  checkCancel('CheckCancel'),
  checkCash('CheckCash'),
  checkCreate('CheckCreate'),
  clawback('Clawback'),
  depositPreauth('DepositPreauth'),
  escrowCancel('EscrowCancel'),
  escrowCreate('EscrowCreate'),
  escrowFinish('EscrowFinish'),
  nftokenAcceptOffer('NFTokenAcceptOffer'),
  nftokenBurn('NFTokenBurn'),
  nftokenCancelOffer('NFTokenCancelOffer'),
  nftokenCreateOffer('NFTokenCreateOffer'),
  nftokenMint('NFTokenMint'),
  offerCancel('OfferCancel'),
  offerCreate('OfferCreate'),
  payment('Payment'),
  paymentChannelClaim('PaymentChannelClaim'),
  paymentChannelCreate('PaymentChannelCreate'),
  paymentChannelFund('PaymentChannelFund'),
  setRegularKey('SetRegularKey'),
  signerListSet('SignerListSet'),
  ticketCreate('TicketCreate'),
  trustSet('TrustSet'),
  xChainAccountCreateCommit('XChainAccountCreateCommit'),
  xChainAddAccountCreateAttestation('XChainAddAccountCreateAttestation'),
  xChainAddClaimAttestation('XChainAddClaimAttestation'),
  xChainClaim('XChainClaim'),
  xChainCommit('XChainCommit'),
  xChainCreateBridge('XChainCreateBridge'),
  xChainCreateClaimId('XChainCreateClaimID'),
  xChainModifyBridge('XChainModifyBridge'),
  didDelete('DIDDelete'),
  didSet('DIDSet'),
  credentialCreate('CredentialCreate'),
  credentialAccept('CredentialAccept'),
  credentialDelete('CredentialDelete'),
  mpTokenIssuanceCreate('MPTokenIssuanceCreate'),
  mpTokenAuthorize('MPTokenAuthorize'),
  mpTokenIssuanceSet('MPTokenIssuanceSet'),
  mpTokenIssuanceDestroy('MPTokenIssuanceDestroy'),
  permissionedDomainDelete('PermissionedDomainDelete'),
  permissionedDomainSet('PermissionedDomainSet'),
  oracleSet('OracleSet'),
  delegateSet('DelegateSet'),
  oracleDelete('OracleDelete'),
  batch('Batch');

  @override
  final String value;
  const SubmittableTransactionType(this.value);

  static SubmittableTransactionType fromValue(String value) {
    return SubmittableTransactionType.values.firstWhere((e) => e.value == value,
        orElse: () => throw XRPLTransactionException(
            "Unsuported transactio type $value."));
  }
}

enum PseudoTransactionType implements XRPLTransactionType {
  enableAmendment('EnableAmendment'),
  unlModify('UNLModify'),
  setFee('SetFee');

  @override
  final String value;
  const PseudoTransactionType(this.value);

  static PseudoTransactionType fromValue(String value) {
    return PseudoTransactionType.values.firstWhere((e) => e.value == value,
        orElse: () => throw XRPLTransactionException(
            "Unsuported transactio type $value."));
  }
}
