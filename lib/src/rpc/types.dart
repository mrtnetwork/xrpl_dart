// ignore_for_file: constant_identifier_names

enum AccountObjectType {
  CHECK("check"),
  DEPOSIT_PREAUTH("deposit_preauth"),
  ESCROW("escrow"),
  OFFER("offer"),
  PAYMENT_CHANNEL("payment_channel"),
  SIGNER_LIST("signer_list"),
  STATE("state"),
  TICKET("ticket"),
  NFT_OFFER("nft_offer");

  final String value;
  const AccountObjectType(this.value);
}
