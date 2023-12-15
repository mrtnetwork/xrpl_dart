class XRPRequestMethod {
  // account methods
  static const String accountChannels = "account_channels";
  static const String accountCurrencies = "account_currencies";
  static const String accountInfo = "account_info";
  static const String accountLines = "account_lines";
  static const String accountNfts = "account_nfts";
  static const String accountObjects = "account_objects";
  static const String accountOffers = "account_offers";
  static const String accountTx = "account_tx";
  static const String gatewayBalances = "gateway_balances";
  static const String noRippleCheck = "noripple_check";

  // transaction methods
  static const String sign = "sign";
  static const String signFor = "sign_for";
  static const String submit = "submit";
  static const String submitMultisigned = "submit_multisigned";
  static const String transactionEntry = "transaction_entry";
  static const String tx = "tx";

  // channel methods
  static const String channelAuthorize = "channel_authorize";
  static const String channelVerify = "channel_verify";

  // path methods
  static const String bookOffers = "book_offers";
  static const String depositAuthorized = "deposit_authorized";
  static const String pathFind = "path_find";
  static const String ripplePathFind = "ripple_path_find";

  // ledger methods
  static const String ledger = "ledger";
  static const String ledgerClosed = "ledger_closed";
  static const String ledgerCurrent = "ledger_current";
  static const String ledgerData = "ledger_data";
  static const String ledgerEntry = "ledger_entry";

  // NFT methods
  static const String nftBuyOffers = "nft_buy_offers";
  static const String nftSellOffers = "nft_sell_offers";
  static const String nftInfo = "nft_info"; // clio only
  static const String nftHistory = "nft_history"; // clio only

  // subscription methods
  static const String subscribe = "subscribe";
  static const String unsubscribe = "unsubscribe";

  // server info methods
  static const String fee = "fee";
  static const String manifest = "manifest";
  static const String serverDefinitions = "server_definitions";
  static const String serverInfo = "server_info";
  static const String serverState = "server_state";

  // utility methods
  static const String ping = "ping";
  static const String random = "random";

  // amm methods
  static const String ammInfo = "amm_info";

  // generic unknown/unsupported request
  // (there is no XRPL analog, this model is specific to xrpl-py)
  static const String genericRequest = "zzgeneric_request";
}
