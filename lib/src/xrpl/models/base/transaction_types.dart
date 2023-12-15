class XRPLTransactionType {
  // Represents the "AccountDelete" transaction type.
  static const XRPLTransactionType accountDelete =
      XRPLTransactionType("AccountDelete");

  // Represents the "AccountSet" transaction type.
  static const XRPLTransactionType accountSet =
      XRPLTransactionType("AccountSet");

  // Represents the "AMMBid" transaction type.
  static const XRPLTransactionType ammBid = XRPLTransactionType("AMMBid");

  // Represents the "AMMCreate" transaction type.
  static const XRPLTransactionType ammCreate = XRPLTransactionType("AMMCreate");

  // Represents the "AMMDelete" transaction type.
  static const XRPLTransactionType ammDelete = XRPLTransactionType("AMMDelete");

  // Represents the "AMMDeposit" transaction type.
  static const XRPLTransactionType ammDeposit =
      XRPLTransactionType("AMMDeposit");

  // Represents the "AMMVote" transaction type.
  static const XRPLTransactionType ammVote = XRPLTransactionType("AMMVote");

  // Represents the "AMMWithdraw" transaction type.
  static const XRPLTransactionType ammWithdraw =
      XRPLTransactionType("AMMWithdraw");

  // Represents the "CheckCancel" transaction type.
  static const XRPLTransactionType checkCancel =
      XRPLTransactionType("CheckCancel");

  // Represents the "CheckCash" transaction type.
  static const XRPLTransactionType checkCash = XRPLTransactionType("CheckCash");

  // Represents the "CheckCreate" transaction type.
  static const XRPLTransactionType checkCreate =
      XRPLTransactionType("CheckCreate");

  // Represents the "Clawback" transaction type.
  static const XRPLTransactionType clawback = XRPLTransactionType("Clawback");

  // Represents the "DepositPreauth" transaction type.
  static const XRPLTransactionType depositPreauth =
      XRPLTransactionType("DepositPreauth");

  // Represents the "EscrowCancel" transaction type.
  static const XRPLTransactionType escrowCancel =
      XRPLTransactionType("EscrowCancel");

  // Represents the "EscrowCreate" transaction type.
  static const XRPLTransactionType escrowCreate =
      XRPLTransactionType("EscrowCreate");

  // Represents the "EscrowFinish" transaction type.
  static const XRPLTransactionType escrowFinish =
      XRPLTransactionType("EscrowFinish");

  // Represents the "NFTokenAcceptOffer" transaction type.
  static const XRPLTransactionType nftokenAcceptOffer =
      XRPLTransactionType("NFTokenAcceptOffer");

  // Represents the "NFTokenBurn" transaction type.
  static const XRPLTransactionType nftokenBurn =
      XRPLTransactionType("NFTokenBurn");

  // Represents the "NFTokenCancelOffer" transaction type.
  static const XRPLTransactionType nftokenCancelOffer =
      XRPLTransactionType("NFTokenCancelOffer");

  // Represents the "NFTokenCreateOffer" transaction type.
  static const XRPLTransactionType nftokenCreateOffer =
      XRPLTransactionType("NFTokenCreateOffer");

  // Represents the "NFTokenMint" transaction type.
  static const XRPLTransactionType nftokenMint =
      XRPLTransactionType("NFTokenMint");

  // Represents the "OfferCancel" transaction type.
  static const XRPLTransactionType offerCancel =
      XRPLTransactionType("OfferCancel");

  // Represents the "OfferCreate" transaction type.
  static const XRPLTransactionType offerCreate =
      XRPLTransactionType("OfferCreate");

  // Represents the "Payment" transaction type.
  static const XRPLTransactionType payment = XRPLTransactionType("Payment");

  // Represents the "PaymentChannelClaim" transaction type.
  static const XRPLTransactionType paymentChannelClaim =
      XRPLTransactionType("PaymentChannelClaim");

  // Represents the "PaymentChannelCreate" transaction type.
  static const XRPLTransactionType paymentChannelCreate =
      XRPLTransactionType("PaymentChannelCreate");

  // Represents the "PaymentChannelFund" transaction type.
  static const XRPLTransactionType paymentChannelFund =
      XRPLTransactionType("PaymentChannelFund");

  // Represents the "SetRegularKey" transaction type.
  static const XRPLTransactionType setRegularKey =
      XRPLTransactionType("SetRegularKey");

  // Represents the "SignerListSet" transaction type.
  static const XRPLTransactionType signerListSet =
      XRPLTransactionType("SignerListSet");

  // Represents the "TicketCreate" transaction type.
  static const XRPLTransactionType ticketCreate =
      XRPLTransactionType("TicketCreate");

  // Represents the "TrustSet" transaction type.
  static const XRPLTransactionType trustSet = XRPLTransactionType("TrustSet");

  // Represents the "XChainAccountCreateCommit" transaction type.
  static const XRPLTransactionType xChainAccountCreateCommit =
      XRPLTransactionType("XChainAccountCreateCommit");

  // Represents the "XChainAddAccountCreateAttestation" transaction type.
  static const XRPLTransactionType xChainAddAccountCreateAttestation =
      XRPLTransactionType("XChainAddAccountCreateAttestation");

  // Represents the "XChainAddClaimAttestation" transaction type.
  static const XRPLTransactionType xChainAddClaimAttestation =
      XRPLTransactionType("XChainAddClaimAttestation");

  // Represents the "XChainClaim" transaction type.
  static const XRPLTransactionType xChainClaim =
      XRPLTransactionType("XChainClaim");

  // Represents the "XChainCommit" transaction type.
  static const XRPLTransactionType xChainCommit =
      XRPLTransactionType("XChainCommit");

  // Represents the "XChainCreateBridge" transaction type.
  static const XRPLTransactionType xChainCreateBridge =
      XRPLTransactionType("XChainCreateBridge");

  // Represents the "XChainCreateClaimId" transaction type.
  static const XRPLTransactionType xChainCreateClaimId =
      XRPLTransactionType("XChainCreateClaimID");

  // Represents the "XChainModifyBridge" transaction type.
  static const XRPLTransactionType xChainModifyBridge =
      XRPLTransactionType("XChainModifyBridge");

  // Represents the "DIDDelete" transaction type.
  static const XRPLTransactionType didDelete = XRPLTransactionType("DIDDelete");

  // Represents the "DIDSet" transaction type.
  static const XRPLTransactionType didSet = XRPLTransactionType("DIDSet");

  // Represents an unsupported or unknown transaction type.
  static const XRPLTransactionType unsupported = XRPLTransactionType("");

  // The string value associated with each transaction type.
  final String value;

  // Constructor for
  const XRPLTransactionType(this.value);

  // Factory method to create an enum instance from its string value.
  factory XRPLTransactionType.fromValue(String value,
      {XRPLTransactionType? defaultValue = unsupported}) {
    return values.firstWhere(
      (element) => element.value == value,
      orElse: defaultValue == null ? null : () => defaultValue,
    );
  }

  static const List<XRPLTransactionType> values = [
    accountDelete,
    accountSet,
    ammBid,
    ammCreate,
    ammDelete,
    ammDeposit,
    ammVote,
    ammWithdraw,
    checkCancel,
    checkCash,
    checkCreate,
    clawback,
    depositPreauth,
    escrowCancel,
    escrowCreate,
    escrowFinish,
    nftokenAcceptOffer,
    nftokenBurn,
    nftokenCancelOffer,
    nftokenCreateOffer,
    nftokenMint,
    offerCancel,
    offerCreate,
    payment,
    paymentChannelClaim,
    paymentChannelCreate,
    paymentChannelFund,
    setRegularKey,
    signerListSet,
    ticketCreate,
    trustSet,
    xChainAccountCreateCommit,
    xChainAddAccountCreateAttestation,
    xChainAddClaimAttestation,
    xChainClaim,
    xChainCommit,
    xChainCreateBridge,
    xChainCreateClaimId,
    xChainModifyBridge,
    didDelete,
    didSet,
    unsupported,
  ];
}
