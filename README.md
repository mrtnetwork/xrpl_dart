# XRP Dart Package

This package provides functionality to sign XRP transactions using two popular cryptographic algorithms, 
ED25519 and SECP256K1. It allows developers to create and sign XRP transactions securely.

For BIP32 HD wallet, BIP39, and Secret storage definitions, please refer to the blockchain_utils package.

For BIP32 HD wallet, BIP39, and Secret storage definitions, please refer to the [blockchain_utils](https://github.com/mrtnetwork/blockchain_utils) package.

## Features

### Transaction Types
The XRP Ledger supports various transaction types, each serving a different purpose:

- Payment Transactions: Standard transactions used to send XRP or Issue from one address to another.
- Escrow Transactions: These transactions lock up XRP until certain conditions are met, providing a trustless way to facilitate delayed payments.
- TrustSet Transactions: Used to create or modify trust lines, enabling users to hold and trade assets other than XRP on the ledger.
- OrderBook Transactions: Used to place and cancel offers on the decentralized exchange within the XRP Ledger.
- PaymentChannel Transactions: Allow for off-chain payments using payment channels.
- NFT: Mint NFTs, cancel them, create offers, and seamlessly accept NFT offers
- Issue: Issue custom assets
- Automated Market Maker: operations like bidding, creation, deletion, deposits, voting
- RegularKey: transactions to set or update account regular keys
- Offer: creation, cancel
- multi-signature transaction

### Addresses
- classAddress: They are straightforward representations of the recipient's address on the XRP Ledger
- xAddress: newer format, which provides additional features and interoperability. xAddresses include destination tags by default and are designed to simplify cross-network transactions and improve address interoperability

### Sign
- Sign XRP transactions with ED25519 and SECP256K1 algorithms.

### JSON-RPC Support
communicate with XRP nodes via the JSON-RPC protocol
It has been attempted to embed all the methods into RPC; however, currently, most of the data APIs are delivered in JSON format, and they have not been modeled.

## EXAMPLES
At least one example has been created for each transaction type, which you can find in the 'examples' folder.

### Key and addresses
```
  /// create random privateKey
  final randomPrivate =
      XRPPrivateKey.random(algorithm: CryptoAlgorithm.SECP256K1);
  final toHex = randomPrivate.toHex();
  
  /// access private key with hex
  final private = XRPPrivateKey.fromHex(toHex);

  /// accesss publicKey
  final publicKey = private.getPublic();

  final addressClass = publicKey.toAddress();

  /// rpjEqWDFtoin7fFxuw6oQG2onkZkf72hhc
  final classicAddress = addressClass.address;

  /// X7ZBWLX4XnxEwvQa4sgH11QbhQzuTuGeoZKEb2naE92oNEc
  final xAddress = addressClass.toXAddress(isTestNetwork: false);

  /// sign with privateKey
  final sig = private.sign(...)
  
```
### Transaction
Each type of transaction has its own class for creating transactions
Descriptions for some of these classes are provided below.

- Simple payment
  
  ```
    final transaction = Payment(
      destination: destination, // destination account
      account: ownerAddress, // Sender account
      amount: amount, // The amount sent can be in XRP or any other token.
      signingPubKey: ownerPublic); // Sender's public key

  ```
- NTF, mint, createOffer, acceptOffer
   
  ```
  // mint token
  final transaction = NFTokenMint(
      flags: NFTokenMintFlag.TF_TRANSFERABLE.value,
      account: ownerAddress,
      uri: "...", // that points to the data and/or metadata associated with the NFT
      signingPubKey: ownerPublic,
      memos: [memo], // Additional arbitrary information attached to this transaction
      nftokenTaxon: 1); // Indicates the taxon associated with this token

  // create offer
  final offer = NFTokenCreateOffer(
    amount: CurrencyAmount.xrp(BigInt.from(1000000)),
    flags: NFTokenCreateOfferFlag.TF_SELL_NFTOKEN.value,
    nftokenId: tokenId, /// Identifies the TokenID of the NFToken object that the offer references. 
    account: ownerAddress,
    signingPubKey: ownerPublic,
    memos: [memo],
  );
  
  // accept offer
  final offer = NFTokenAcceptOffer(
    nfTokenSellOffer: offerId,
    account: ownerAddress,
    signingPubKey: ownerPublic,
    memos: [memo],
  );

  ```
- Completely create, sign, and send transactions
  ```
  // create escrowCreate transaction
  final escrowCreate = EscrowCreate(
    account: ownerAddress,
    destination: destination,
    cancelAfterTime: cancelAfterOnDay,
    finishAfterTime: finishAfterOneHours,
    amount: BigInt.from(25000000),
    condition:
        "A0258020E488CD4C1AC9A7673CA2D2712B47049B87C308181BF3B89D6FBB74FC36836BB5810120",
    signingPubKey: ownerPublic,
    memos: [memo],
  );

  // It receives the transaction, the RPC class, and then fulfills the transaction requirements, including the fee amount, account sequence, and the last network ledger sequence.
  await autoFill(rpc, escrowCreate);
  
  // At this point, we need to sign the transaction with the sender's account.
  // We receive the transaction blob and sign it with the sender's private key.
  final sig = owner.sign(escrowCreate.toBlob());
  // After completing the signature, we add it to the transaction.
  escrowCreate.setSignature(sig);

  /// In the final step, we need to send the transaction to the network.
  /// We receive another transaction blob that already contains a signature. At this point, we no longer need to include a signature, and we must set the 'forSigning' variable to false.
  final trBlob = escrowCreate.toBlob(forSigning: false);

  // broadcasting transaction
  final result = await rpc.submit(trBlob)
  // transaction hash: result.txJson.hash ()
  // engine result: result.engineResult result.engineResult
  // engine result message: result.engineResultMessage
  
  ```

### JSON-RPC
```
  /// access devent
  final devnetRPC = XRPLRpc.devNet();

  /// access testnet
  final testnetRPC = XRPLRpc.testNet();

  /// access mainnet
  final mainnetRPC = XRPLRpc.testNet();

  /// access amm-Devnet
  final ammDevnetRPC = XRPLRpc.ammDevnet();
  
  final customURL = XRPLRpc(JsonRPC("https://....", http.Client()));
  await devnetRPC.getFucent(address);

  await devnetRPC.getAccountTX(address);

  await devnetRPC.getFee();

  ...
```

## Contributing

Contributions are welcome! Please follow these guidelines:
 - Fork the repository and create a new branch.
 - Make your changes and ensure tests pass.
 - Submit a pull request with a detailed description of your changes.

## Feature requests and bugs #

Please file feature requests and bugs in the issue tracker.


