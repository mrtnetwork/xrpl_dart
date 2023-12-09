enum XRPLTransactionType {
  accountDelete("AccountDelete"),
  accountSet("AccountSet"),
  ammBid("AMMBid"),
  ammCreate("AMMCreate"),
  ammDelete("AMMDelete"),
  ammDeposit("AMMDeposit"),
  ammVote("AMMVote"),
  ammWithdraw("AMMWithdraw"),
  checkCancel("CheckCancel"),
  checkCash("CheckCash"),
  checkCreate("CheckCreate"),
  clawback("Clawback"),
  depositPreauth("DepositPreauth"),
  escrowCancel("EscrowCancel"),
  escrowCreate("EscrowCreate"),
  escrowFinish("EscrowFinish"),
  nftokenAcceptOffer("NFTokenAcceptOffer"),
  nftokenBurn("NFTokenBurn"),
  nftokenCancelOffer("NFTokenCancelOffer"),
  nftokenCreateOffer("NFTokenCreateOffer"),
  nftokenMint("NFTokenMint"),
  offerCancel("OfferCancel"),
  offerCreate("OfferCreate"),
  payment("Payment"),
  paymentChannelClaim("PaymentChannelClaim"),
  paymentChannelCreate("PaymentChannelCreate"),
  paymentChannelFund("PaymentChannelFund"),
  setRegularKey("SetRegularKey"),
  signerListSet("SignerListSet"),
  ticketCreate("TicketCreate"),
  trustSet("TrustSet"),
  unsupported("");

  final String value;
  const XRPLTransactionType(this.value);
  factory XRPLTransactionType.fromValue(String value,
      {XRPLTransactionType? defaultValue = XRPLTransactionType.unsupported}) {
    return values.firstWhere((element) => element.value == value,
        orElse: defaultValue == null ? null : () => defaultValue);
  }
}
