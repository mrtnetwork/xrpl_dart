/// Enum representing different types of account objects.
enum AccountObjectType {
  check("check"),
  depositPreauth("deposit_preauth"),
  escrow("escrow"),
  offer("offer"),
  paymentChannel("payment_channel"),
  signerList("signer_list"),
  state("state"),
  ticket("ticket"),
  nftOffer("nft_offer");

  final String value;
  const AccountObjectType(this.value);
}
